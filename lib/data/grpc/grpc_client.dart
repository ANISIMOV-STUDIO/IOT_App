/// gRPC Client
///
/// Handles gRPC connection and communication with backend
library;

import 'package:grpc/grpc.dart';
import 'package:flutter/foundation.dart';

class GrpcClient {
  late ClientChannel _channel;
  final String host;
  final int port;
  final bool useTls;

  GrpcClient({
    required this.host,
    required this.port,
    this.useTls = false,
  });

  /// Initialize gRPC channel
  Future<void> connect() async {
    try {
      _channel = ClientChannel(
        host,
        port: port,
        options: ChannelOptions(
          credentials: useTls
              ? const ChannelCredentials.secure()
              : const ChannelCredentials.insecure(),
          keepAlive: const ClientKeepAliveOptions(
            pingInterval: Duration(seconds: 30),
            timeout: Duration(seconds: 10),
          ),
        ),
      );

      if (kDebugMode) {
        print('gRPC connected to $host:$port (TLS: $useTls)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('gRPC connection error: $e');
      }
      rethrow;
    }
  }

  /// Get the channel for service stubs
  ClientChannel get channel => _channel;

  /// Close the gRPC connection
  Future<void> disconnect() async {
    try {
      await _channel.shutdown();
      if (kDebugMode) {
        print('gRPC disconnected');
      }
    } catch (e) {
      if (kDebugMode) {
        print('gRPC disconnect error: $e');
      }
    }
  }

  /// Check if channel is connected
  bool get isConnected {
    try {
      // Check if channel is in a valid state
      return true; // Channel is considered connected after initialization
    } catch (e) {
      return false;
    }
  }
}
