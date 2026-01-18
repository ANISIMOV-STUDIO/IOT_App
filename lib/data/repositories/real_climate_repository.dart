/// Real implementation of ClimateRepository using HTTP/WebSocket
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:hvac_control/data/api/http/clients/hvac_http_client.dart';
import 'package:hvac_control/data/api/mappers/device_json_mapper.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/api/websocket/signalr_hub_connection.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';

class RealClimateRepository implements ClimateRepository {

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
  // ignore: unused_field
  final ApiClient _apiClient;
  final HvacHttpClient _httpClient;
  final SignalRHubConnection? _signalR;

  // State
  final _climateController = StreamController<ClimateState>.broadcast();
  final _devicesController = StreamController<List<HvacDevice>>.broadcast();
  final _deviceFullStateController = StreamController<DeviceFullState>.broadcast();
  String _selectedDeviceId = '';
  List<HvacDevice> _cachedDevices = [];
  ClimateState? _lastClimateState;  // Кэшированное состояние для быстрого доступа к preset

  // SignalR subscription для отмены при dispose
  StreamSubscription<Map<String, dynamic>>? _deviceUpdatesSubscription;
  StreamSubscription<Map<String, dynamic>>? _statusChangesSubscription;

  /// Флаг для предотвращения race condition при dispose
  bool _isDisposed = false;

  /// Безопасно добавить событие в StreamController (проверка на closed/disposed)
  void _safeAddToController<T>(StreamController<T> controller, T event) {
    if (!_isDisposed && !controller.isClosed) {
      controller.add(event);
    }
  }

  /// Инициализировать SignalR подключение
  /// Должен быть вызван после создания repository
  Future<void> initialize() async {
    await _startSignalRConnection();
  }

  /// Запустить SignalR подключение для real-time обновлений
  Future<void> _startSignalRConnection() async {
    if (_isDisposed) {
      return;
    }

    try {
      await _signalR?.connect();

      // Сохранить subscription для отмены при dispose
      _deviceUpdatesSubscription = _signalR?.deviceUpdates.listen(
        (deviceData) {
          if (_isDisposed) {
      return;
    }

          // Snapshot переменной для избежания race condition
          final selectedId = _selectedDeviceId;

          // Обновить stream только для выбранного устройства
          if (deviceData['id'] == selectedId) {
            // Парсинг ClimateState для обратной совместимости
            final climateState = DeviceJsonMapper.climateStateFromJson(deviceData);
            _lastClimateState = climateState;  // Кэшируем для быстрого доступа к preset
            _safeAddToController(_climateController, climateState);

            // Парсинг DeviceFullState для полного обновления UI
            try {
              final fullState = DeviceJsonMapper.deviceFullStateFromJson(deviceData);
              _safeAddToController(_deviceFullStateController, fullState);
              developer.log(
                'SignalR: received full state update for device $selectedId',
                name: 'ClimateRepository',
              );
            } catch (e) {
              developer.log(
                'SignalR: failed to parse DeviceFullState: $e',
                name: 'ClimateRepository',
              );
            }
          }
        },
        onError: (Object error) {
          // Логируем ошибку, но не прерываем стрим
          developer.log(
            'SignalR device updates error: $error',
            name: 'ClimateRepository',
            error: error,
          );
        },
      );

      // Подписка на изменения онлайн-статуса устройств
      _statusChangesSubscription = _signalR?.statusChanges.listen(
        _handleStatusChange,
        onError: (Object error) {
          developer.log(
            'SignalR status changes error: $error',
            name: 'ClimateRepository',
            error: error,
          );
        },
      );
    } catch (e) {
      // Продолжить без real-time обновлений
      // Будет использоваться polling или ручное обновление
    }
  }

  /// Обработка изменения онлайн-статуса устройства
  void _handleStatusChange(Map<String, dynamic> statusData) {
    if (_isDisposed) {
      return;
    }

    final deviceId = statusData['deviceId'] as String?;
    final macAddress = statusData['macAddress'] as String?;
    final isOnline = statusData['isOnline'] as bool? ?? false;

    if (deviceId == null && macAddress == null) {
      return;
    }

    developer.log(
      'SignalR: Device status changed - deviceId: $deviceId, mac: $macAddress, isOnline: $isOnline',
      name: 'ClimateRepository',
    );

    // Snapshot для избежания race condition при чтении и записи
    final currentDevices = List<HvacDevice>.from(_cachedDevices);

    // Обновляем кэш устройств (используем только deviceId, т.к. HvacDevice не хранит macAddress)
    final updatedDevices = currentDevices.map((device) {
      if (device.id == deviceId) {
        return device.copyWith(isOnline: isOnline);
      }
      return device;
    }).toList();

    if (!_listEquals(currentDevices, updatedDevices)) {
      _cachedDevices = updatedDevices;
      _safeAddToController(_devicesController, updatedDevices);
    }

    // Snapshot selectedDeviceId для избежания race condition
    final selectedId = _selectedDeviceId;

    // Если это текущее выбранное устройство — обновляем DeviceFullState
    if (selectedId == deviceId && selectedId.isNotEmpty) {
      // Запрашиваем полное состояние устройства для обновления UI
      getDeviceFullState(selectedId).then((fullState) {
        _safeAddToController(_deviceFullStateController, fullState);
      }).catchError((Object e) {
        developer.log(
          'Failed to refresh device state after status change: $e',
          name: 'ClimateRepository',
        );
      });
    }
  }

