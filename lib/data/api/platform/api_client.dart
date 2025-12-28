/// Abstract API client interface
library;

import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;

/// Platform-agnostic API client
abstract class ApiClient {
  /// Get gRPC channel (mobile/desktop only)
  ClientChannel? getGrpcChannel();

  /// Get HTTP client (all platforms)
  http.Client getHttpClient();

  /// Get auth token
  Future<String?> getAuthToken();

  /// Dispose resources
  void dispose();
}
