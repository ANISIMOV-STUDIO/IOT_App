/// HTTP-based API client for web
library;

import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/auth_storage_service.dart';
import 'api_client.dart';

class ApiClientWeb implements ApiClient {
  final AuthStorageService _authStorage;
  http.Client? _httpClient;

  ApiClientWeb(this._authStorage);

  @override
  ClientChannel? getGrpcChannel() {
    // gRPC не поддерживается на web
    return null;
  }

  @override
  http.Client getHttpClient() {
    return _httpClient ??= http.Client();
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
ApiClient createPlatformApiClient(AuthStorageService authStorage) {
  return ApiClientWeb(authStorage);
}
