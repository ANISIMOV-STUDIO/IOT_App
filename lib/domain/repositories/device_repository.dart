/// Device Repository Interface
///
/// Abstract repository defining the contract for device management operations
/// following clean architecture principles
library;

import '../entities/hvac_unit.dart';

/// Device information for adding new devices
class DeviceInfo {
  final String macAddress;
  final String name;
  final String? location;
  final String? model;
  final String? firmware;

  const DeviceInfo({
    required this.macAddress,
    required this.name,
    this.location,
    this.model,
    this.firmware,
  });
}

/// Interface for device management operations
abstract class DeviceRepository {
  /// Add a new device to the system
  /// Returns the newly added [HvacUnit] on success
  /// Throws [Exception] on failure
  Future<HvacUnit> addDevice(DeviceInfo deviceInfo);

  /// Remove a device from the system
  /// Returns true on successful removal
  /// Throws [Exception] on failure
  Future<bool> removeDevice(String deviceId);

  /// Connect to device communication system (MQTT/WebSocket)
  /// Establishes connection for real-time updates
  Future<void> connect();

  /// Disconnect from device communication system
  /// Closes active connections cleanly
  Future<void> disconnect();

  /// Check if connected to device communication system
  /// Returns true if actively connected
  bool isConnected();

  /// Scan for available devices on the network
  /// Returns list of discovered devices
  Future<List<DeviceInfo>> scanForDevices();

  /// Pair with a new device
  /// Performs device pairing/provisioning process
  Future<bool> pairDevice(String macAddress, String pairingCode);

  /// Reset device to factory settings
  /// WARNING: This will remove all device configurations
  Future<bool> factoryReset(String deviceId);

  /// Update device firmware
  /// Returns true if update initiated successfully
  Future<bool> updateFirmware(String deviceId, String firmwareVersion);

  /// Get device diagnostics information
  /// Returns diagnostic data as key-value pairs
  Future<Map<String, dynamic>> getDeviceDiagnostics(String deviceId);
}
