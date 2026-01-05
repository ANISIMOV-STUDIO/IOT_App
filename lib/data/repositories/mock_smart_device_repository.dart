/// Мок-репозиторий HVAC устройств
library;

import 'dart:async';
import '../../domain/entities/smart_device.dart';
import '../../domain/repositories/smart_device_repository.dart';
import '../mock/mock_data.dart';

class MockSmartDeviceRepository implements SmartDeviceRepository {
  final _controller = StreamController<List<SmartDevice>>.broadcast();
  late List<SmartDevice> _devices;

  MockSmartDeviceRepository() {
    _devices = _parseDevices(MockData.devices);
  }

  List<SmartDevice> _parseDevices(List<Map<String, dynamic>> json) {
    return json.map((d) => SmartDevice(
      id: d['id'] as String,
      name: d['name'] as String,
      type: _parseDeviceType(d['type'] as String),
      isOn: d['isOn'] as bool,
      roomId: d['roomId'] as String?,
      powerConsumption: (d['powerConsumption'] as num).toDouble(),
      activeTime: Duration(hours: d['activeHours'] as int),
      lastUpdated: DateTime.now(),
    )).toList();
  }

  SmartDeviceType _parseDeviceType(String type) {
    return SmartDeviceType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => SmartDeviceType.ventilation,
    );
  }

  @override
  Future<List<SmartDevice>> getAllDevices() async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['slow']!));
    return List.unmodifiable(_devices);
  }

  @override
  Future<List<SmartDevice>> getDevicesByRoom(String roomId) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal']!));
    return _devices.where((d) => d.roomId == roomId).toList();
  }

  @override
  Future<SmartDevice?> getDeviceById(String id) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast']!));
    // Используем cast и where вместо firstWhere + catch
    // для явной обработки случая "не найдено"
    final matches = _devices.where((d) => d.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<SmartDevice> toggleDevice(String id, bool isOn) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal']!));

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
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal']!));

    final index = _devices.indexWhere((d) => d.id == device.id);
    if (index == -1) throw Exception('Устройство не найдено: ${device.id}');

    _devices = List.from(_devices)..[index] = device;
    _controller.add(_devices);

    return device;
  }

  @override
  Stream<List<SmartDevice>> watchDevices() {
    Future.microtask(() => _controller.add(_devices));
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
