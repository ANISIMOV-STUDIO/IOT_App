/// gRPC-based API client for mobile/desktop
library;

import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import 'package:hvac_control/core/config/api_config.dart';
import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/data/api/http/interceptors/auth_http_interceptor.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/services/auth_service.dart';

class ApiClientMobile implements ApiClient {
  ApiClientMobile(this._authStorage, this._authService);

  final AuthStorageService _authStorage;
  final AuthService _authService;
  ClientChannel? _channel;
  http.Client? _httpClient;

  @override
  String get baseUrl => ApiConfig.httpUrl;

  @override
  ClientChannel getGrpcChannel() => _channel ??= ClientChannel(
      ApiConfig.backendHost,
      options: ChannelOptions(
        codecRegistry: CodecRegistry(codecs: const [GzipCodec()]),
      ),
    );

  @override
  http.Client getHttpClient() => _httpClient ??= AuthHttpInterceptor(
      http.Client(),
      _authStorage,
      _authService,
    );

  @override
  Future<String?> getAuthToken() async {
    // Просто возвращаем текущий токен.
    // Refresh токена происходит в AuthHttpInterceptor при 401.
    // Это исключает двойной refresh (превентивный + реактивный).
    final hasToken = await _authStorage.hasToken();
    if (!hasToken) {
      return null;
    }
    return _authStorage.getToken();
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
) => ApiClientMobile(authStorage, authService);
