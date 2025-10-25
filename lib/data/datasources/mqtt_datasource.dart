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

class MqttDatasource {
  MqttServerClient? _client;
  final _unitsController = StreamController<List<HvacUnitModel>>.broadcast();
  final Map<String, StreamController<HvacUnitModel>> _unitControllers = {};
  final Map<String, HvacUnitModel> _unitsCache = {};

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  /// Connect to MQTT broker
  Future<void> connect({
    String? host,
    int? port,
    String? clientId,
  }) async {
    final brokerHost = host ?? AppConstants.mqttBrokerHost;
    final brokerPort = port ?? AppConstants.mqttBrokerPort;
    final mqttClientId = clientId ?? AppConstants.mqttClientId;

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

  /// Disconnect from MQTT broker
  Future<void> disconnect() async {
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

    // Emit to specific unit stream
    if (_unitControllers.containsKey(unit.id)) {
      _unitControllers[unit.id]!.add(unit);
    }

    // Emit to units list stream
    _unitsController.add(_unitsCache.values.toList());
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
