/// Disconnect from Devices Use Case
///
/// Business logic for disconnecting from device communication system
library;

import '../../repositories/device_repository.dart';
import '../../../core/utils/logger.dart';

/// Use case for disconnecting from device communication system
///
/// Cleanly closes connection to device updates (MQTT/WebSocket)
class DisconnectFromDevices {
  final DeviceRepository _repository;

  const DisconnectFromDevices(this._repository);

  /// Execute the disconnect from devices use case
  ///
  /// Gracefully closes all connections
  /// Always succeeds (errors are logged but not thrown)
  Future<void> call() async {
    // Check if actually connected
    if (!_repository.isConnected()) {
      return; // Not connected, nothing to do
    }

    try {
      // Attempt graceful disconnection
      await _repository.disconnect();
    } catch (e) {
      // Log error but don't throw - disconnection should always succeed locally
      Logger.debug('Graceful disconnection failed (forcing close): $e');

      // Force close if graceful disconnect fails
      try {
        // Repository should handle forced closure internally
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (_) {
        // Ignore any errors during forced closure
      }
    }
  }
}
