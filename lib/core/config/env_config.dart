/// Environment Configuration
///
/// Handles environment variables and configuration
library;

import 'package:flutter/foundation.dart';

class EnvConfig {
  // Backend API Configuration
  static String get apiBaseUrl {
    return const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );
  }

  static String get grpcHost {
    return const String.fromEnvironment(
      'GRPC_HOST',
      defaultValue: 'localhost',
    );
  }

  static int get grpcPort {
    const portStr = String.fromEnvironment(
      'GRPC_PORT',
      defaultValue: '50051',
    );
    return int.tryParse(portStr) ?? 50051;
  }

  static bool get grpcUseTls {
    const useTls = String.fromEnvironment('GRPC_USE_TLS', defaultValue: 'false');
    return useTls.toLowerCase() == 'true';
  }

  /// Print configuration (for debugging)
  static void printConfig() {
    if (kDebugMode) {
      print('=== Environment Configuration ===');
      print('API Base URL: $apiBaseUrl');
      print('gRPC Host: $grpcHost:$grpcPort');
      print('gRPC TLS: ${grpcUseTls ? 'Enabled' : 'Disabled'}');
      print('=================================');
    }
  }
}
