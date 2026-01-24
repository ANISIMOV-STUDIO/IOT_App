/// Мок-репозиторий климат-контроля
///
/// Используется для разработки UI без backend.
library;

import 'dart:async';

import 'package:hvac_control/data/mock/mock_data.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';

class MockClimateRepository implements ClimateRepository {

  MockClimateRepository() {
    _initializeFromMockData();
  }
  final _climateController = StreamController<ClimateState>.broadcast();
  final _devicesController = StreamController<List<HvacDevice>>.broadcast();

  final Map<String, ClimateState> _deviceStates = {};
  final Map<String, _DeviceMeta> _deviceMeta = {};
  String? _selectedDeviceId;

  void _initializeFromMockData() {
    for (final device in MockData.hvacDevices) {
      final id = device['id'] as String;
      final climate = device['climate'] as Map<String, dynamic>;

      _deviceStates[id] = ClimateState(
        roomId: climate['roomId'] as String,
        deviceName: climate['deviceName'] as String,
        currentTemperature: (climate['currentTemperature'] as num).toDouble(),
        targetTemperature: (climate['targetTemperature'] as num).toDouble(),
        humidity: (climate['humidity'] as num).toDouble(),
        targetHumidity: (climate['targetHumidity'] as num).toDouble(),
        supplyAirflow: (climate['supplyAirflow'] as num).toDouble(),
        exhaustAirflow: (climate['exhaustAirflow'] as num).toDouble(),
        mode: _parseClimateMode(climate['mode'] as String),
        preset: climate['preset'] as String,
        airQuality: _parseAirQuality(climate['airQuality'] as String),
        co2Ppm: climate['co2Ppm'] as int,
        pollutantsAqi: climate['pollutantsAqi'] as int,
        isOn: climate['isOn'] as bool,
      );

      _deviceMeta[id] = _DeviceMeta(
        macAddress: device['macAddress'] as String? ?? '',
        deviceType: _parseDeviceType(device['type'] as String?),
        isOnline: device['isOnline'] as bool,
      );
    }

    if (MockData.hvacDevices.isNotEmpty) {
      _selectedDeviceId = MockData.hvacDevices.first['id'] as String;
    }
  }

  ClimateMode _parseClimateMode(String mode) => ClimateMode.values.firstWhere(
      (e) => e.name == mode,
      orElse: () => ClimateMode.auto,
    );

  AirQualityLevel _parseAirQuality(String quality) => AirQualityLevel.values.firstWhere(
      (e) => e.name == quality,
      orElse: () => AirQualityLevel.good,
    );

  HvacDeviceType _parseDeviceType(String? type) {
    if (type == null) {
      return HvacDeviceType.ventilation;
    }
    switch (type.toLowerCase()) {
      case 'ventilation':
        return HvacDeviceType.ventilation;
      case 'airconditioner':
      case 'ac':
        return HvacDeviceType.airConditioner;
      case 'heatpump':
        return HvacDeviceType.heatPump;
      default:
        return HvacDeviceType.generic;
    }
  }

  // ============================================
  // MULTI-DEVICE SUPPORT
  // ============================================

  @override
  Future<List<HvacDevice>> getAllHvacDevices() async {
    await Future<void>.delayed(MockData.fastDelay);
    return _buildDeviceList();
  }

  @override
  Future<ClimateState> getDeviceState(String deviceId) async {
    await Future<void>.delayed(MockData.fastDelay);
    return _deviceStates[deviceId] ?? _deviceStates.values.first;
  }

  @override
  Stream<List<HvacDevice>> watchHvacDevices() {
    Future.microtask(() => _devicesController.add(_buildDeviceList()));
    return _devicesController.stream;
  }

  @override
  Stream<ClimateState> watchDeviceClimate(String deviceId) => _climateController.stream;

  @override
  void setSelectedDevice(String deviceId) {
    if (_deviceStates.containsKey(deviceId)) {
      _selectedDeviceId = deviceId;
      final state = _deviceStates[deviceId];
      if (state != null) {
        _climateController.add(state);
      }
    }
  }

  List<HvacDevice> _buildDeviceList() => _deviceStates.entries.where((entry) => _deviceMeta.containsKey(entry.key)).map((entry) {
      final meta = _deviceMeta[entry.key]!;
      final state = entry.value;
      return HvacDevice(
        id: entry.key,
        name: state.deviceName,
        macAddress: meta.macAddress,
        deviceType: meta.deviceType,
        isOnline: meta.isOnline,
        isActive: state.isOn,
      );
    }).toList();

  void _notifyDeviceChange(String deviceId) {
    _devicesController.add(_buildDeviceList());
    if (deviceId == _selectedDeviceId) {
      final state = _deviceStates[deviceId];
      if (state != null) {
        _climateController.add(state);
      }
    }
  }

  // ============================================
  // LEGACY (single device)
  // ============================================

  @override
  Future<ClimateState> getCurrentState() async {
    await Future<void>.delayed(MockData.normalDelay);
    if (_selectedDeviceId != null && _deviceStates.containsKey(_selectedDeviceId)) {
      return _deviceStates[_selectedDeviceId]!;
    }
    return _deviceStates.values.first;
  }

