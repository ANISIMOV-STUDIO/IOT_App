/// gRPC Auth Interceptor
/// Adds authorization header to all gRPC calls with UNAUTHENTICATED handling
library;

import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:hvac_control/core/error/session_expired_exception.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/data/api/http/interceptors/auth_http_interceptor.dart';
import 'package:hvac_control/data/services/auth_service.dart';

/// Interceptor that adds Bearer token to gRPC calls and handles UNAUTHENTICATED
class AuthGrpcInterceptor extends ClientInterceptor {
  AuthGrpcInterceptor(
    this._getToken, [
    this._authStorage,
    this._authService,
  ]);

  final Future<String?> Function() _getToken;
  final AuthStorageService? _authStorage;
  final AuthService? _authService;

  /// Completer для синхронизации конкурентных refresh запросов
  static Completer<bool>? _refreshCompleter;

  /// Сбросить состояние refresh
  static void resetRefreshState() {
    _refreshCompleter = null;
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) => invoker(
      method,
      request,
      options.mergedWith(_authOptions()),
    );

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) => invoker(
      method,
      requests,
      options.mergedWith(_authOptions()),
    );

  /// Попробовать обновить токены, синхронизируясь с HTTP interceptor
  Future<bool> tryRefreshToken() async {
    if (_authStorage == null || _authService == null) {
      return false;
    }

    // Если уже идёт refresh - ждём его завершения и возвращаем результат
    if (_refreshCompleter != null) {
      ApiLogger.debug('[gRPC] Waiting for existing refresh to complete');
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await _authStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        ApiLogger.error('[gRPC] No refresh token available');
        _refreshCompleter?.complete(false);
        return false;
      }

      ApiLogger.debug('[gRPC] Attempting token refresh');

      final authResponse = await _authService.refreshToken(refreshToken);

      await _authStorage.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );

      // Сбросить флаг sessionExpired в HTTP interceptor
      AuthHttpInterceptor.resetSessionState();

      ApiLogger.debug('[gRPC] Token refresh successful');
      _refreshCompleter?.complete(true);
      return true;
    } catch (e) {
      ApiLogger.error('[gRPC] Token refresh failed: $e');
      _refreshCompleter?.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  CallOptions _authOptions() => CallOptions(
      providers: [
        (metadata, uri) async {
          final token = await _getToken();
          if (token != null) {
            metadata['authorization'] = 'Bearer $token';
          }
        },
      ],
    );
}

/// Extension для обработки gRPC ошибок с retry
extension GrpcRetryExtension<T> on Future<T> {
  /// Выполнить с retry при UNAUTHENTICATED
  Future<T> withGrpcRetry(
    AuthGrpcInterceptor interceptor,
    Future<T> Function() retry,
  ) async {
    try {
      return await this;
    } on GrpcError catch (e) {
      if (e.code == StatusCode.unauthenticated) {
        // Попробовать refresh токена
        final refreshed = await interceptor.tryRefreshToken();

        if (refreshed) {
          // Повторить запрос с новым токеном
          try {
            return await retry();
          } on GrpcError catch (retryError) {
            if (retryError.code == StatusCode.unauthenticated) {
              throw const SessionExpiredException('gRPC: Session expired after refresh');
            }
            rethrow;
          }
        } else {
          throw const SessionExpiredException('gRPC: Token refresh failed');
        }
      }
      rethrow;
    }
  }
}
