/// HTTP-based API client for web
library;

import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/auth_storage_service.dart';
import '../../services/auth_service.dart';
import '../http/interceptors/auth_http_interceptor.dart';
import 'api_client.dart';

class ApiClientWeb implements ApiClient {
  final AuthStorageService _authStorage;
  final AuthService _authService;
  http.Client? _httpClient;

  ApiClientWeb(this._authStorage, this._authService);

  @override
  ClientChannel? getGrpcChannel() {
    // gRPC не поддерживается на web
    return null;
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
    return await _authStorage.getToken();
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
) {
  return ApiClientWeb(authStorage, authService);
}
