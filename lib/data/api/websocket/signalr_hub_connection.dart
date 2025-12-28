/// SignalR Hub connection for real-time updates (Web)
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
  final _connectionStateController =
      StreamController<HubConnectionState>.broadcast();

  SignalRHubConnection(this._apiClient);

  /// Current connection state
  HubConnectionState? get state => _connection?.state;

  /// Connect to SignalR hub
  Future<void> connect() async {
    if (_connection != null &&
        _connection!.state == HubConnectionState.Connected) {
      return;
    }

    try {
      final token = await _apiClient.getAuthToken();

      _connection = HubConnectionBuilder()
          .withUrl(
            ApiConfig.websocketUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token ?? '',
            ),
          )
          .withAutomaticReconnect()
          .build();

      // Subscribe to device updates
      _connection!.on('DeviceUpdated', _handleDeviceUpdate);
      _connection!.on('DeviceStateChanged', _handleDeviceUpdate);

      // Connection state changes
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

  /// Handle device update from SignalR
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

  /// Subscribe to specific device updates
  Future<void> subscribeToDevice(String deviceId) async {
    try {
      await _connection?.invoke('SubscribeToDevice', args: [deviceId]);
      ApiLogger.logWebSocketMessage('SubscribeToDevice', deviceId);
    } catch (e) {
      ApiLogger.logWebSocketError('Failed to subscribe to device: $e');
    }
  }

  /// Unsubscribe from device updates
  Future<void> unsubscribeFromDevice(String deviceId) async {
    try {
      await _connection?.invoke('UnsubscribeFromDevice', args: [deviceId]);
      ApiLogger.logWebSocketMessage('UnsubscribeFromDevice', deviceId);
    } catch (e) {
      ApiLogger.logWebSocketError('Failed to unsubscribe from device: $e');
    }
  }

  /// Stream of device updates
  Stream<Map<String, dynamic>> get deviceUpdates =>
      _deviceUpdatesController.stream;

  /// Stream of connection state changes
  Stream<HubConnectionState> get connectionState =>
      _connectionStateController.stream;

  /// Disconnect
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
    await _connectionStateController.close();
  }
}
