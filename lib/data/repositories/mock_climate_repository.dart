/// Мок-репозиторий климат-контроля с поддержкой нескольких устройств
library;

import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/climate.dart';
import '../../domain/entities/hvac_device.dart';
import '../../domain/repositories/climate_repository.dart';

class MockClimateRepository implements ClimateRepository {
  final _climateController = StreamController<ClimateState>.broadcast();
  final _devicesController = StreamController<List<HvacDevice>>.broadcast();

  // Хранение состояний всех устройств
  final Map<String, ClimateState> _deviceStates = {};

  // Метаданные устройств (бренд, тип, иконка)
  final Map<String, _DeviceMeta> _deviceMeta = {};

  // Выбранное устройство
  String _selectedDeviceId = 'zilon-1';

  MockClimateRepository() {
    _initializeMockDevices();
  }

  void _initializeMockDevices() {
    // ZILON - Приточная установка
    _deviceStates['zilon-1'] = const ClimateState(
      roomId: 'main',
      deviceName: 'ZILON ZPE-6000',
      currentTemperature: 21.5,
      targetTemperature: 22.0,
      humidity: 58.0,
      targetHumidity: 50.0,
      supplyAirflow: 65.0,
      exhaustAirflow: 50.0,
      mode: ClimateMode.auto,
      preset: 'auto',
      airQuality: AirQualityLevel.good,
      co2Ppm: 720,
      pollutantsAqi: 45,
      isOn: true,
    );
    _deviceMeta['zilon-1'] = _DeviceMeta(
      brand: 'ZILON',
      type: 'Приточная установка',
      icon: Icons.air,
      isOnline: true,
    );

    // LG - Сплит-система
    _deviceStates['lg-1'] = const ClimateState(
      roomId: 'bedroom',
      deviceName: 'LG Dual Inverter',
      currentTemperature: 24.0,
      targetTemperature: 23.0,
      humidity: 45.0,
      targetHumidity: 45.0,
      supplyAirflow: 40.0,
      exhaustAirflow: 0.0,
      mode: ClimateMode.cooling,
      preset: 'auto',
      airQuality: AirQualityLevel.excellent,
      co2Ppm: 520,
      pollutantsAqi: 25,
      isOn: false,
    );
    _deviceMeta['lg-1'] = _DeviceMeta(
      brand: 'LG',
      type: 'Сплит-система',
      icon: Icons.ac_unit,
      isOnline: true,
    );

    // Xiaomi - Увлажнитель
    _deviceStates['xiaomi-1'] = const ClimateState(
      roomId: 'living',
      deviceName: 'Xiaomi Mi Humidifier',
      currentTemperature: 22.0,
      targetTemperature: 22.0,
      humidity: 52.0,
      targetHumidity: 55.0,
      supplyAirflow: 30.0,
      exhaustAirflow: 0.0,
      mode: ClimateMode.ventilation,
      preset: 'auto',
      airQuality: AirQualityLevel.good,
      co2Ppm: 650,
      pollutantsAqi: 38,
      isOn: false,
    );
    _deviceMeta['xiaomi-1'] = _DeviceMeta(
      brand: 'Xiaomi',
      type: 'Увлажнитель',
      icon: Icons.water_drop,
      isOnline: false,
    );
  }

  // ============================================
  // MULTI-DEVICE SUPPORT
  // ============================================

