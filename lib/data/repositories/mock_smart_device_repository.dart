/// Мок-репозиторий умных устройств
library;

import 'dart:async';
import '../../domain/entities/smart_device.dart';
import '../../domain/repositories/smart_device_repository.dart';

class MockSmartDeviceRepository implements SmartDeviceRepository {
  final _controller = StreamController<List<SmartDevice>>.broadcast();
  
  List<SmartDevice> _devices = [
    SmartDevice(
      id: 'pv_1',
      name: 'ПВ-1',
      type: SmartDeviceType.ventilation,
      isOn: true,
      roomId: 'living_room',
      powerConsumption: 0.8,
      activeTime: const Duration(hours: 12),
      lastUpdated: DateTime.now(),
    ),
    SmartDevice(
      id: 'pv_2',
      name: 'ПВ-2',
      type: SmartDeviceType.ventilation,
      isOn: false,
      roomId: 'bedroom',
      powerConsumption: 0.6,
      activeTime: const Duration(hours: 8),
      lastUpdated: DateTime.now(),
    ),
    SmartDevice(
      id: 'pv_3',
      name: 'ПВ-3',
      type: SmartDeviceType.ventilation,
      isOn: true,
      roomId: 'office',
      powerConsumption: 0.7,
      activeTime: const Duration(hours: 6),
      lastUpdated: DateTime.now(),
    ),
  ];

  @override
  Future<List<SmartDevice>> getAllDevices() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Имитация задержки сети
    return List.unmodifiable(_devices);
  }

  @override
  Future<List<SmartDevice>> getDevicesByRoom(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _devices.where((d) => d.roomId == roomId).toList();
  }

  @override
  Future<SmartDevice?> getDeviceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _devices.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SmartDevice> toggleDevice(String id, bool isOn) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _devices.indexWhere((d) => d.id == id);
    if (index == -1) throw Exception('Устройство не найдено: $id');
    
    final updated = _devices[index].copyWith(
      isOn: isOn,
      lastUpdated: DateTime.now(),
    );
    
    _devices = List.from(_devices)..[index] = updated;
    _controller.add(_devices);
    
    return updated;
  }

  @override
  Future<SmartDevice> updateDevice(SmartDevice device) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _devices.indexWhere((d) => d.id == device.id);
    if (index == -1) throw Exception('Устройство не найдено: ${device.id}');
    
    _devices = List.from(_devices)..[index] = device;
    _controller.add(_devices);
    
    return device;
  }

  @override
  Stream<List<SmartDevice>> watchDevices() {
    // Сразу отдаём текущее состояние
    Future.microtask(() => _controller.add(_devices));
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
