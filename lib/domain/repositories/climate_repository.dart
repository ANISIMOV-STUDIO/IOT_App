/// Репозиторий климат-контроля
library;

import '../entities/climate.dart';
import '../entities/hvac_device.dart';

abstract class ClimateRepository {
  // ============================================
  // MULTI-DEVICE SUPPORT
  // ============================================

  /// Получить все HVAC устройства
  Future<List<HvacDevice>> getAllHvacDevices();

  /// Получить состояние конкретного устройства
  Future<ClimateState> getDeviceState(String deviceId);

  /// Стрим обновлений списка устройств
  Stream<List<HvacDevice>> watchHvacDevices();

  /// Стрим обновлений конкретного устройства
  Stream<ClimateState> watchDeviceClimate(String deviceId);

  // ============================================
  // LEGACY (single device) - для обратной совместимости
  // ============================================

  /// Получить текущее состояние климата (выбранного устройства)
  Future<ClimateState> getCurrentState();

  /// Стрим обновлений климата (выбранного устройства)
  Stream<ClimateState> watchClimate();

  // ============================================
  // DEVICE CONTROL (с опциональным deviceId)
  // ============================================

  /// Включить/выключить устройство
  Future<ClimateState> setPower(bool isOn, {String? deviceId});

  /// Установить целевую температуру
  Future<ClimateState> setTargetTemperature(double temperature, {String? deviceId});

  /// Установить целевую влажность
  Future<ClimateState> setHumidity(double humidity, {String? deviceId});

  /// Установить режим климата
  Future<ClimateState> setMode(ClimateMode mode, {String? deviceId});

  /// Установить приточную вентиляцию (0-100%)
  Future<ClimateState> setSupplyAirflow(double value, {String? deviceId});

  /// Установить вытяжную вентиляцию (0-100%)
  Future<ClimateState> setExhaustAirflow(double value, {String? deviceId});

  /// Установить пресет (auto, night, turbo, eco, away)
  Future<ClimateState> setPreset(String preset, {String? deviceId});

  /// Установить выбранное устройство
  void setSelectedDevice(String deviceId);
}
