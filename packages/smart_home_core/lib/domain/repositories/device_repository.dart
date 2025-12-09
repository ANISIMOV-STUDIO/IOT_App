import 'package:smart_home_core/domain/entities/device.dart';

/// Repository interface for managing smart home devices
abstract class DeviceRepository {
  /// Stream of all available devices
  Stream<List<Device>> get devices;
  
  /// Get a specific device by ID
  Future<Device?> getDevice(String id);
  
  /// Update a device's state (e.g. power, temperature)
  /// Returns the updated device
  Future<Device> updateDevice(Device device);
  
  /// Refresh device list from source
  Future<void> refresh();
}
