/// HVAC Device Provider - Interface for device management
library;

import '../entities/hvac_device.dart';

/// Interface for HVAC device data access
abstract class HvacDeviceProvider {
  /// Get all HVAC devices
  Future<List<HvacDevice>> getAllHvacDevices();

  /// Watch for device list updates
  Stream<List<HvacDevice>> watchHvacDevices();

  /// Set the currently selected device
  void setSelectedDevice(String deviceId);
}