  @override
  Stream<ClimateState> watchClimate() {
    Future.microtask(() {
      if (_selectedDeviceId != null && _deviceStates.containsKey(_selectedDeviceId)) {
        _climateController.add(_deviceStates[_selectedDeviceId]!);
      } else if (_deviceStates.values.isNotEmpty) {
        _climateController.add(_deviceStates.values.first);
      }
    });
    return _climateController.stream;
  }

  // ============================================
  // DEVICE CONTROL
  // ============================================

  String _resolveDeviceId(String? deviceId) => deviceId ?? _selectedDeviceId ?? _deviceStates.keys.first;

  @override
  Future<ClimateState> setPower({required bool isOn, String? deviceId}) async {
    await Future<void>.delayed(MockData.slowDelay);
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState != null) {
      _deviceStates[id] = currentState.copyWith(isOn: isOn);
      _notifyDeviceChange(id);
      return _deviceStates[id]!;
    }
    throw Exception('Device not found: $id');
  }

  @override
  Future<ClimateState> setTargetTemperature(double temperature, {String? deviceId}) async => setHeatingTemperature(temperature.toInt(), deviceId: deviceId);

  @override
  Future<ClimateState> setHeatingTemperature(int temperature, {String? deviceId}) async {
    await Future<void>.delayed(MockData.fastDelay);
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState != null) {
      _deviceStates[id] = currentState.copyWith(targetTemperature: temperature.toDouble());
      _notifyDeviceChange(id);
      return _deviceStates[id]!;
    }
    throw Exception('Device not found: $id');
  }

  @override
  Future<ClimateState> setCoolingTemperature(int temperature, {String? deviceId}) async {
    await Future<void>.delayed(MockData.fastDelay);
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState != null) {
      _deviceStates[id] = currentState.copyWith(targetTemperature: temperature.toDouble());
      _notifyDeviceChange(id);
      return _deviceStates[id]!;
    }
    throw Exception('Device not found: $id');
  }

  @override
  Future<ClimateState> setHumidity(double humidity, {String? deviceId}) async {
    await Future<void>.delayed(MockData.fastDelay);
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState != null) {
      _deviceStates[id] = currentState.copyWith(targetHumidity: humidity);
      _notifyDeviceChange(id);
      return _deviceStates[id]!;
    }
    throw Exception('Device not found: $id');
  }

  @override
  Future<ClimateState> setMode(ClimateMode mode, {String? deviceId}) async {
    await Future<void>.delayed(MockData.normalDelay);
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState != null) {
      _deviceStates[id] = currentState.copyWith(
        mode: mode,
        isOn: mode != ClimateMode.off,
      );
      _notifyDeviceChange(id);
      return _deviceStates[id]!;
    }
    throw Exception('Device not found: $id');
  }

  @override
  Future<ClimateState> setSupplyAirflow(double value, {String? deviceId}) async {
    await Future<void>.delayed(MockData.fastDelay);
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState != null) {
      _deviceStates[id] = currentState.copyWith(supplyAirflow: value);
      _notifyDeviceChange(id);
      return _deviceStates[id]!;
    }
    throw Exception('Device not found: $id');
  }

  @override
  Future<ClimateState> setExhaustAirflow(double value, {String? deviceId}) async {
    await Future<void>.delayed(MockData.fastDelay);
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState != null) {
      _deviceStates[id] = currentState.copyWith(exhaustAirflow: value);
      _notifyDeviceChange(id);
      return _deviceStates[id]!;
    }
    throw Exception('Device not found: $id');
  }

  @override
  Future<ClimateState> setPreset(String preset, {String? deviceId}) async {
    await Future<void>.delayed(MockData.normalDelay);
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState == null) {
      throw Exception('Device not found: $id');
    }

    var newState = currentState.copyWith(preset: preset);

    final presetConfig = MockData.climatePresets[preset];
    if (presetConfig != null) {
      if (presetConfig.containsKey('mode')) {
        newState = newState.copyWith(mode: _parseClimateMode(presetConfig['mode'] as String));
      }
      if (presetConfig.containsKey('targetTemperature')) {
        newState = newState.copyWith(targetTemperature: (presetConfig['targetTemperature'] as num).toDouble());
      }
      if (presetConfig.containsKey('supplyAirflow')) {
        newState = newState.copyWith(supplyAirflow: (presetConfig['supplyAirflow'] as num).toDouble());
      }
      if (presetConfig.containsKey('exhaustAirflow')) {
        newState = newState.copyWith(exhaustAirflow: (presetConfig['exhaustAirflow'] as num).toDouble());
      }
    }

    _deviceStates[id] = newState;
    _notifyDeviceChange(id);
    return newState;
  }

  @override
  Future<ClimateState> setOperatingMode(String mode, {String? deviceId}) async {
    await Future<void>.delayed(MockData.normalDelay);
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState == null) {
      throw Exception('Device not found: $id');
    }
    // В мок репозитории просто сохраняем как preset
    final newState = currentState.copyWith(preset: mode);
    _deviceStates[id] = newState;
    _notifyDeviceChange(id);
    return newState;
  }

  @override
  Future<HvacDevice> registerDevice(String macAddress, String name) async {
    await Future<void>.delayed(MockData.normalDelay);
    final newId = 'pv_${_deviceStates.length + 1}';
    final newState = ClimateState(
      roomId: newId,
      deviceName: name,
      isOn: false,
      currentTemperature: 20,
      targetTemperature: 22,
      humidity: 45,
      mode: ClimateMode.auto,
      exhaustAirflow: 50,
      airQuality: AirQualityLevel.good,
    );
    _deviceStates[newId] = newState;
    _deviceMeta[newId] = _DeviceMeta(
      macAddress: macAddress,
      deviceType: HvacDeviceType.ventilation,
      isOnline: true,
    );
    _devicesController.add(_buildDeviceList());
    return HvacDevice(
      id: newId,
      name: name,
      macAddress: macAddress,
    );
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    await Future<void>.delayed(MockData.normalDelay);
    _deviceStates.remove(deviceId);
    _deviceMeta.remove(deviceId);
    _devicesController.add(_buildDeviceList());
  }

  @override
  Future<void> renameDevice(String deviceId, String newName) async {
    await Future<void>.delayed(MockData.normalDelay);
    final state = _deviceStates[deviceId];
    if (state != null) {
      _deviceStates[deviceId] = state.copyWith(deviceName: newName);
      _devicesController.add(_buildDeviceList());
    }
  }

  @override
  Future<DeviceFullState> getDeviceFullState(String deviceId) async {
    await Future<void>.delayed(MockData.fastDelay);
    final state = _deviceStates[deviceId];
    if (state == null) {
      throw Exception('Device not found: $deviceId');
    }

    // Моковые данные для тестирования - одна авария
    return DeviceFullState(
      id: deviceId,
      name: state.deviceName,
      power: state.isOn,
      mode: state.mode,
      currentTemperature: state.currentTemperature,
      targetTemperature: state.targetTemperature,
      humidity: state.humidity,
      activeAlarms: const {
        'alarm1': AlarmInfo(
          code: 1,
          description: 'Тестовая авария: перегрев системы',
        ),
      },
    );
  }

  @override
  Stream<DeviceFullState> watchDeviceFullState(String deviceId) =>
    // Mock репозиторий не имеет real-time обновлений
    const Stream.empty();

  @override
  Future<List<AlarmHistory>> getAlarmHistory(
    String deviceId, {
    int limit = 100,
  }) async {
    await Future<void>.delayed(MockData.fastDelay);

    // Моковые данные для тестирования истории аварий
    return [
      AlarmHistory(
        id: 'ah_1',
        alarmCode: 1,
        description: 'Перегрев системы',
        occurredAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AlarmHistory(
        id: 'ah_2',
        alarmCode: 5,
        description: 'Низкое давление воздуха',
        occurredAt: DateTime.now().subtract(const Duration(days: 1)),
        isCleared: true,
        clearedAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      AlarmHistory(
        id: 'ah_3',
        alarmCode: 3,
        description: 'Ошибка датчика температуры',
        occurredAt: DateTime.now().subtract(const Duration(days: 3)),
        isCleared: true,
        clearedAt: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
      ),
    ];
  }

  @override
  Future<void> resetAlarm(String deviceId) async {
    await Future<void>.delayed(MockData.normalDelay);
    // В моке просто эмулируем успешный сброс аварий
  }

  @override
  Future<void> setDeviceTime(DateTime time, {String? deviceId}) async {
    await Future<void>.delayed(MockData.normalDelay);

    final targetDeviceId = deviceId ?? _selectedDeviceId;
    if (targetDeviceId == null) {
      throw Exception('No device selected');
    }

    // В реальном API здесь будет POST запрос на /api/devices/{deviceId}/time-setting
    // Формат запроса: {"time": "2024-01-18T15:30:00"}
    // В моке просто эмулируем успешную установку времени
    // Время устройства обновится в следующем полном state refresh
  }

  @override
  Future<void> requestDeviceUpdate({String? deviceId}) async {
    await Future<void>.delayed(MockData.normalDelay);
    // В моке просто эмулируем успешный запрос - данные уже актуальны
  }

  @override
  Future<void> setModeSettings({
    required String modeName,
    required ModeSettings settings,
    String? deviceId,
  }) async {
    await Future<void>.delayed(MockData.normalDelay);
    // В моке просто эмулируем успешную установку настроек режима
  }

  @override
  Future<void> setQuickMode({
    required int heatingTemperature,
    required int coolingTemperature,
    required int supplyFan,
    required int exhaustFan,
    String? deviceId,
  }) async {
    await Future<void>.delayed(MockData.normalDelay);
    // В моке просто эмулируем успешную установку quick mode
  }

  void dispose() {
    _climateController.close();
    _devicesController.close();
  }
}

class _DeviceMeta {

  const _DeviceMeta({
    required this.macAddress,
    required this.deviceType,
    required this.isOnline,
  });
  final String macAddress;
  final HvacDeviceType deviceType;
  final bool isOnline;
}
