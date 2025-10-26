/// MQTT Datasource
///
/// Handles MQTT communication with the broker
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../core/utils/constants.dart';
import '../models/hvac_unit_model.dart';
import '../models/temperature_reading_model.dart';

class MqttDatasource {
  MqttServerClient? _client;
  final _unitsController = StreamController<List<HvacUnitModel>>.broadcast();
  final Map<String, StreamController<HvacUnitModel>> _unitControllers = {};
  final Map<String, HvacUnitModel> _unitsCache = {};

  // Temperature history storage (unitId -> list of readings)
  final Map<String, List<TemperatureReadingModel>> _temperatureHistory = {};
  static const int _maxHistorySize = 288; // 24 hours at 5-minute intervals

  // Auto-retry configuration
  bool _autoRetry = true;
  int _retryCount = 0;
  static const int _maxRetries = 5;
  static const List<int> _retryDelays = [2, 5, 10, 30, 60]; // seconds
  Timer? _retryTimer;

  // Connection parameters (saved for retry)
  String? _lastHost;
  int? _lastPort;
  String? _lastClientId;

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  bool get autoRetry => _autoRetry;

  set autoRetry(bool value) {
    _autoRetry = value;
    if (!value) {
      _retryTimer?.cancel();
      _retryTimer = null;
      _retryCount = 0;
    }
  }

  /// Connect to MQTT broker
  Future<void> connect({
    String? host,
    int? port,
    String? clientId,
  }) async {
    final brokerHost = host ?? AppConstants.mqttBrokerHost;
    final brokerPort = port ?? AppConstants.mqttBrokerPort;
    final mqttClientId = clientId ?? AppConstants.mqttClientId;

    // Save connection parameters for retry
    _lastHost = brokerHost;
    _lastPort = brokerPort;
    _lastClientId = mqttClientId;

    try {
      await _attemptConnection(brokerHost, brokerPort, mqttClientId);
      // Reset retry count on successful connection
      _retryCount = 0;
    } catch (e) {
      debugPrint('Connection failed: $e');
      if (_autoRetry && _retryCount < _maxRetries) {
        _scheduleRetry();
      }
      rethrow;
    }
  }

  /// Attempt to connect to MQTT broker
  Future<void> _attemptConnection(
    String brokerHost,
    int brokerPort,
    String mqttClientId,
  ) async {
    _client = MqttServerClient.withPort(brokerHost, mqttClientId, brokerPort);

    _client!.logging(on: false);
    _client!.keepAlivePeriod = 60;
    _client!.connectTimeoutPeriod = 5000;
    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onSubscribed = _onSubscribed;
    _client!.pongCallback = _onPong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(mqttClientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
    } on NoConnectionException catch (e) {
      debugPrint('MQTT connection exception: $e');
      _client!.disconnect();
      rethrow;
    } on SocketException catch (e) {
      debugPrint('MQTT socket exception: $e');
      _client!.disconnect();
      rethrow;
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('MQTT connected to $brokerHost:$brokerPort');

      // Subscribe to topics
      _subscribeToTopics();

      // Listen to messages
      _client!.updates!.listen(_onMessage);
    } else {
      debugPrint('MQTT connection failed: ${_client!.connectionStatus}');
      _client!.disconnect();
      throw Exception('MQTT connection failed');
    }
  }

  /// Schedule automatic retry
  void _scheduleRetry() {
    if (!_autoRetry || _retryCount >= _maxRetries) return;

    _retryTimer?.cancel();

    final delaySeconds = _retryDelays[_retryCount.clamp(0, _retryDelays.length - 1)];
    debugPrint('Scheduling retry ${_retryCount + 1}/$_maxRetries in $delaySeconds seconds...');

    _retryTimer = Timer(Duration(seconds: delaySeconds), () async {
      _retryCount++;
      debugPrint('Retry attempt $_retryCount/$_maxRetries');

      try {
        await _attemptConnection(_lastHost!, _lastPort!, _lastClientId!);
        _retryCount = 0; // Reset on success
        debugPrint('Reconnection successful!');
      } catch (e) {
        debugPrint('Retry failed: $e');
        if (_retryCount < _maxRetries) {
          _scheduleRetry();
        } else {
          debugPrint('Max retries reached. Giving up.');
        }
      }
    });
  }