  @override
  Future<List<HvacDevice>> getAllHvacDevices() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _buildDeviceList();
  }

  @override
  Future<ClimateState> getDeviceState(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _deviceStates[deviceId] ?? _deviceStates.values.first;
  }

  @override
  Stream<List<HvacDevice>> watchHvacDevices() {
    Future.microtask(() => _devicesController.add(_buildDeviceList()));
    return _devicesController.stream;
  }

  @override
  Stream<ClimateState> watchDeviceClimate(String deviceId) {
    // Возвращаем общий стрим, фильтруя по deviceId не нужно -
    // используем _selectedDeviceId для определения какое устройство отслеживать
    return _climateController.stream;
  }

  @override
  void setSelectedDevice(String deviceId) {
    if (_deviceStates.containsKey(deviceId)) {
      _selectedDeviceId = deviceId;
      _climateController.add(_deviceStates[deviceId]!);
    }
  }

  List<HvacDevice> _buildDeviceList() {
    return _deviceStates.entries.map((entry) {
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
    // Обновляем список устройств
    _devicesController.add(_buildDeviceList());

    // Если это выбранное устройство - обновляем климат стрим
    if (deviceId == _selectedDeviceId) {
      _climateController.add(_deviceStates[deviceId]!);
    }
  }

  // ============================================
  // LEGACY (single device)
  // ============================================

  @override
  Future<ClimateState> getCurrentState() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _deviceStates[_selectedDeviceId]!;
  }

  @override
  Stream<ClimateState> watchClimate() {
    Future.microtask(() => _climateController.add(_deviceStates[_selectedDeviceId]!));
    return _climateController.stream;
  }

  // ============================================
  // DEVICE CONTROL
  // ============================================

  String _resolveDeviceId(String? deviceId) => deviceId ?? _selectedDeviceId;

  @override
  Future<ClimateState> setPower(bool isOn, {String? deviceId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final id = _resolveDeviceId(deviceId);
    _deviceStates[id] = _deviceStates[id]!.copyWith(isOn: isOn);
    _notifyDeviceChange(id);
    return _deviceStates[id]!;
  }

  @override
  Future<ClimateState> setTargetTemperature(double temperature, {String? deviceId}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final id = _resolveDeviceId(deviceId);
    _deviceStates[id] = _deviceStates[id]!.copyWith(targetTemperature: temperature);
    _notifyDeviceChange(id);
    return _deviceStates[id]!;
  }

  @override
  Future<ClimateState> setHumidity(double humidity, {String? deviceId}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final id = _resolveDeviceId(deviceId);
    _deviceStates[id] = _deviceStates[id]!.copyWith(targetHumidity: humidity);
    _notifyDeviceChange(id);
    return _deviceStates[id]!;
  }

  @override
  Future<ClimateState> setMode(ClimateMode mode, {String? deviceId}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final id = _resolveDeviceId(deviceId);
    _deviceStates[id] = _deviceStates[id]!.copyWith(
      mode: mode,
      isOn: mode != ClimateMode.off,
    );
    _notifyDeviceChange(id);
    return _deviceStates[id]!;
  }

  @override
  Future<ClimateState> setSupplyAirflow(double value, {String? deviceId}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final id = _resolveDeviceId(deviceId);
    _deviceStates[id] = _deviceStates[id]!.copyWith(supplyAirflow: value);
    _notifyDeviceChange(id);
    return _deviceStates[id]!;
  }

  @override
  Future<ClimateState> setExhaustAirflow(double value, {String? deviceId}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final id = _resolveDeviceId(deviceId);
    _deviceStates[id] = _deviceStates[id]!.copyWith(exhaustAirflow: value);
    _notifyDeviceChange(id);
    return _deviceStates[id]!;
  }

  @override
  Future<ClimateState> setPreset(String preset, {String? deviceId}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final id = _resolveDeviceId(deviceId);

    ClimateState newState = _deviceStates[id]!.copyWith(preset: preset);
    switch (preset) {
      case 'auto':
        newState = newState.copyWith(mode: ClimateMode.auto);
        break;
      case 'night':
        newState = newState.copyWith(
          targetTemperature: 19.0,
          supplyAirflow: 30.0,
          exhaustAirflow: 25.0,
        );
        break;
      case 'turbo':
        newState = newState.copyWith(
          supplyAirflow: 100.0,
          exhaustAirflow: 90.0,
        );
        break;
      case 'eco':
        newState = newState.copyWith(
          targetTemperature: 20.0,
          supplyAirflow: 40.0,
          exhaustAirflow: 35.0,
        );
        break;
      case 'away':
        newState = newState.copyWith(
          targetTemperature: 16.0,
          supplyAirflow: 20.0,
          exhaustAirflow: 15.0,
        );
        break;
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
