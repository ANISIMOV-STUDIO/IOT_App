/// Real implementation of ClimateRepository using HTTP/WebSocket
library;

import 'dart:async';
import 'dart:developer' as developer;
import '../../domain/entities/climate.dart';
import '../../domain/entities/hvac_device.dart';
import '../../domain/entities/device_full_state.dart';
import '../../domain/repositories/climate_repository.dart';
import '../api/platform/api_client.dart';
import '../api/http/clients/hvac_http_client.dart';
import '../api/websocket/signalr_hub_connection.dart';
import '../api/mappers/device_json_mapper.dart';

class RealClimateRepository implements ClimateRepository {
  // ignore: unused_field
  final ApiClient _apiClient;
  final HvacHttpClient _httpClient;
  final SignalRHubConnection? _signalR;

  // State
  final _climateController = StreamController<ClimateState>.broadcast();
  final _devicesController = StreamController<List<HvacDevice>>.broadcast();
  String _selectedDeviceId = '';
  List<HvacDevice> _cachedDevices = [];

  // SignalR subscription для отмены при dispose
  StreamSubscription? _deviceUpdatesSubscription;

  /// Конструктор с инжекцией зависимостей
  ///
  /// [_apiClient] - Platform-specific API client
  /// [_httpClient] - HTTP client для REST API вызовов
  /// [_signalR] - SignalR connection для real-time обновлений (опционально для web)
  RealClimateRepository(
    this._apiClient,
    this._httpClient,
    this._signalR,
  );

  /// Инициализировать SignalR подключение
  /// Должен быть вызван после создания repository
  Future<void> initialize() async {
    await _startSignalRConnection();
  }

  /// Запустить SignalR подключение для real-time обновлений
  Future<void> _startSignalRConnection() async {
    try {
      await _signalR?.connect();

      // Сохранить subscription для отмены при dispose
      _deviceUpdatesSubscription = _signalR?.deviceUpdates.listen((deviceData) {
        // Snapshot переменной для избежания race condition
        final selectedId = _selectedDeviceId;

        // Парсинг данных устройства
        final state = DeviceJsonMapper.climateStateFromJson(deviceData);

        // Обновить stream только для выбранного устройства
        if (deviceData['id'] == selectedId) {
          _climateController.add(state);
        }
      });
    } catch (e) {
      // Продолжить без real-time обновлений
      // Будет использоваться polling или ручное обновление
    }
  }

  // ============================================
  // MULTI-DEVICE SUPPORT
  // ============================================

  @override
  Future<List<HvacDevice>> getAllHvacDevices() async {
    final jsonDevices = await _httpClient.listDevices();
    final devices = jsonDevices
        .map((json) => DeviceJsonMapper.hvacDeviceFromJson(json))
        .toList();

    _cachedDevices = devices; // Сохраняем для последующих операций
    _devicesController.add(devices);
    return devices;
  }

  @override
  Stream<List<HvacDevice>> watchHvacDevices() {
    // Initial fetch
    getAllHvacDevices();
    return _devicesController.stream;
  }

  @override
  void setSelectedDevice(String deviceId) {
    developer.log('setSelectedDevice called: deviceId=$deviceId', name: 'ClimateRepository');
    if (deviceId.isEmpty) {
      developer.log('setSelectedDevice: skipping empty deviceId', name: 'ClimateRepository');
      return; // Пропускаем если нет устройств
    }

    _selectedDeviceId = deviceId;
    developer.log('setSelectedDevice: _selectedDeviceId set to $deviceId', name: 'ClimateRepository');

    // Subscribe to device updates via SignalR
    _signalR?.subscribeToDevice(deviceId);

    // Load initial state
    getDeviceState(deviceId).then((state) {
      _climateController.add(state);
    }).catchError((_) {
      // Ignore errors for initial load
    });
  }

  @override
  Future<ClimateState> getDeviceState(String deviceId) async {
    if (deviceId.isEmpty) {
      throw StateError('No device selected');
    }
    final jsonDevice = await _httpClient.getDevice(deviceId);
    return DeviceJsonMapper.climateStateFromJson(jsonDevice);
  }

  @override
  Stream<ClimateState> watchDeviceClimate(String deviceId) {
    // Set selected device to start receiving updates
    if (deviceId.isNotEmpty) {
      setSelectedDevice(deviceId);
    }
    return _climateController.stream;
  }

  @override
  Future<ClimateState> getCurrentState() async {
    if (_selectedDeviceId.isEmpty) {
      throw StateError('No device selected');
    }
    return getDeviceState(_selectedDeviceId);
  }

  @override
  Stream<ClimateState> watchClimate() {
    if (_selectedDeviceId.isEmpty) {
      return _climateController.stream; // Возвращаем пустой stream
    }
    return watchDeviceClimate(_selectedDeviceId);
  }

