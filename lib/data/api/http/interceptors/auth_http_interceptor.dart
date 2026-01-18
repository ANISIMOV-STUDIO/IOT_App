/// HTTP Interceptor для автоматического обновления токенов
library;

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:hvac_control/core/error/session_expired_exception.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/data/services/auth_service.dart';

/// HTTP Client с автоматическим refresh токенов при 401
class AuthHttpInterceptor extends http.BaseClient {
  AuthHttpInterceptor(
    this._inner,
    this._authStorage,
    this._authService,
  );

  final http.Client _inner;
  final AuthStorageService _authStorage;
  final AuthService _authService;

  /// Future для синхронизации одновременных refresh запросов
  static Future<void>? _refreshingTokens;

  /// Флаг истёкшей сессии - для быстрого fail без повторных попыток refresh
  static bool _sessionExpired = false;

  /// Сбросить состояние сессии (вызывать при новом логине)
  static void resetSessionState() {
    _sessionExpired = false;
    _refreshingTokens = null;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Быстрый fail если сессия уже истекла
    if (_sessionExpired) {
      throw const SessionExpiredException('Session already expired');
    }

    // 1. Добавить access token в заголовки
    final token = await _authStorage.getToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // 2. Отправить запрос
    var response = await _inner.send(request);

    // 3. Если 401 - попробовать обновить токены
    if (response.statusCode == 401) {
      // Быстрый fail если сессия уже истекла (другой запрос уже пробовал refresh)
      if (_sessionExpired) {
        throw const SessionExpiredException('Session already expired');
      }

      final refreshToken = await _authStorage.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Синхронизация одновременных refresh запросов
          _refreshingTokens ??= _doRefreshTokens(refreshToken);

          await _refreshingTokens;

          // 4. Повторить оригинальный запрос с новым токеном
          final newToken = await _authStorage.getToken();
          if (newToken != null) {
            final newRequest = _copyRequest(request);
            newRequest.headers['Authorization'] = 'Bearer $newToken';
            response = await _inner.send(newRequest);
          }
        } on SessionExpiredException {
          // Пробросить дальше
          rethrow;
        } catch (e) {
          ApiLogger.logHttpError('REFRESH', 'Token refresh failed', e.toString());
          // Помечаем сессию как истёкшую
          _sessionExpired = true;
          throw const SessionExpiredException('Token refresh failed');
        } finally {
          // КРИТИЧНО: Гарантированная очистка даже при exception
          _refreshingTokens = null;
        }
      } else {
        // Нет refresh token - сессия истекла
        _sessionExpired = true;
        throw const SessionExpiredException('No refresh token available');
      }
    }

    return response;
  }

  /// Обновить токены через refresh endpoint
  Future<void> _doRefreshTokens(String refreshToken) async {
    try {
      ApiLogger.logHttpRequest('POST', '/auth/refresh', null);

      final authResponse = await _authService.refreshToken(refreshToken);

      // Сохранить новые токены
      await _authStorage.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );

      ApiLogger.logHttpResponse('POST', '/auth/refresh', 200, 'Tokens refreshed');
    } catch (e) {
      ApiLogger.logHttpError('POST', '/auth/refresh', e.toString());
      // Помечаем сессию как истёкшую
      _sessionExpired = true;
      throw SessionExpiredException('Refresh failed: $e');
    }
  }

  /// Скопировать request для повторной отправки
  http.BaseRequest _copyRequest(http.BaseRequest request) {
    http.BaseRequest requestCopy;

    if (request is http.Request) {
      requestCopy = http.Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
    } else if (request is http.MultipartRequest) {
      requestCopy = http.MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else if (request is http.StreamedRequest) {
      throw Exception('StreamedRequest cannot be copied');
    } else {
      throw Exception('Unknown request type');
    }

    requestCopy.headers.addAll(request.headers);
    requestCopy
      ..persistentConnection = request.persistentConnection
      ..followRedirects = request.followRedirects
      ..maxRedirects = request.maxRedirects;

    return requestCopy;
  }

  @override
  void close() {
    _inner.close();
  }
}
