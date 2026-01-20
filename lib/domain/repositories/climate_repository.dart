/// Climate Repository - Unified interface for climate operations
///
/// This repository combines three separate concerns following ISP:
/// - HvacDeviceProvider: Device management
/// - ClimateStateProvider: State access
/// - ClimateController: Control operations
library;

import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/repositories/climate_controller.dart';
import 'package:hvac_control/domain/repositories/climate_state_provider.dart';
import 'package:hvac_control/domain/repositories/hvac_device_provider.dart';

export 'climate_controller.dart';
export 'climate_state_provider.dart';
export 'hvac_device_provider.dart';

/// Unified climate repository interface
///
/// Combines [HvacDeviceProvider], [ClimateStateProvider], and [ClimateController]
/// for backward compatibility while allowing clients to depend on smaller interfaces.
abstract class ClimateRepository
    implements HvacDeviceProvider, ClimateStateProvider, ClimateController {
  // ============================================
  // MULTI-DEVICE SUPPORT (from HvacDeviceProvider)
  // ============================================

  /// Get all HVAC devices
  @override
  Future<List<HvacDevice>> getAllHvacDevices();

  /// Watch for device list updates
  @override
  Stream<List<HvacDevice>> watchHvacDevices();

  /// Set the currently selected device
  @override
  void setSelectedDevice(String deviceId);

  // ============================================
  // STATE ACCESS (from ClimateStateProvider)
  // ============================================

  /// Get state of a specific device
  @override
  Future<ClimateState> getDeviceState(String deviceId);

  /// Watch for climate updates of a specific device
  @override
  Stream<ClimateState> watchDeviceClimate(String deviceId);

  /// Get current state (selected device) - legacy support
  @override
  Future<ClimateState> getCurrentState();

  /// Watch current climate (selected device) - legacy support
  @override
  Stream<ClimateState> watchClimate();

  // ============================================
  // CONTROL OPERATIONS (from ClimateController)
  // ============================================

  /// Turn device on/off
  @override
  Future<ClimateState> setPower({required bool isOn, String? deviceId});

  /// Set target temperature
  @override
  Future<ClimateState> setTargetTemperature(double temperature, {String? deviceId});

  /// Set target humidity
  @override
  Future<ClimateState> setHumidity(double humidity, {String? deviceId});

  /// Set climate mode
  @override
  Future<ClimateState> setMode(ClimateMode mode, {String? deviceId});

  /// Set supply airflow (0-100%)
  @override
  Future<ClimateState> setSupplyAirflow(double value, {String? deviceId});

  /// Set exhaust airflow (0-100%)
  @override
  Future<ClimateState> setExhaustAirflow(double value, {String? deviceId});

  /// Set preset (auto, night, turbo, eco, away)
  @override
  Future<ClimateState> setPreset(String preset, {String? deviceId});

  /// Set operating mode (basic, intensive, economy, max_performance, kitchen, fireplace, vacation, custom)
  Future<ClimateState> setOperatingMode(String mode, {String? deviceId});

  // ============================================
  // DEVICE REGISTRATION
  // ============================================

  /// Register new device by MAC address
  Future<HvacDevice> registerDevice(String macAddress, String name);

  /// Delete device
  Future<void> deleteDevice(String deviceId);

  /// Rename device
  Future<void> renameDevice(String deviceId, String newName);

  // ============================================
  // FULL STATE (with alarms, mode settings, etc.)
  // ============================================

  /// Get full device state including alarms and mode settings
  Future<DeviceFullState> getDeviceFullState(String deviceId);

  /// Watch for real-time updates of device full state
  /// Returns a stream that emits when device state changes (e.g., from physical remote)
  Stream<DeviceFullState> watchDeviceFullState(String deviceId);

  // ============================================
  // ALARM HISTORY
  // ============================================

  /// Получить историю аварий устройства
  Future<List<AlarmHistory>> getAlarmHistory(String deviceId, {int limit = 100});

  /// Сбросить активные аварии устройства
  Future<void> resetAlarm(String deviceId);

  // ============================================
  // DEVICE TIME SETTING
  // ============================================

  /// Установить время на устройстве
  @override
  Future<void> setDeviceTime(DateTime time, {String? deviceId});

  // ============================================
  // DEVICE UPDATE REQUEST
  // ============================================

  /// Запросить принудительное обновление данных от устройства
  ///
  /// Отправляет команду устройству опубликовать актуальные данные.
  /// Вызывается при загрузке страницы для получения свежих данных с пульта.
  Future<void> requestDeviceUpdate({String? deviceId});

  // ============================================
  // QUICK MODE
  // ============================================

  /// Установить быстрый режим (все настройки одним запросом)
  ///
  /// Вызывается при изменении любого параметра в главном виджете управления.
  /// Отправляет текущие значения всех настроек включая изменённый параметр.
  Future<void> setQuickMode({
    required int heatingTemperature,
    required int coolingTemperature,
    required int supplyFan,
    required int exhaustFan,
    String? deviceId,
  });
}
