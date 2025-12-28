/// gRPC-based API client for mobile/desktop
library;

import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../../../core/services/auth_storage_service.dart';
import 'api_client.dart';

class ApiClientMobile implements ApiClient {
  final AuthStorageService _authStorage;
  ClientChannel? _channel;
  http.Client? _httpClient;

  ApiClientMobile(this._authStorage);

  @override
  ClientChannel getGrpcChannel() {
    return _channel ??= ClientChannel(
      ApiConfig.backendHost,
      port: ApiConfig.grpcPort,
      options: ChannelOptions(
        credentials: const ChannelCredentials.secure(),
        codecRegistry: CodecRegistry(codecs: const [GzipCodec()]),
      ),
    );
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
    _channel?.shutdown();
    _httpClient?.close();
  }
}

/// Factory function for conditional imports
ApiClient createPlatformApiClient(AuthStorageService authStorage) {
  return ApiClientMobile(authStorage);
}
