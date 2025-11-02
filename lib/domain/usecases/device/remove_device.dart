/// Remove Device Use Case
///
/// Business logic for removing HVAC devices from the system
library;

import '../../repositories/device_repository.dart';
import '../../../core/utils/logger.dart';

/// Parameters for removing a device
class RemoveDeviceParams {
  final String deviceId;
  final bool factoryReset;

  const RemoveDeviceParams({
    required this.deviceId,
    this.factoryReset = false,
  });
}

/// Use case for removing devices
///
/// Handles business logic for device removal with optional factory reset
class RemoveDevice {
  final DeviceRepository _repository;

  const RemoveDevice(this._repository);

  /// Execute the remove device use case
  ///
  /// Removes device from system with optional factory reset
  /// Returns true on successful removal
  /// Throws [Exception] with descriptive message on failure
  Future<bool> call(RemoveDeviceParams params) async {
    // Validate device ID
    if (params.deviceId.trim().isEmpty) {
      throw Exception('Device ID cannot be empty');
    }

    try {
      // Perform factory reset if requested
      if (params.factoryReset) {
        try {
          await _repository.factoryReset(params.deviceId);
        } catch (e) {
          // Log factory reset failure but continue with removal
          Logger.debug('Factory reset failed (continuing with removal): $e');
        }
      }

      // Remove device from system
      final removed = await _repository.removeDevice(params.deviceId);

      if (!removed) {
        throw Exception('Device removal failed');
      }

      return true;
    } catch (e) {
      // Transform repository exceptions to domain exceptions
      if (e.toString().contains('not found') ||
          e.toString().contains('404')) {
        throw Exception('Device not found');
      } else if (e.toString().contains('network')) {
        throw Exception('Network error. Please check your connection');
      } else if (e.toString().contains('unauthorized')) {
        throw Exception('You do not have permission to remove devices');
      } else if (e.toString().contains('in use')) {
        throw Exception('Cannot remove device while it is in use');
      } else {
        throw Exception('Failed to remove device: ${e.toString()}');
      }
    }
  }
}