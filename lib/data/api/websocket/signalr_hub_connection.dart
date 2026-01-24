/// SignalR Hub соединение для real-time обновлений
///
/// Поддерживает события:
/// - DeviceUpdated / DeviceStateChanged - обновления устройств
/// - DeviceStatusChanged - изменение онлайн-статуса устройств
/// - NotificationReceived - новые уведомления
/// - NewReleaseAvailable - новые версии приложения
library;

import 'dart:async';

import 'package:hvac_control/core/config/api_config.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/api/websocket/js_converter.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRHubConnection {

  SignalRHubConnection(this._apiClient);
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

  final Set<String> _deviceSubscriptions = {};
  bool _subscribedToAll = false;

  /// Флаг для предотвращения race condition при dispose
  bool _isDisposed = false;

  /// Completer для синхронизации конкурентных вызовов connect()
  Completer<void>? _connectCompleter;

  /// Текущее состояние соединения
  HubConnectionState? get state => _connection?.state;

  /// Подключиться к SignalR hub
  ///
  /// Потокобезопасный метод - конкурентные вызовы будут ожидать завершения первого
  Future<void> connect() async {
    // Проверка на disposed
    if (_isDisposed) {
      ApiLogger.logWebSocketError('Cannot connect: SignalR hub is disposed');
      return;
    }

    // Если уже подключены - ничего не делаем
    if (_connection != null &&
        _connection!.state == HubConnectionState.Connected) {
      return;
    }

    // Если уже идёт подключение - ждём его завершения (избегаем race condition)
    if (_connectCompleter != null) {
      await _connectCompleter!.future;
      return;
    }

    _connectCompleter = Completer<void>();

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
        _safeAddToController(_connectionStateController, HubConnectionState.Disconnected);
      });

      _connection!.onreconnecting(({error}) {
        ApiLogger.logWebSocketError('Reconnecting: $error');
        _safeAddToController(_connectionStateController, HubConnectionState.Reconnecting);
      });

      _connection!.onreconnected(({connectionId}) {
        ApiLogger.logWebSocketConnect('Reconnected with ID: $connectionId');
        _safeAddToController(_connectionStateController, HubConnectionState.Connected);
        _resubscribe();
      });

      ApiLogger.logWebSocketConnect(ApiConfig.websocketUrl);
      await _connection!.start();
      _safeAddToController(_connectionStateController, HubConnectionState.Connected);

      // Если это повторный вызов connect (например, после disconnect),
      // нужно восстановить подписки, если они остались в памяти
      // Делаем snapshot для избежания race condition
      final shouldResubscribe = _deviceSubscriptions.isNotEmpty || _subscribedToAll;
      if (shouldResubscribe) {
         await _resubscribe();
      }

      _connectCompleter?.complete();
    } catch (e) {
      ApiLogger.logWebSocketError(e);
      _safeAddToController(_connectionStateController, HubConnectionState.Disconnected);
      _connectCompleter?.completeError(e);
      rethrow;
    } finally {
      _connectCompleter = null;
    }
  }

  /// Безопасно добавить событие в StreamController (проверка на closed/disposed)
  void _safeAddToController<T>(StreamController<T> controller, T event) {
    if (!_isDisposed && !controller.isClosed) {
      controller.add(event);
    }
  }

  /// Восстановление подписок после переподключения
  Future<void> _resubscribe() async {
    if (_isDisposed) {
      return;
    }

    ApiLogger.logWebSocketConnect('Restoring subscriptions...');

    // Snapshot локальных переменных для избежания race condition
    final subscribedToAll = _subscribedToAll;
    final deviceSubscriptions = Set<String>.from(_deviceSubscriptions);

    if (subscribedToAll) {
      try {
        await _connection?.invoke('SubscribeToAllDevices', args: []);
        ApiLogger.logWebSocketConnect('Restored subscription to ALL devices');
      } catch (e) {
        ApiLogger.logWebSocketError('Failed to restore subscription to ALL devices: $e');
      }
    }

    for (final deviceId in deviceSubscriptions) {
      if (_isDisposed) {
        return;
      }
      try {
        await _connection?.invoke('SubscribeToDevice', args: [deviceId]);
        ApiLogger.logWebSocketConnect('Restored subscription to device: $deviceId');
      } catch (e) {
        ApiLogger.logWebSocketError('Failed to restore subscription to device $deviceId: $e');
      }
    }
  }

  /// Обработка обновления устройства из SignalR
  void _handleDeviceUpdate(List<Object?>? arguments) {
    if (_isDisposed) {
      return;
    }

    try {
      final data = arguments?.first;
      final deviceData = convertSignalRData(data);

      if (deviceData != null) {
        ApiLogger.logWebSocketMessage('DeviceUpdated', deviceData);
        _safeAddToController(_deviceUpdatesController, deviceData);
      } else if (data != null) {
        ApiLogger.logWebSocketError('Unknown device data format: ${data.runtimeType}');
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Error handling device update: $e');
    }
  }

  /// Обработка уведомления из SignalR
  void _handleNotification(List<Object?>? arguments) {
    if (_isDisposed) {
      return;
    }

    try {
      final data = arguments?.first;
      final notificationData = convertSignalRData(data);

      if (notificationData != null) {
        ApiLogger.logWebSocketMessage('NotificationReceived', notificationData);
        _safeAddToController(_notificationController, notificationData);
      } else if (data != null) {
        ApiLogger.logWebSocketError('Unknown notification data format: ${data.runtimeType}');
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Error handling notification: $e');
    }
  }

  /// Обработка информации о новом релизе из SignalR
  void _handleRelease(List<Object?>? arguments) {
    if (_isDisposed) {
      return;
    }

    try {
      final data = arguments?.first;
      final releaseData = convertSignalRData(data);

      if (releaseData != null) {
        ApiLogger.logWebSocketMessage('NewReleaseAvailable', releaseData);
        _safeAddToController(_releaseController, releaseData);
      } else if (data != null) {
        ApiLogger.logWebSocketError('Unknown release data format: ${data.runtimeType}');
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Error handling release: $e');
    }
  }

  /// Обработка изменения онлайн-статуса устройства из SignalR
  void _handleStatusChange(List<Object?>? arguments) {
    if (_isDisposed) {
      return;
    }

    try {
      final data = arguments?.first;
      final statusData = convertSignalRData(data);

      if (statusData != null) {
        ApiLogger.logWebSocketMessage('DeviceStatusChanged', statusData);
        _safeAddToController(_statusChangeController, statusData);
      } else if (data != null) {
        ApiLogger.logWebSocketError('Unknown status data format: ${data.runtimeType}');
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Error handling status change: $e');
    }
  }

  /// Подписаться на обновления конкретного устройства
  Future<void> subscribeToDevice(String deviceId) async {
    if (_isDisposed) {
      return;
    }

    _deviceSubscriptions.add(deviceId);
    try {
      if (_connection?.state == HubConnectionState.Connected) {
        await _connection?.invoke('SubscribeToDevice', args: [deviceId]);
        ApiLogger.logWebSocketMessage('SubscribeToDevice', deviceId);
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Failed to subscribe to device: $e');
    }
  }

  /// Отписаться от обновлений устройства
  Future<void> unsubscribeFromDevice(String deviceId) async {
    if (_isDisposed) {
      return;
    }

    _deviceSubscriptions.remove(deviceId);
    try {
      if (_connection?.state == HubConnectionState.Connected) {
        await _connection?.invoke('UnsubscribeFromDevice', args: [deviceId]);
        ApiLogger.logWebSocketMessage('UnsubscribeFromDevice', deviceId);
      }
    } catch (e) {
      ApiLogger.logWebSocketError('Failed to unsubscribe from device: $e');
    }
  }

  /// Подписаться на все устройства
  Future<void> subscribeToAllDevices() async {
    if (_isDisposed) {
      return;
    }

    _subscribedToAll = true;
    try {
      if (_connection?.state == HubConnectionState.Connected) {
        await _connection?.invoke('SubscribeToAllDevices', args: []);
        ApiLogger.logWebSocketMessage('SubscribeToAllDevices', null);
      }
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
    // Очищаем подписки атомарно через snapshot + clear
    _deviceSubscriptions.clear();
    _subscribedToAll = false;

    final connection = _connection;
    _connection = null;

    if (connection != null) {
      try {
        // Отписка от всех событий перед остановкой соединения
        // Это критически важно для hot restart на Flutter Web,
        // чтобы JavaScript callbacks не продолжали работать
        connection
          ..off('DeviceUpdated')
          ..off('DeviceStateChanged')
          ..off('NotificationReceived')
          ..off('NewReleaseAvailable')
          ..off('DeviceStatusChanged');

        await connection.stop();
      } catch (e) {
        ApiLogger.logWebSocketError('Error stopping connection: $e');
      }
    }

    _safeAddToController(_connectionStateController, HubConnectionState.Disconnected);
  }

  Future<void> dispose() async {
    // Сначала помечаем как disposed чтобы остановить все операции
    _isDisposed = true;

    // Ждём завершения текущего подключения если оно идёт
    try {
      await _connectCompleter?.future;
    } catch (_) {
      // Игнорируем ошибки - мы уже disposed
    }

    try {
      await disconnect();
    } catch (e) {
      ApiLogger.logWebSocketError('Error during disconnect: $e');
    }

    // Закрываем все контроллеры
    await _deviceUpdatesController.close();
    await _notificationController.close();
    await _releaseController.close();
    await _statusChangeController.close();
    await _connectionStateController.close();
  }
}