  /// Manually retry connection
  Future<void> retryConnection() async {
    if (_lastHost == null || _lastPort == null || _lastClientId == null) {
      throw Exception('No previous connection parameters available');
    }

    _retryCount = 0;
    _retryTimer?.cancel();

    debugPrint('Manual retry requested...');
    await _attemptConnection(_lastHost!, _lastPort!, _lastClientId!);
  }

  /// Disconnect from MQTT broker
  Future<void> disconnect() async {
    _retryTimer?.cancel();
    _retryTimer = null;
    _retryCount = 0;

    _client?.disconnect();
    await _unitsController.close();
    for (var controller in _unitControllers.values) {
      await controller.close();
    }
  }

  /// Subscribe to MQTT topics
  void _subscribeToTopics() {
    if (_client == null || !isConnected) return;

    // Subscribe to units list
    _client!.subscribe(AppConstants.mqttTopicUnits, MqttQos.atLeastOnce);

    // Subscribe to all unit states
    _client!.subscribe(AppConstants.mqttTopicUnitState, MqttQos.atLeastOnce);

    debugPrint('MQTT subscribed to topics');
  }

  /// Handle incoming MQTT messages
  void _onMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (var message in messages) {
      final topic = message.topic;
      final payload = message.payload as MqttPublishMessage;
      final payloadString = MqttPublishPayload.bytesToStringAsString(
        payload.payload.message,
      );

      debugPrint('MQTT message received: $topic -> $payloadString');

      try {
        if (topic == AppConstants.mqttTopicUnits) {
          _handleUnitsListMessage(payloadString);
        } else if (topic.startsWith('hvac/units/') && topic.endsWith('/state')) {
          _handleUnitStateMessage(payloadString);
        }
      } catch (e) {
        debugPrint('Error parsing MQTT message: $e');
      }
    }
  }

  /// Handle units list message
  void _handleUnitsListMessage(String payload) {
    final List<dynamic> jsonList = json.decode(payload);
    final units = jsonList
        .map((json) => HvacUnitModel.fromJson(json as Map<String, dynamic>))
        .toList();

    // Update cache
    for (var unit in units) {
      _unitsCache[unit.id] = unit;
    }

    _unitsController.add(units);
  }

  /// Handle unit state message
  void _handleUnitStateMessage(String payload) {
    final unit = HvacUnitModel.fromJsonString(payload);

    // Update cache
    _unitsCache[unit.id] = unit;

    // Save temperature reading to history
    _addTemperatureReading(unit.id, unit.currentTemp);

    // Emit to specific unit stream
    if (_unitControllers.containsKey(unit.id)) {
      _unitControllers[unit.id]!.add(unit);
    }

    // Emit to units list stream
    _unitsController.add(_unitsCache.values.toList());
  }

  /// Add temperature reading to history
  void _addTemperatureReading(String unitId, double temperature) {
    if (!_temperatureHistory.containsKey(unitId)) {
      _temperatureHistory[unitId] = [];
    }

    final reading = TemperatureReadingModel(
      timestamp: DateTime.now(),
      temperature: temperature,
    );

    _temperatureHistory[unitId]!.add(reading);

    // Keep only the latest readings (24 hours)
    if (_temperatureHistory[unitId]!.length > _maxHistorySize) {
      _temperatureHistory[unitId]!.removeAt(0);
    }
  }

  /// Get temperature history for a unit
  List<TemperatureReadingModel> getTemperatureHistory(
    String unitId, {
    int hours = 24,
  }) {
    if (!_temperatureHistory.containsKey(unitId)) {
      // If no history, generate some initial data based on current unit
      if (_unitsCache.containsKey(unitId)) {
        return _generateInitialHistory(unitId, hours);
      }
      return [];
    }

    final now = DateTime.now();
    final cutoffTime = now.subtract(Duration(hours: hours));

    return _temperatureHistory[unitId]!
        .where((reading) => reading.timestamp.isAfter(cutoffTime))
        .toList();
  }

  /// Generate initial history data for units without history
  List<TemperatureReadingModel> _generateInitialHistory(
    String unitId,
    int hours,
  ) {
    final unit = _unitsCache[unitId];
    if (unit == null) return [];

    final readings = <TemperatureReadingModel>[];
    final now = DateTime.now();

    // Generate readings for the past hours (every 5 minutes)
    for (int i = hours * 12; i >= 0; i--) {
      final time = now.subtract(Duration(minutes: i * 5));
      // Simulate gradual temperature change
      final progress = 1.0 - (i / (hours * 12));
      final temp = unit.currentTemp - (unit.currentTemp - unit.targetTemp) * progress;

      readings.add(TemperatureReadingModel(
        timestamp: time,
        temperature: temp,
      ));
    }

    // Cache this initial history
    _temperatureHistory[unitId] = readings;

    return readings;
  }

  /// Get all units stream
  Stream<List<HvacUnitModel>> getAllUnits() {
    return _unitsController.stream;
  }

  /// Get single unit stream
  Stream<HvacUnitModel> getUnitById(String unitId) {
    if (!_unitControllers.containsKey(unitId)) {
      _unitControllers[unitId] = StreamController<HvacUnitModel>.broadcast();
    }

    // Emit cached value if available
    if (_unitsCache.containsKey(unitId)) {
      Future.microtask(() {
        if (_unitControllers[unitId]!.hasListener) {
          _unitControllers[unitId]!.add(_unitsCache[unitId]!);
        }
      });
    }

    return _unitControllers[unitId]!.stream;
  }

  /// Publish command to update unit
  Future<void> publishCommand({
    required String unitId,
    bool? power,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
  }) async {
    if (_client == null || !isConnected) {
      throw Exception('MQTT not connected');
    }

    final command = <String, dynamic>{};
    if (power != null) command['power'] = power;
    if (targetTemp != null) command['targetTemp'] = targetTemp;
    if (mode != null) command['mode'] = mode;
    if (fanSpeed != null) command['fanSpeed'] = fanSpeed;

    final topic = AppConstants.mqttTopicUnitCommand(unitId);
    final payload = json.encode(command);

    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    _client!.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
    );

    debugPrint('MQTT command sent: $topic -> $payload');
  }

  /// Add a new HVAC device by MAC address
  Future<void> addDevice({
    required String macAddress,
    required String name,
    String? location,
  }) async {
    if (_client == null || !isConnected) {
      throw Exception('MQTT not connected');
    }

    // Validate MAC address format
    final macRegex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
    if (!macRegex.hasMatch(macAddress)) {
      throw ArgumentError('Invalid MAC address format');
    }

    // Normalize MAC address (remove : or - and convert to uppercase)
    final normalizedMac = macAddress.replaceAll(RegExp(r'[:-]'), '').toUpperCase();

    final deviceConfig = {
      'action': 'add',
      'mac': normalizedMac,
      'name': name,
      'location': location ?? 'Unknown',
      'timestamp': DateTime.now().toIso8601String(),
    };

    const topic = 'hvac/devices/config';
    final payload = json.encode(deviceConfig);

    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    _client!.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
    );

    debugPrint('Device add command sent: $topic -> $payload');
  }

  /// Remove an HVAC device by MAC address or unit ID
  Future<void> removeDevice({
    String? macAddress,
    String? unitId,
  }) async {
    if (_client == null || !isConnected) {
      throw Exception('MQTT not connected');
    }

    if (macAddress == null && unitId == null) {
      throw ArgumentError('Either macAddress or unitId must be provided');
    }

    String identifier;
    String identifierType;

    if (macAddress != null) {
      // Validate MAC address format
      final macRegex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
      if (!macRegex.hasMatch(macAddress)) {
        throw ArgumentError('Invalid MAC address format');
      }
      identifier = macAddress.replaceAll(RegExp(r'[:-]'), '').toUpperCase();
      identifierType = 'mac';
    } else {
      identifier = unitId!;
      identifierType = 'id';
    }

    final deviceConfig = {
      'action': 'remove',
      identifierType: identifier,
      'timestamp': DateTime.now().toIso8601String(),
    };

    const topic = 'hvac/devices/config';
    final payload = json.encode(deviceConfig);

    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    _client!.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
    );

    // Remove from local cache if removing by unitId
    if (unitId != null) {
      _unitsCache.remove(unitId);
      _unitControllers[unitId]?.close();
      _unitControllers.remove(unitId);
      _temperatureHistory.remove(unitId);
      // Update units stream
      _unitsController.add(_unitsCache.values.toList());
    }

    debugPrint('Device remove command sent: $topic -> $payload');
  }

  // Callbacks
  void _onConnected() {
    debugPrint('MQTT connected callback');
  }

  void _onDisconnected() {
    debugPrint('MQTT disconnected callback');
  }

  void _onSubscribed(String topic) {
    debugPrint('MQTT subscribed to: $topic');
  }

  void _onPong() {
    // print('MQTT ping response received');
  }
}