  // ============================================
  // CONTROL OPERATIONS
  // ============================================

  @override
  Future<ClimateState> setPower(bool isOn, {String? deviceId}) async {
    final id = deviceId ?? _selectedDeviceId;
    developer.log(
      'setPower called: isOn=$isOn, deviceId=$deviceId, selectedDeviceId=$_selectedDeviceId, resolved id=$id',
      name: 'ClimateRepository',
    );

    if (id.isEmpty) {
      developer.log('setPower ERROR: deviceId is empty!', name: 'ClimateRepository');
      throw StateError('No device selected for power control');
    }

    final jsonDevice = await _httpClient.setPower(id, isOn);
    final state = DeviceJsonMapper.climateStateFromJson(jsonDevice);
    _climateController.add(state);
    return state;
  }

  @override
  Future<ClimateState> setTargetTemperature(
    double temperature, {
    String? deviceId,
  }) async {
    final id = deviceId ?? _selectedDeviceId;

    final jsonDevice = await _httpClient.setTemperature(id, temperature.toInt());
    final state = DeviceJsonMapper.climateStateFromJson(jsonDevice);
    _climateController.add(state);
    return state;
  }

  @override
  Future<ClimateState> setHumidity(double humidity, {String? deviceId}) async {
    // Backend might not have dedicated humidity endpoint
    // Return current state for now
    return getCurrentState();
  }

  @override
  Future<ClimateState> setMode(ClimateMode mode, {String? deviceId}) async {
    final id = deviceId ?? _selectedDeviceId;
    final modeString = DeviceJsonMapper.climateModeToString(mode);

    final jsonDevice = await _httpClient.setMode(id, modeString);
    final state = DeviceJsonMapper.climateStateFromJson(jsonDevice);
    _climateController.add(state);
    return state;
  }

  @override

  @override
  Future<ClimateState> setSupplyAirflow(
    double value, {
    String? deviceId,
  }) async {
    final id = deviceId ?? _selectedDeviceId;
    final fanSpeed = DeviceJsonMapper.percentToFanSpeedInt(value);

    // PATCH только supply fan, без получения текущего состояния
    final jsonDevice = await _httpClient.updateDevice(id, supplyFan: fanSpeed);
    final state = DeviceJsonMapper.climateStateFromJson(jsonDevice);
    _climateController.add(state);
    return state;
  }

  @override
  Future<ClimateState> setExhaustAirflow(
    double value, {
    String? deviceId,
  }) async {
    final id = deviceId ?? _selectedDeviceId;
    final fanSpeed = DeviceJsonMapper.percentToFanSpeedInt(value);

    // PATCH только exhaust fan, без получения текущего состояния
    final jsonDevice = await _httpClient.updateDevice(id, exhaustFan: fanSpeed);
    final state = DeviceJsonMapper.climateStateFromJson(jsonDevice);
    _climateController.add(state);
    return state;
  }

  @override
  Future<ClimateState> setPreset(String preset, {String? deviceId}) async {
    // Backend might not have preset endpoint via HTTP
    // Return current state for now
    return getCurrentState();
  }

  @override
  Future<HvacDevice> registerDevice(String macAddress, String name) async {
    final jsonDevice = await _httpClient.registerDevice(macAddress, name);
    final device = DeviceJsonMapper.hvacDeviceFromJson(jsonDevice);

    // Добавляем в локальный список и уведомляем
    final updatedDevices = [..._cachedDevices, device];
    _cachedDevices = updatedDevices;
    _devicesController.add(updatedDevices);

    return device;
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    await _httpClient.deleteDevice(deviceId);

    // Удаляем из локального списка
    final updatedDevices = _cachedDevices.where((d) => d.id != deviceId).toList();
    _cachedDevices = updatedDevices;
    _devicesController.add(updatedDevices);
  }

  @override
  Future<void> renameDevice(String deviceId, String newName) async {
    await _httpClient.renameDevice(deviceId, newName);

    // Обновляем имя в локальном списке
    _cachedDevices = _cachedDevices.map((d) {
      if (d.id == deviceId) {
        return d.copyWith(name: newName);
      }
      return d;
    }).toList();
    _devicesController.add(_cachedDevices);
  }

  // ============================================
  // FULL STATE (with alarms, mode settings, etc.)
  // ============================================

  @override
  Future<DeviceFullState> getDeviceFullState(String deviceId) async {
    if (deviceId.isEmpty) {
      throw StateError('No device selected');
    }
    final jsonDevice = await _httpClient.getDevice(deviceId);
    return DeviceJsonMapper.deviceFullStateFromJson(jsonDevice);
  }

  void dispose() {
    _deviceUpdatesSubscription?.cancel(); // Отменить SignalR subscription
    _climateController.close();
    _devicesController.close();
    _signalR?.dispose();
  }
}
