/// HTTP-based API client for web
library;

import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import 'package:hvac_control/core/config/api_config.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/data/api/http/interceptors/auth_http_interceptor.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/services/auth_service.dart';

class ApiClientWeb implements ApiClient {

  ApiClientWeb(this._authStorage, this._authService);
  final AuthStorageService _authStorage;
  final AuthService _authService;
  http.Client? _httpClient;
@override  String get baseUrl => ApiConfig.httpUrl;

  @override
  // gRPC не поддерживается на web
  ClientChannel? getGrpcChannel() => null;

  @override
  http.Client getHttpClient() => _httpClient ??= AuthHttpInterceptor(
      http.Client(),
      _authStorage,
      _authService,
    );

  @override
  Future<String?> getAuthToken() async {
    // 1. Проверяем наличие токена
    final hasToken = await _authStorage.hasToken();
    if (!hasToken) {
      return null;
    }

    // 2. Проверяем истек ли токен
    if (await _authStorage.isAccessTokenExpired()) {
      try {
        final refreshToken = await _authStorage.getRefreshToken();
        if (refreshToken != null) {
          // 3. Пытаемся обновить
          final response = await _authService.refreshToken(refreshToken);
          await _authStorage.saveTokens(response.accessToken, response.refreshToken);
          return response.accessToken;
        }
      } catch (e) {
        ApiLogger.error('Failed to refresh token in getAuthToken: $e');
        return null;
      }
    }

    // 4. Возвращаем валидный токен
    return _authStorage.getToken();
  }

  @override
  void dispose() {
    _httpClient?.close();
  }
}

/// Factory function for conditional imports
ApiClient createPlatformApiClient(
  AuthStorageService authStorage,
  AuthService authService,
) => ApiClientWeb(authStorage, authService);
