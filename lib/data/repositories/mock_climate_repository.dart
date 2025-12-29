/// Мок-репозиторий климат-контроля
library;

import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/climate.dart';
import '../../domain/entities/hvac_device.dart';
import '../../domain/repositories/climate_repository.dart';
import '../mock/mock_data.dart';

class MockClimateRepository implements ClimateRepository {
  final _climateController = StreamController<ClimateState>.broadcast();
  final _devicesController = StreamController<List<HvacDevice>>.broadcast();

  final Map<String, ClimateState> _deviceStates = {};
  final Map<String, _DeviceMeta> _deviceMeta = {};
  String? _selectedDeviceId;

  MockClimateRepository() {
    _initializeFromMockData();
  }

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
        brand: device['brand'] as String,
        type: device['type'] as String,
        icon: _parseIcon(device['icon'] as String),
        isOnline: device['isOnline'] as bool,
      );
    }

    if (MockData.hvacDevices.isNotEmpty) {
      _selectedDeviceId = MockData.hvacDevices.first['id'] as String;
    }
  }

  ClimateMode _parseClimateMode(String mode) {
    return ClimateMode.values.firstWhere(
      (e) => e.name == mode,
      orElse: () => ClimateMode.auto,
    );
  }

  AirQualityLevel _parseAirQuality(String quality) {
    return AirQualityLevel.values.firstWhere(
      (e) => e.name == quality,
      orElse: () => AirQualityLevel.good,
    );
  }

  IconData _parseIcon(String icon) {
    switch (icon) {
      case 'air':
        return Icons.air;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'water_drop':
        return Icons.water_drop;
      default:
        return Icons.device_hub;
    }
  }

  // ============================================
  // MULTI-DEVICE SUPPORT
  // ============================================

  @override
  Future<List<HvacDevice>> getAllHvacDevices() async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast'] ?? 100));
    return _buildDeviceList();
  }

  @override
  Future<ClimateState> getDeviceState(String deviceId) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast'] ?? 100));
    return _deviceStates[deviceId] ?? _deviceStates.values.first;
  }

  @override
  Stream<List<HvacDevice>> watchHvacDevices() {
    Future.microtask(() => _devicesController.add(_buildDeviceList()));
    return _devicesController.stream;
  }

  @override
  Stream<ClimateState> watchDeviceClimate(String deviceId) {
    return _climateController.stream;
  }

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

  List<HvacDevice> _buildDeviceList() {
    return _deviceStates.entries.where((entry) => _deviceMeta.containsKey(entry.key)).map((entry) {
      final meta = _deviceMeta[entry.key]!;
      final state = entry.value;
      return HvacDevice(
        id: entry.key,
        name: state.deviceName,
        brand: meta.brand,
        type: meta.type,
        isOnline: meta.isOnline,
        isActive: state.isOn,
        icon: meta.icon,
      );
    }).toList();
  }

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
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal'] ?? 100));
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
  Future<ClimateState> setPower(bool isOn, {String? deviceId}) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['slow'] ?? 100));
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
  Future<ClimateState> setTargetTemperature(double temperature, {String? deviceId}) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast'] ?? 100));
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState != null) {
      _deviceStates[id] = currentState.copyWith(targetTemperature: temperature);
      _notifyDeviceChange(id);
      return _deviceStates[id]!;
    }
    throw Exception('Device not found: $id');
  }

  @override
  Future<ClimateState> setHumidity(double humidity, {String? deviceId}) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast'] ?? 100));
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
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal'] ?? 100));
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
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast'] ?? 100));
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
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast'] ?? 100));
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
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal'] ?? 100));
    final id = _resolveDeviceId(deviceId);
    final currentState = _deviceStates[id];
    if (currentState == null) {
      throw Exception('Device not found: $id');
    }

    ClimateState newState = currentState.copyWith(preset: preset);

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

  void dispose() {
    _climateController.close();
    _devicesController.close();
  }
}

class _DeviceMeta {
  final String brand;
  final String type;
  final IconData icon;
  final bool isOnline;

  const _DeviceMeta({
    required this.brand,
    required this.type,
    required this.icon,
    required this.isOnline,
  });
}
