/// Мок-репозиторий умных устройств
library;

import 'dart:async';
import '../../domain/entities/smart_device.dart';
import '../../domain/repositories/smart_device_repository.dart';

class MockSmartDeviceRepository implements SmartDeviceRepository {
  final _controller = StreamController<List<SmartDevice>>.broadcast();
  
  List<SmartDevice> _devices = [
    SmartDevice(
      id: 'tv_1',
      name: 'Телевизор',
      type: SmartDeviceType.tv,
      isOn: true,
      roomId: 'living_room',
      powerConsumption: 5.0,
      activeTime: const Duration(hours: 3),
      lastUpdated: DateTime.now(),
    ),
    SmartDevice(
      id: 'speaker_1',
      name: 'Колонка',
      type: SmartDeviceType.speaker,
      isOn: true,
      roomId: 'living_room',
      powerConsumption: 2.0,
      activeTime: const Duration(hours: 5),
      lastUpdated: DateTime.now(),
    ),
    SmartDevice(
      id: 'router_1',
      name: 'Роутер',
      type: SmartDeviceType.router,
      isOn: false,
      roomId: 'hall',
      powerConsumption: 1.0,
      activeTime: const Duration(hours: 24),
      lastUpdated: DateTime.now(),
    ),
    SmartDevice(
      id: 'wifi_1',
      name: 'Wi-Fi',
      type: SmartDeviceType.wifi,
      isOn: true,
      roomId: 'hall',
      powerConsumption: 0.5,
      activeTime: const Duration(hours: 24),
      lastUpdated: DateTime.now(),
    ),
    SmartDevice(
      id: 'heater_1',
      name: 'Обогреватель',
      type: SmartDeviceType.heater,
      isOn: true,
      roomId: 'bedroom',
      powerConsumption: 15.0,
      activeTime: const Duration(hours: 2),
      lastUpdated: DateTime.now(),
    ),
    SmartDevice(
      id: 'socket_1',
      name: 'Розетка',
      type: SmartDeviceType.socket,
      isOn: false,
      roomId: 'kitchen',
      powerConsumption: 0.0,
      activeTime: Duration.zero,
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
