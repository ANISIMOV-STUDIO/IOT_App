/// gRPC Service
///
/// High-level service for managing gRPC connections and services
library;

import 'package:flutter/foundation.dart';
import '../../data/grpc/grpc_client.dart';
import '../config/env_config.dart';

class GrpcService {
  GrpcClient? _client;

  /// Initialize gRPC connection
  Future<void> initialize() async {
    try {
      _client = GrpcClient(
        host: EnvConfig.grpcHost,
        port: EnvConfig.grpcPort,
        useTls: EnvConfig.grpcUseTls,
      );

      await _client!.connect();

      if (kDebugMode) {
        print('✅ gRPC Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ gRPC Service initialization failed: $e');
      }
      rethrow;
    }
  }

  /// Get gRPC client
  GrpcClient get client {
    if (_client == null) {
      throw Exception('gRPC client not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// Check if gRPC is connected
  bool get isConnected => _client?.isConnected ?? false;

  /// Disconnect from gRPC
  Future<void> disconnect() async {
    await _client?.disconnect();
    _client = null;
  }

  /// Reconnect to gRPC
  Future<void> reconnect() async {
    await disconnect();
    await initialize();
  }
}
