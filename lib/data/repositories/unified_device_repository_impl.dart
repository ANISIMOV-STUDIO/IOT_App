import 'dart:async';
import 'package:smart_home_core/domain/entities/device.dart';
import 'package:smart_home_core/domain/entities/ventilation_device.dart';
import 'package:smart_home_core/domain/repositories/device_repository.dart';

/// Unified repository that handles devices from multiple sources
/// (Local Mock, MQTT, etc.)
class UnifiedDeviceRepositoryImpl implements DeviceRepository {
  late final StreamController<List<Device>> _controller;
  List<Device> _devices = [];

  UnifiedDeviceRepositoryImpl() {
    _controller = StreamController<List<Device>>.broadcast(
      onListen: () {
        // Emit current state immediately when a listener connects
        _controller.add(_devices);
      },
    );

    // Initialize with some mock data for the "Big Tech" demo
    _devices = [
      const VentilationDevice(
        id: 'vent-1',
        name: 'Living Room Ventilation',
        isPowerOn: true,
        currentTemperature: 24.5,
        targetTemperature: 22.0,
        fanSpeed: 45,
      ),
      const VentilationDevice(
        id: 'vent-2',
        name: 'Bedroom AC',
        isPowerOn: false,
        currentTemperature: 20.0,
        targetTemperature: 19.0,
        fanSpeed: 0,
      ),
    ];
  }

  void _emit() {
    _controller.add(_devices);
  }

  @override
  Stream<List<Device>> get devices => _controller.stream;

  @override
  Future<Device?> getDevice(String id) async {
    try {
      return _devices.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> refresh() async {
    // In real app, this would fetch from APIs
    await Future.delayed(const Duration(milliseconds: 500));
    _emit();
  }

  @override
  Future<Device> updateDevice(Device device) async {
    // Optimistic update
    final index = _devices.indexWhere((d) => d.id == device.id);
    if (index != -1) {
      _devices[index] = device;
      _emit();
    }
    return device;
  }
  
  void dispose() {
    _controller.close();
  }
}
