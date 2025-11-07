/// Scan for Devices Use Case
///
/// Business logic for discovering available HVAC devices on the network
library;

import '../../repositories/device_repository.dart';

/// Device scan result information
class DeviceScanResult {
  final String macAddress;
  final String? name;
  final String? model;
  final String? firmware;
  final int signalStrength;
  final bool isPaired;
  final bool requiresPairing;

  const DeviceScanResult({
    required this.macAddress,
    this.name,
    this.model,
    this.firmware,
    required this.signalStrength,
    this.isPaired = false,
    this.requiresPairing = true,
  });
}

/// Use case for scanning for available devices
///
/// Discovers HVAC devices on the local network
class ScanForDevices {
  final DeviceRepository _repository;

  const ScanForDevices(this._repository);

  /// Execute the scan for devices use case
  ///
  /// Scans network for available HVAC devices
  /// Returns list of discovered devices
  /// Throws [Exception] with descriptive message on failure
  Future<List<DeviceScanResult>> call() async {
    try {
      // Perform device scan
      final devices = await _repository.scanForDevices();

      // Transform to domain scan results
      final results = devices.map((device) {
        // Calculate signal strength (mock for now)
        final signalStrength = _calculateSignalStrength(device.macAddress);

        return DeviceScanResult(
          macAddress: device.macAddress,
          name: device.name,
          model: device.model,
          firmware: device.firmware,
          signalStrength: signalStrength,
          isPaired: false, // Would be checked against existing devices
          requiresPairing: device.model?.contains('Secure') ?? true,
        );
      }).toList();

      // Sort by signal strength (strongest first)
      results.sort((a, b) => b.signalStrength.compareTo(a.signalStrength));

      return results;
    } catch (e) {
      // Transform repository exceptions to domain exceptions
      if (e.toString().contains('permission')) {
        throw Exception(
          'Location permission required to scan for devices',
        );
      } else if (e.toString().contains('wifi')) {
        throw Exception(
          'WiFi must be enabled to scan for devices',
        );
      } else if (e.toString().contains('bluetooth')) {
        throw Exception(
          'Bluetooth must be enabled to scan for devices',
        );
      } else if (e.toString().contains('network')) {
        throw Exception(
          'Network error during scan. Please check your connection',
        );
      } else if (e.toString().contains('timeout')) {
        throw Exception(
          'Device scan timeout. No devices found',
        );
      } else {
        throw Exception(
          'Failed to scan for devices: ${e.toString()}',
        );
      }
    }
  }

  /// Calculate mock signal strength based on MAC address
  /// In real implementation, this would come from the actual scan
  int _calculateSignalStrength(String macAddress) {
    // Mock implementation - use MAC address hash for consistent results
    final hash = macAddress.hashCode.abs();
    return 50 + (hash % 51); // Returns value between 50-100
  }
}
