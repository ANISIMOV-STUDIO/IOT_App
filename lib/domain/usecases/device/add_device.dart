/// Add Device Use Case
///
/// Business logic for adding new HVAC devices to the system
library;

import '../../entities/hvac_unit.dart';
import '../../repositories/device_repository.dart';

/// Parameters for adding a device
class AddDeviceParams {
  final String macAddress;
  final String name;
  final String? location;
  final String? model;
  final String? pairingCode;

  const AddDeviceParams({
    required this.macAddress,
    required this.name,
    this.location,
    this.model,
    this.pairingCode,
  });
}

/// Use case for adding new devices
///
/// Handles business logic for device registration and pairing
class AddDevice {
  final DeviceRepository _repository;

  const AddDevice(this._repository);

  /// Execute the add device use case
  ///
  /// Validates input and adds device to system
  /// Returns newly added [HvacUnit] on success
  /// Throws [Exception] with descriptive message on failure
  Future<HvacUnit> call(AddDeviceParams params) async {
    // Validate MAC address format
    if (!_isValidMacAddress(params.macAddress)) {
      throw Exception('Invalid MAC address format. Use XX:XX:XX:XX:XX:XX');
    }

    // Validate device name
    if (params.name.trim().isEmpty) {
      throw Exception('Device name cannot be empty');
    }

    if (params.name.trim().length > 50) {
      throw Exception('Device name must be 50 characters or less');
    }

    // Validate location if provided
    if (params.location != null && params.location!.trim().length > 100) {
      throw Exception('Location must be 100 characters or less');
    }

    try {
      // If pairing code provided, attempt pairing first
      if (params.pairingCode != null) {
        final paired = await _repository.pairDevice(
          params.macAddress,
          params.pairingCode!,
        );

        if (!paired) {
          throw Exception('Device pairing failed. Check the pairing code');
        }
      }

      // Create device info
      final deviceInfo = DeviceInfo(
        macAddress: params.macAddress.toUpperCase(),
        name: params.name.trim(),
        location: params.location?.trim(),
        model: params.model,
      );

      // Add device to system
      final device = await _repository.addDevice(deviceInfo);

      return device;
    } catch (e) {
      // Transform repository exceptions to domain exceptions
      if (e.toString().contains('already exists') ||
          e.toString().contains('409')) {
        throw Exception('A device with this MAC address already exists');
      } else if (e.toString().contains('network')) {
        throw Exception('Network error. Please check your connection');
      } else if (e.toString().contains('unauthorized')) {
        throw Exception('You do not have permission to add devices');
      } else if (e.toString().contains('pairing')) {
        throw Exception('Device pairing failed: ${e.toString()}');
      } else {
        throw Exception('Failed to add device: ${e.toString()}');
      }
    }
  }

  /// Validate MAC address format
  bool _isValidMacAddress(String mac) {
    // Accept formats: XX:XX:XX:XX:XX:XX or XX-XX-XX-XX-XX-XX
    final macRegex = RegExp(
      r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$',
    );
    return macRegex.hasMatch(mac);
  }
}
