/// gRPC-based API client for mobile/desktop
library;

import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../../../core/services/auth_storage_service.dart';
import '../../../core/logging/api_logger.dart';
import '../../services/auth_service.dart';
import '../http/interceptors/auth_http_interceptor.dart';
import 'api_client.dart';

class ApiClientMobile implements ApiClient {
  final AuthStorageService _authStorage;
  final AuthService _authService;
  ClientChannel? _channel;
  http.Client? _httpClient;

  ApiClientMobile(this._authStorage, this._authService);
@override  String get baseUrl => ApiConfig.httpUrl;

  @override
  ClientChannel getGrpcChannel() {
    return _channel ??= ClientChannel(
      ApiConfig.backendHost,
      port: 443, // Standard HTTPS port through nginx
      options: ChannelOptions(
        credentials: const ChannelCredentials.secure(),
        codecRegistry: CodecRegistry(codecs: const [GzipCodec()]),
      ),
    );
  }

  @override
  http.Client getHttpClient() {
    return _httpClient ??= AuthHttpInterceptor(
      http.Client(),
      _authStorage,
      _authService,
    );
  }

  @override
  Future<String?> getAuthToken() async {
    // 1. Проверяем наличие токена
    final hasToken = await _authStorage.hasToken();
    if (!hasToken) return null;

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
        // Если обновить не удалось (например, refresh token тоже истек)
        // возвращаем null или старый (пусть сервер вернет 401)
        // В данном случае лучше вернуть null, чтобы SignalR не спамил
        ApiLogger.error('Failed to refresh token in getAuthToken: $e');
        return null;
      }
    }

    // 4. Возвращаем валидный токен
    return await _authStorage.getToken();
  }

  @override
  void dispose() {
    _channel?.shutdown();
    _httpClient?.close();
  }
}

/// Factory function for conditional imports
ApiClient createPlatformApiClient(
  AuthStorageService authStorage,
  AuthService authService,
) {
  return ApiClientMobile(authStorage, authService);
}