  /// Сравнение списков устройств
  bool _listEquals(List<HvacDevice> a, List<HvacDevice> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].isOnline != b[i].isOnline) {
        return false;
      }
    }
    return true;
  }

  // In-flight requests for deduplication
  final _inflightRequests = <String, Future<Map<String, dynamic>>>{};

  // ============================================
  // MULTI-DEVICE SUPPORT
  // ============================================

  @override
  Future<List<HvacDevice>> getAllHvacDevices() async {
    final jsonDevices = await _httpClient.listDevices();
    final devices = jsonDevices
        .map(DeviceJsonMapper.hvacDeviceFromJson)
        .toList();

    _cachedDevices = devices; // Сохраняем для последующих операций
    _safeAddToController(_devicesController, devices);
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

    // Load initial state using deduplicated fetch
    // We ignore the error here as it's an initial "fire and forget" load for the broadcast stream
    _fetchAndBroadcastState(deviceId).catchError((_) {});
  }

  /// Dedplucated fetch wrapper
  /// Returns raw JSON map to be parsed by specific methods
  Future<Map<String, dynamic>> _fetchDevice(String deviceId) {
    if (_inflightRequests.containsKey(deviceId)) {
      developer.log('Joining inflight request for device $deviceId', name: 'ClimateRepository');
      return _inflightRequests[deviceId]!;
    }

    developer.log('Starting new request for device $deviceId', name: 'ClimateRepository');
    final future = _httpClient.getDevice(deviceId).whenComplete(() {
      _inflightRequests.remove(deviceId);
    });

    _inflightRequests[deviceId] = future;
    return future;
  }

  /// Helper to fetch and update all streams
  Future<void> _fetchAndBroadcastState(String deviceId) async {
     if (_isDisposed) {
      return;
    }

     try {
       final jsonDevice = await _fetchDevice(deviceId);

       // Update ClimateState stream
       final climateState = DeviceJsonMapper.climateStateFromJson(jsonDevice);
       _lastClimateState = climateState;
       _safeAddToController(_climateController, climateState);

       // Update DeviceFullState stream if applicable (it parses more fields)
       // We can try to parse full state from the same JSON
       try {
         final fullState = DeviceJsonMapper.deviceFullStateFromJson(jsonDevice);
         _safeAddToController(_deviceFullStateController, fullState);
       } catch (e) {
         // It's okay if we can't parse full state from partial data, but usually getDevice returns full data
       }
     } catch (e) {
       developer.log('Error fetching device state: $e', name: 'ClimateRepository');
       rethrow;
     }
  }

  @override
  Future<ClimateState> getDeviceState(String deviceId) async {
    if (deviceId.isEmpty) {
      throw StateError('No device selected');
    }

    // Use deduplicated fetch
    final jsonDevice = await _fetchDevice(deviceId);
    final state = DeviceJsonMapper.climateStateFromJson(jsonDevice);

    // Snapshot selectedDeviceId для избежания race condition
    final selectedId = _selectedDeviceId;

    // Update streams cache if this is for the selected device
    if (deviceId == selectedId) {
       _lastClimateState = state;
       _safeAddToController(_climateController, state);
    }

    return state;
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
      // Возвращаем stream с ошибкой вместо пустого stream
      return Stream.error(StateError('No device selected for climate monitoring'));
    }
    return watchDeviceClimate(_selectedDeviceId);
  }

  // ============================================
  // CONTROL OPERATIONS
  // ============================================

  @override
  Future<ClimateState> setPower({required bool isOn, String? deviceId}) async {
    // Snapshot selectedDeviceId для избежания race condition
    final selectedId = _selectedDeviceId;
    final id = deviceId ?? selectedId;
    developer.log(
      'setPower called: isOn=$isOn, deviceId=$deviceId, selectedDeviceId=$selectedId, resolved id=$id',
      name: 'ClimateRepository',
    );

    if (id.isEmpty) {
      developer.log('setPower ERROR: deviceId is empty!', name: 'ClimateRepository');
      throw StateError('No device selected for power control');
    }

    final jsonDevice = await _httpClient.setPower(id, power: isOn);
    final state = DeviceJsonMapper.climateStateFromJson(jsonDevice);
    _safeAddToController(_climateController, state);
    return state;
  }

  @override
  Future<ClimateState> setTargetTemperature(
    double temperature, {
    String? deviceId,
  }) =>
    // Default to heating temperature for backward compatibility
    setHeatingTemperature(temperature.toInt(), deviceId: deviceId);

  @override
  Future<ClimateState> setHeatingTemperature(
    int temperature, {
    String? deviceId,
  }) async {
    final id = deviceId ?? _selectedDeviceId;
    if (id.isEmpty) {
      throw StateError('No device selected for heating temperature control');
    }

    // Используем кэшированный режим вместо GET запроса
    final modeName = _getCachedModeName(id);

    await _httpClient.setHeatingTemperature(id, temperature, modeName: modeName);
    
    // Состояние придёт через SignalR, возвращаем кэш (без GET запроса)
    return _lastClimateState!;
  }

  @override
  Future<ClimateState> setCoolingTemperature(
    int temperature, {
    String? deviceId,
  }) async {
    final id = deviceId ?? _selectedDeviceId;
    if (id.isEmpty) {
      throw StateError('No device selected for cooling temperature control');
    }

    // Используем кэшированный режим вместо GET запроса
    final modeName = _getCachedModeName(id);

    await _httpClient.setCoolingTemperature(id, temperature, modeName: modeName);
    
    // Состояние придёт через SignalR, возвращаем кэш (без GET запроса)
    return _lastClimateState!;
  }

  /// Нормализует имя режима для backend API
  /// Backend ожидает snake_case: basic, intensive, economy, max_performance, etc.
  String _normalizeModeName(String preset) {
    // Конвертируем PascalCase/camelCase в snake_case если нужно
    final normalized = preset.toLowerCase();
    
    // Специальные случаи
    return switch (normalized) {
      'maxperformance' => 'max_performance',
      _ => normalized,
    };
  }

  /// Получить имя режима из кэша вместо GET запроса
  /// Это быстрая операция, не блокирует restartable() transformer
  String _getCachedModeName(String deviceId) {
    // Используем кэшированный preset из последнего состояния
    final preset = _lastClimateState?.preset ?? 'basic';
    return _normalizeModeName(preset);
  }


  @override
  Future<ClimateState> setHumidity(double humidity, {String? deviceId}) =>
    // Backend might not have dedicated humidity endpoint
    // Return current state for now
    getCurrentState();

  @override
  Future<ClimateState> setMode(ClimateMode mode, {String? deviceId}) async {
    final id = deviceId ?? _selectedDeviceId;
    final modeString = DeviceJsonMapper.climateModeToString(mode);

    final jsonDevice = await _httpClient.setMode(id, modeString);
    final state = DeviceJsonMapper.climateStateFromJson(jsonDevice);
    _safeAddToController(_climateController, state);
    return state;
  }

  @override
  Future<ClimateState> setOperatingMode(String mode, {String? deviceId}) async {
    final id = deviceId ?? _selectedDeviceId;
    // String mode передаётся напрямую без конвертации
    final jsonDevice = await _httpClient.setMode(id, mode);
    final state = DeviceJsonMapper.climateStateFromJson(jsonDevice);
    _safeAddToController(_climateController, state);
    return state;
  }

  @override
  Future<ClimateState> setSupplyAirflow(
    double value, {
    String? deviceId,
  }) async {
    final id = deviceId ?? _selectedDeviceId;
    if (id.isEmpty) {
      throw StateError('No device selected for supply airflow control');
    }

    // Используем кэшированный режим вместо GET запроса
    final modeName = _getCachedModeName(id);
    final fanSpeed = DeviceJsonMapper.percentToFanSpeedInt(value);

    await _httpClient.setSupplyFan(id, fanSpeed, modeName: modeName);
    
    // Состояние придёт через SignalR, возвращаем кэш (без GET запроса)
    return _lastClimateState!;
  }

  @override
  Future<ClimateState> setExhaustAirflow(
    double value, {
    String? deviceId,
  }) async {
    final id = deviceId ?? _selectedDeviceId;
    if (id.isEmpty) {
      throw StateError('No device selected for exhaust airflow control');
    }

    // Используем кэшированный режим вместо GET запроса
    final modeName = _getCachedModeName(id);
    final fanSpeed = DeviceJsonMapper.percentToFanSpeedInt(value);

    await _httpClient.setExhaustFan(id, fanSpeed, modeName: modeName);
    
    // Состояние придёт через SignalR, возвращаем кэш (без GET запроса)
    return _lastClimateState!;
  }


  @override
  Future<ClimateState> setPreset(String preset, {String? deviceId}) =>
    // Backend might not have preset endpoint via HTTP
    // Return current state for now
    getCurrentState();

  @override
  Future<HvacDevice> registerDevice(String macAddress, String name) async {
    final jsonDevice = await _httpClient.registerDevice(macAddress, name);
    final device = DeviceJsonMapper.hvacDeviceFromJson(jsonDevice);

    // Snapshot + update для избежания race condition
    final currentDevices = List<HvacDevice>.from(_cachedDevices);
    final updatedDevices = [...currentDevices, device];
    _cachedDevices = updatedDevices;
    _safeAddToController(_devicesController, updatedDevices);

    return device;
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    await _httpClient.deleteDevice(deviceId);

    // Snapshot + update для избежания race condition
    final currentDevices = List<HvacDevice>.from(_cachedDevices);
    final updatedDevices = currentDevices.where((d) => d.id != deviceId).toList();
    _cachedDevices = updatedDevices;
    _safeAddToController(_devicesController, updatedDevices);
  }

  @override
  Future<void> renameDevice(String deviceId, String newName) async {
    await _httpClient.renameDevice(deviceId, newName);

    // Snapshot + update для избежания race condition
    final currentDevices = List<HvacDevice>.from(_cachedDevices);
    final updatedDevices = currentDevices.map((d) {
      if (d.id == deviceId) {
        return d.copyWith(name: newName);
      }
      return d;
    }).toList();
    _cachedDevices = updatedDevices;
    _safeAddToController(_devicesController, updatedDevices);
  }

  // ============================================
  // FULL STATE (with alarms, mode settings, etc.)
  // ============================================

  @override
  Future<DeviceFullState> getDeviceFullState(String deviceId) async {
    if (deviceId.isEmpty) {
      throw StateError('No device selected');
    }

    // Use deduplicated fetch
    final jsonDevice = await _fetchDevice(deviceId);

    // Snapshot selectedDeviceId для избежания race condition
    final selectedId = _selectedDeviceId;

    // Update streams cache if this is for the selected device
    // NOTE: This ensures that if we load full state, climate state stream is also valid/updated
    // avoiding the need for a separate getDeviceState call.
    if (deviceId == selectedId) {
       final climateState = DeviceJsonMapper.climateStateFromJson(jsonDevice);
       _lastClimateState = climateState;
       _safeAddToController(_climateController, climateState);

       final fullState = DeviceJsonMapper.deviceFullStateFromJson(jsonDevice);
       _safeAddToController(_deviceFullStateController, fullState);
       return fullState;
    }

    return DeviceJsonMapper.deviceFullStateFromJson(jsonDevice);
  }

  @override
  Stream<DeviceFullState> watchDeviceFullState(String deviceId) {
    // Ensure device is selected for SignalR subscription
    if (deviceId.isNotEmpty && deviceId != _selectedDeviceId) {
      setSelectedDevice(deviceId);
    }
    return _deviceFullStateController.stream;
  }

  // ============================================
  // ALARM HISTORY
  // ============================================

  @override
  Future<List<AlarmHistory>> getAlarmHistory(
    String deviceId, {
    int limit = 100,
  }) async {
    if (deviceId.isEmpty) {
      throw StateError('No device selected');
    }
    final jsonList = await _httpClient.getAlarmHistory(deviceId, limit: limit);
    return jsonList.map(AlarmHistory.fromJson).toList();
  }

  // ============================================
  // DEVICE TIME SETTING
  // ============================================

  @override
  Future<void> setDeviceTime(DateTime time, {String? deviceId}) async {
    final targetDeviceId = deviceId ?? _selectedDeviceId;
    if (targetDeviceId.isEmpty) {
      throw StateError('No device selected');
    }
    await _httpClient.setDeviceTime(
      targetDeviceId,
      year: time.year,
      month: time.month,
      day: time.day,
      hour: time.hour,
      minute: time.minute,
    );
  }

  @override
  Future<void> requestDeviceUpdate({String? deviceId}) async {
    final targetDeviceId = deviceId ?? _selectedDeviceId;
    if (targetDeviceId.isEmpty) {
      throw StateError('No device selected');
    }
    await _httpClient.requestUpdate(targetDeviceId);
  }

  void dispose() {
    // Сначала помечаем как disposed чтобы остановить все операции
    _isDisposed = true;

    // Отменяем подписки
    _deviceUpdatesSubscription?.cancel();
    _statusChangesSubscription?.cancel();

    // Очищаем inflight requests
    _inflightRequests.clear();

    // Закрываем контроллеры
    _climateController.close();
    _devicesController.close();
    _deviceFullStateController.close();

    // Dispose SignalR
    _signalR?.dispose();
  }
}
