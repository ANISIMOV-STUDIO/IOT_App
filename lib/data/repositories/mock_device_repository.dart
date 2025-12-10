import 'dart:async';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

/// Мок-репозиторий устройств с фейковыми данными
class MockDeviceRepository implements DeviceRepository {
  // Эмуляция базы данных
  final Map<String, Device> _devices = {};
  final _controller = StreamController<List<Device>>.broadcast();

  MockDeviceRepository() {
    _initMockData();
  }

  void _initMockData() {
    final mockDevices = [
      const Device(
        id: 'tv_1',
        name: 'Телевизор',
        type: DeviceType.tv,
        isOn: true,
        roomId: 'living_room',
        powerConsumption: 5.0,
        activeTime: Duration(hours: 3),
      ),
      const Device(
        id: 'speaker_1',
        name: 'Колонка',
        type: DeviceType.speaker,
        isOn: true,
        roomId: 'living_room',
        powerConsumption: 2.0,
        activeTime: Duration(hours: 5),
      ),
      const Device(
        id: 'router_1',
        name: 'Роутер',
        type: DeviceType.router,
        isOn: false,
        roomId: 'hall',
        powerConsumption: 0.5,
        activeTime: Duration(hours: 24),
      ),
      const Device(
        id: 'wifi_1',
        name: 'Wi-Fi',
        type: DeviceType.wifi,
        isOn: true,
        roomId: 'hall',
        powerConsumption: 0.3,
        activeTime: Duration(hours: 24),
      ),
      const Device(
        id: 'heater_1',
        name: 'Обогреватель',
        type: DeviceType.heater,
        isOn: true,
        roomId: 'bedroom',
        powerConsumption: 15.0,
        activeTime: Duration(hours: 2),
      ),
      const Device(
        id: 'socket_1',
        name: 'Розетка',
        type: DeviceType.socket,
        isOn: false,
        roomId: 'kitchen',
        powerConsumption: 0.0,
        activeTime: Duration.zero,
      ),
      const Device(
        id: 'ac_1',
        name: 'Кондиционер',
        type: DeviceType.airConditioner,
        isOn: true,
        roomId: 'living_room',
        powerConsumption: 12.0,
        activeTime: Duration(hours: 4),
      ),
      const Device(
        id: 'lamp_1',
        name: 'Умная лампа',
        type: DeviceType.lamp,
        isOn: true,
        roomId: 'bedroom',
        powerConsumption: 0.1,
        activeTime: Duration(hours: 6),
      ),
    ];

    for (final device in mockDevices) {
      _devices[device.id] = device;
    }
  }

  void _notifyListeners() {
    _controller.add(_devices.values.toList());
  }

  @override
  Future<List<Device>> getDevices() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Имитация сети
    return _devices.values.toList();
  }

  @override
  Future<List<Device>> getDevicesByRoom(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _devices.values.where((d) => d.roomId == roomId).toList();
  }

  @override
  Future<Device?> getDevice(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _devices[id];
  }

  @override
  Future<Device> toggleDevice(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final device = _devices[id];
    if (device == null) throw Exception('Устройство не найдено: $id');

    final updated = device.copyWith(
      isOn: !device.isOn,
      activeTime: !device.isOn ? Duration.zero : device.activeTime,
    );
    _devices[id] = updated;
    _notifyListeners();
    
    return updated;
  }

  @override
  Future<Device> updateDevice(String id, Map<String, dynamic> settings) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final device = _devices[id];
    if (device == null) throw Exception('Устройство не найдено: $id');

    final updated = device.copyWith(settings: {...?device.settings, ...settings});
    _devices[id] = updated;
    _notifyListeners();
    
    return updated;
  }

  @override
  Stream<List<Device>> watchDevices() {
    // Сразу отдаём текущее состояние
    Future.microtask(() => _notifyListeners());
    return _controller.stream;
  }

  @override
  Stream<Device> watchDevice(String id) {
    return watchDevices().map((devices) => 
      devices.firstWhere((d) => d.id == id)
    );
  }

  void dispose() {
    _controller.close();
  }
}
