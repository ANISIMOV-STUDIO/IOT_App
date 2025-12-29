/// HTTP Interceptor для автоматического обновления токенов
library;

import 'dart:async';
import 'package:http/http.dart' as http;

import '../../../../core/services/auth_storage_service.dart';
import '../../../services/auth_service.dart';
import '../../../../core/logging/api_logger.dart';

/// HTTP Client с автоматическим refresh токенов при 401
class AuthHttpInterceptor extends http.BaseClient {
  final http.Client _inner;
  final AuthStorageService _authStorage;
  final AuthService _authService;

  /// Future для синхронизации одновременных refresh запросов
  static Future<void>? _refreshingTokens;

  AuthHttpInterceptor(
    this._inner,
    this._authStorage,
    this._authService,
  );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 1. Добавить access token в заголовки
    final token = await _authStorage.getToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // 2. Отправить запрос
    var response = await _inner.send(request);

    // 3. Если 401 - попробовать обновить токены
    if (response.statusCode == 401) {
      final refreshToken = await _authStorage.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Синхронизация одновременных refresh запросов
          _refreshingTokens ??= _doRefreshTokens(refreshToken);

          await _refreshingTokens;
          _refreshingTokens = null;

          // 4. Повторить оригинальный запрос с новым токеном
          final newToken = await _authStorage.getToken();
          if (newToken != null) {
            final newRequest = _copyRequest(request);
            newRequest.headers['Authorization'] = 'Bearer $newToken';
            response = await _inner.send(newRequest);
          }
        } catch (e) {
          ApiLogger.logHttpError('REFRESH', 'Token refresh failed', e.toString());
          // Refresh не удался - вернуть оригинальный 401
          rethrow;
        }
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
      rethrow;
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
    requestCopy.persistentConnection = request.persistentConnection;
    requestCopy.followRedirects = request.followRedirects;
    requestCopy.maxRedirects = request.maxRedirects;

    return requestCopy;
  }

  @override
  void close() {
    _inner.close();
  }
}
