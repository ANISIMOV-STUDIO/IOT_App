/// Connect to Devices Use Case
///
/// Business logic for establishing connection to device communication system
library;

import '../../repositories/device_repository.dart';

/// Use case for connecting to device communication system
///
/// Establishes connection for real-time device updates (MQTT/WebSocket)
class ConnectToDevices {
  final DeviceRepository _repository;

  const ConnectToDevices(this._repository);

  /// Execute the connect to devices use case
  ///
  /// Establishes connection with retry logic
  /// Returns true on successful connection
  /// Throws [Exception] with descriptive message on failure
  Future<bool> call() async {
    // Check if already connected
    if (_repository.isConnected()) {
      return true; // Already connected, no action needed
    }

    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        await _repository.connect();

        // Verify connection was established
        if (_repository.isConnected()) {
          return true;
        }

        throw Exception('Connection established but not active');
      } catch (e) {
        retryCount++;

        if (retryCount >= maxRetries) {
          // Transform final error to domain exception
          if (e.toString().contains('network')) {
            throw Exception(
              'Cannot connect to device server. Check your internet connection',
            );
          } else if (e.toString().contains('unauthorized')) {
            throw Exception(
              'Authentication failed. Please login again',
            );
          } else if (e.toString().contains('timeout')) {
            throw Exception(
              'Connection timeout. The server may be unavailable',
            );
          } else {
            throw Exception(
              'Failed to connect to devices after $maxRetries attempts: ${e.toString()}',
            );
          }
        }

        // Wait before retrying
        await Future.delayed(retryDelay * retryCount);
      }
    }

    return false; // Should not reach here
  }
}
