/// SignalR Hub соединение для real-time обновлений
///
/// Поддерживает события:
/// - DeviceUpdated / DeviceStateChanged - обновления устройств
/// - DeviceStatusChanged - изменение онлайн-статуса устройств
/// - NotificationReceived - новые уведомления
/// - NewReleaseAvailable - новые версии приложения
library;

import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import '../../../core/config/api_config.dart';
import '../../../core/logging/api_logger.dart';
import '../platform/api_client.dart';

class SignalRHubConnection {
  final ApiClient _apiClient;
  HubConnection? _connection;
  final _deviceUpdatesController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _releaseController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _statusChangeController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStateController =
      StreamController<HubConnectionState>.broadcast();

  SignalRHubConnection(this._apiClient);

  /// Текущее состояние соединения
  HubConnectionState? get state => _connection?.state;

  /// Подключиться к SignalR hub
  Future<void> connect() async {
    if (_connection != null &&
        _connection!.state == HubConnectionState.Connected) {
      return;
    }

    try {


      _connection = HubConnectionBuilder()
          .withUrl(
            ApiConfig.websocketUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async {
                final token = await _apiClient.getAuthToken();
                return token ?? '';
              },
            ),
          )
          .withAutomaticReconnect()
          .build();

      // Подписка на обновления устройств
      _connection!.on('DeviceUpdated', _handleDeviceUpdate);
      _connection!.on('DeviceStateChanged', _handleDeviceUpdate);

      // Подписка на уведомления
      _connection!.on('NotificationReceived', _handleNotification);

      // Подписка на обновления версий
      _connection!.on('NewReleaseAvailable', _handleRelease);

      // Подписка на изменения онлайн-статуса устройств
      _connection!.on('DeviceStatusChanged', _handleStatusChange);

      // Обработка состояния соединения
      _connection!.onclose(({error}) {
        ApiLogger.logWebSocketError('Connection closed: $error');
        _connectionStateController.add(HubConnectionState.Disconnected);
      });

      _connection!.onreconnecting(({error}) {
        ApiLogger.logWebSocketError('Reconnecting: $error');
        _connectionStateController.add(HubConnectionState.Reconnecting);
      });

      _connection!.onreconnected(({connectionId}) {
        ApiLogger.logWebSocketConnect(
            'Reconnected with ID: $connectionId');
        _connectionStateController.add(HubConnectionState.Connected);
      });

      ApiLogger.logWebSocketConnect(ApiConfig.websocketUrl);
      await _connection!.start();
      _connectionStateController.add(HubConnectionState.Connected);
    } catch (e) {
      ApiLogger.logWebSocketError(e);
      _connectionStateController.add(HubConnectionState.Disconnected);
      rethrow;
    }
  }

  /// Обработка обновления устройства из SignalR
  void _handleDeviceUpdate(List<Object?>? arguments) {
    try {
      final data = arguments?.first;
      if (data != null) {
        Map<String, dynamic> deviceData;

        if (data is Map<String, dynamic>) {
          deviceData = data;
        } else if (data is Map) {
          deviceData = Map<String, dynamic>.from(data);
        } else {
          ApiLogger.logWebSocketError('Unknown device data format: ${data.runtimeType}');
          return;
        }

        ApiLogger.logWebSocketMessage('DeviceUpdated', deviceData);
        _deviceUpdatesController.add(deviceData);
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Error handling device update: $e');
    }
  }

  /// Обработка уведомления из SignalR
  void _handleNotification(List<Object?>? arguments) {
    try {
      final data = arguments?.first;
      if (data != null) {
        Map<String, dynamic> notificationData;

        if (data is Map<String, dynamic>) {
          notificationData = data;
        } else if (data is Map) {
          notificationData = Map<String, dynamic>.from(data);
        } else {
          ApiLogger.logWebSocketError('Unknown notification data format: ${data.runtimeType}');
          return;
        }

        ApiLogger.logWebSocketMessage('NotificationReceived', notificationData);
        _notificationController.add(notificationData);
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Error handling notification: $e');
    }
  }

  /// Обработка информации о новом релизе из SignalR
  void _handleRelease(List<Object?>? arguments) {
    try {
      final data = arguments?.first;
      if (data != null) {
        Map<String, dynamic> releaseData;

        if (data is Map<String, dynamic>) {
          releaseData = data;
        } else if (data is Map) {
          releaseData = Map<String, dynamic>.from(data);
        } else {
          ApiLogger.logWebSocketError('Unknown release data format: ${data.runtimeType}');
          return;
        }

        ApiLogger.logWebSocketMessage('NewReleaseAvailable', releaseData);
        _releaseController.add(releaseData);
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Error handling release: $e');
    }
  }

  /// Обработка изменения онлайн-статуса устройства из SignalR
  void _handleStatusChange(List<Object?>? arguments) {
    try {
      final data = arguments?.first;
      if (data != null) {
        Map<String, dynamic> statusData;

        if (data is Map<String, dynamic>) {
          statusData = data;
        } else if (data is Map) {
          statusData = Map<String, dynamic>.from(data);
        } else {
          ApiLogger.logWebSocketError('Unknown status data format: ${data.runtimeType}');
          return;
        }

        ApiLogger.logWebSocketMessage('DeviceStatusChanged', statusData);
        _statusChangeController.add(statusData);
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Error handling status change: $e');
    }
  }

  /// Подписаться на обновления конкретного устройства
  Future<void> subscribeToDevice(String deviceId) async {
    try {
      await _connection?.invoke('SubscribeToDevice', args: [deviceId]);
      ApiLogger.logWebSocketMessage('SubscribeToDevice', deviceId);
    } catch (e) {
      ApiLogger.logWebSocketError('Failed to subscribe to device: $e');
    }
  }

  /// Отписаться от обновлений устройства
  Future<void> unsubscribeFromDevice(String deviceId) async {
    try {
      await _connection?.invoke('UnsubscribeFromDevice', args: [deviceId]);
      ApiLogger.logWebSocketMessage('UnsubscribeFromDevice', deviceId);
    } catch (e) {
      ApiLogger.logWebSocketError('Failed to unsubscribe from device: $e');
    }
  }

  /// Подписаться на все устройства
  Future<void> subscribeToAllDevices() async {
    try {
      await _connection?.invoke('SubscribeToAllDevices', args: []);
      ApiLogger.logWebSocketMessage('SubscribeToAllDevices', null);
    } catch (e) {
      ApiLogger.logWebSocketError('Failed to subscribe to all devices: $e');
    }
  }

  /// Стрим обновлений устройств
  Stream<Map<String, dynamic>> get deviceUpdates =>
      _deviceUpdatesController.stream;

  /// Стрим уведомлений
  Stream<Map<String, dynamic>> get notifications =>
      _notificationController.stream;

  /// Стрим обновлений версий
  Stream<Map<String, dynamic>> get releases =>
      _releaseController.stream;

  /// Стрим изменений онлайн-статуса устройств
  Stream<Map<String, dynamic>> get statusChanges =>
      _statusChangeController.stream;

  /// Стрим состояния соединения
  Stream<HubConnectionState> get connectionState =>
      _connectionStateController.stream;

  /// Отключиться от SignalR
  Future<void> disconnect() async {
    await _connection?.stop();
    _connectionStateController.add(HubConnectionState.Disconnected);
  }

  Future<void> dispose() async {
    try {
      await disconnect();
    } catch (e) {
      ApiLogger.logWebSocketError('Error during disconnect: $e');
    }
    await _deviceUpdatesController.close();
    await _notificationController.close();
    await _releaseController.close();
    await _statusChangeController.close();
    await _connectionStateController.close();
  }
}
