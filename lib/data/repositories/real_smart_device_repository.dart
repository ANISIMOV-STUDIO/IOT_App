/// Real implementation of SmartDeviceRepository
library;

import 'dart:async';

import 'package:hvac_control/core/error/api_exception.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/data/api/http/clients/hvac_http_client.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/api/websocket/signalr_hub_connection.dart';
import 'package:hvac_control/domain/entities/smart_device.dart';
import 'package:hvac_control/domain/repositories/smart_device_repository.dart';
import 'package:signalr_netcore/signalr_client.dart';

class RealSmartDeviceRepository implements SmartDeviceRepository {

  RealSmartDeviceRepository(this._apiClient, [this._signalR]) {
    _httpClient = HvacHttpClient(_apiClient);
  }
  final ApiClient _apiClient;
  final SignalRHubConnection? _signalR;
  late final HvacHttpClient _httpClient;

  final _devicesController = StreamController<List<SmartDevice>>.broadcast();
  Timer? _pollTimer;
  StreamSubscription<HubConnectionState>? _signalRSubscription;
  bool _isSignalRConnected = false;

  /// Интервал polling когда SignalR не работает
  static const _pollInterval = Duration(seconds: 30);

  @override
  Future<List<SmartDevice>> getAllDevices() async {
    final jsonDevices = await _httpClient.listDevices();

    // Конвертировать JSON в SmartDevice entities с валидацией
    final devices = jsonDevices.map((json) {
      final id = (json['id'] as String?) ?? '';
      if (id.isEmpty) {
        ApiLogger.logHttpError('GET', '/devices', 'Device missing id field');
        return null; // Пропустить некорректные устройства
      }

      return SmartDevice(
        id: id,
        name: (json['name'] as String?) ?? 'Unknown',
        type: _parseDeviceType(json['type'] as String?),
        isOn: (json['power'] as bool?) ?? false,
        roomId: (json['roomId'] as String?) ?? 'unknown',
        powerConsumption: (json['powerConsumption'] as num?)?.toDouble() ?? 0.0,
        activeTime: Duration(seconds: (json['activeTime'] as int?) ?? 0),
        lastUpdated: DateTime.now(),
        metadata: json,
      );
    }).whereType<SmartDevice>().toList(); // Фильтровать null значения

    _devicesController.add(devices);
    return devices;
  }

  /// Парсинг типа устройства из строки
  SmartDeviceType _parseDeviceType(String? type) {
    if (type == null) {
      return SmartDeviceType.ventilation;
    }

    switch (type.toLowerCase()) {
      case 'ventilation':
      case 'пву':
      case 'приточно-вытяжная установка':
        return SmartDeviceType.ventilation;
      case 'aircondition':
      case 'air_condition':
      case 'кондиционер':
        return SmartDeviceType.airCondition;
      case 'recuperator':
      case 'рекуператор':
        return SmartDeviceType.recuperator;
      case 'humidifier':
      case 'увлажнитель':
        return SmartDeviceType.humidifier;
      case 'dehumidifier':
      case 'осушитель':
        return SmartDeviceType.dehumidifier;
      default:
        return SmartDeviceType.ventilation; // Default fallback
    }
  }

  @override
  Future<List<SmartDevice>> getDevicesByRoom(String roomId) async {
    final allDevices = await getAllDevices();
    return allDevices.where((device) => device.roomId == roomId).toList();
  }

  @override
  Future<SmartDevice?> getDeviceById(String id) async {
    final jsonDevice = await _httpClient.getDevice(id);

    // Валидация обязательных полей
    final deviceId = (jsonDevice['id'] as String?) ?? id;

    return SmartDevice(
      id: deviceId,
      name: (jsonDevice['name'] as String?) ?? 'Unknown',
      type: _parseDeviceType(jsonDevice['type'] as String?),
      isOn: (jsonDevice['power'] as bool?) ?? false,
      roomId: (jsonDevice['roomId'] as String?) ?? 'unknown',
      powerConsumption: (jsonDevice['powerConsumption'] as num?)?.toDouble() ?? 0.0,
      activeTime: Duration(seconds: (jsonDevice['activeTime'] as int?) ?? 0),
      lastUpdated: DateTime.now(),
      metadata: jsonDevice,
    );
  }

  @override
  Future<SmartDevice> toggleDevice(String id, {required bool isOn}) async {
    final current = await getDeviceById(id);
    if (current == null) {
      final error = 'Device not found: $id';
      ApiLogger.logHttpError('POST', '/devices/$id/toggle', error);
      throw ApiException(
        type: ApiErrorType.notFound,
        message: error,
        statusCode: 404,
      );
    }

    final jsonDevice = await _httpClient.setPower(id, power: isOn);

    return SmartDevice(
      id: (jsonDevice['id'] as String?) ?? id,
      name: (jsonDevice['name'] as String?) ?? current.name,
      type: current.type,
      isOn: (jsonDevice['power'] as bool?) ?? isOn,
      roomId: current.roomId,
      powerConsumption: current.powerConsumption,
      activeTime: current.activeTime,
      lastUpdated: DateTime.now(),
      metadata: jsonDevice,
    );
  }

  @override
  Future<SmartDevice> updateDevice(SmartDevice device) async =>
    // TODO: Implement update endpoint when available
    device;

  @override
  Stream<List<SmartDevice>> watchDevices() {
    // Начальная загрузка данных
    getAllDevices();

    // Подписаться на состояние SignalR для управления polling
    _signalRSubscription?.cancel();
    if (_signalR != null) {
      _signalRSubscription = _signalR.connectionState.listen(_onSignalRStateChanged);
      // Проверить текущее состояние
      _isSignalRConnected = _signalR.state == HubConnectionState.Connected;
    }

    // Запустить polling только если SignalR не подключён
    _updatePolling();

    return _devicesController.stream;
  }

  /// Обработчик изменения состояния SignalR
  void _onSignalRStateChanged(HubConnectionState state) {
    final wasConnected = _isSignalRConnected;
    _isSignalRConnected = state == HubConnectionState.Connected;

    // Обновить polling только если состояние изменилось
    if (wasConnected != _isSignalRConnected) {
      _updatePolling();
    }
  }

  /// Включить/выключить polling в зависимости от состояния SignalR
  void _updatePolling() {
    _pollTimer?.cancel();
    _pollTimer = null;

    if (!_isSignalRConnected) {
      // SignalR не работает — включаем fallback polling
      _pollTimer = Timer.periodic(_pollInterval, (_) {
        getAllDevices();
      });
    }
    // Если SignalR подключён — polling не нужен, данные приходят через WebSocket
  }

  void dispose() {
    _pollTimer?.cancel();
    _signalRSubscription?.cancel();
    _devicesController.close();
  }
}
