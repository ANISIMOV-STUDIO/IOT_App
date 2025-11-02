/// HVAC Unit Entity
///
/// Core business object representing a single HVAC/Ventilation unit
library;

import 'package:equatable/equatable.dart';
import 'device_type.dart';
import 'ventilation_mode.dart';
import 'mode_preset.dart';
import 'week_schedule.dart';
import 'wifi_status.dart';
import 'alert.dart';

class HvacUnit extends Equatable {
  // Basic properties
  final String id;
  final String name;
  final bool power;
  final double currentTemp;
  final double targetTemp;
  final String mode; // cooling, heating, fan, auto
  final String fanSpeed; // low, medium, high, auto
  final DateTime timestamp;
  final String? macAddress; // MAC address of the device
  final String? location; // Physical location of the device
  final double humidity; // Humidity percentage

  // Device type
  final DeviceType deviceType; // ventilation, hvac, ac, heater

  // Ventilation-specific properties
  final double? supplyAirTemp; // Температура притока (°C)
  final double? roomTemp; // Температура в помещении (°C)
  final double? outdoorTemp; // Температура на улице (°C)
  final double? heatingTemp; // Температура нагрева - уставка (°C)
  final double? coolingTemp; // Температура охлаждения - уставка (°C)

  // Fan speeds for ventilation (0-100%)
  final int? supplyFanSpeed; // Приточный вентилятор (%)
  final int? exhaustFanSpeed; // Вытяжной вентилятор (%)

  // Ventilation mode
  final VentilationMode? ventMode; // Режим работы вентиляции
  final Map<VentilationMode, ModePreset>? modePresets; // Настройки режимов

  // Schedule
  final WeekSchedule? schedule; // Недельное расписание

  // WiFi status
  final WiFiStatus? wifiStatus; // Статус WiFi подключения

  // Alerts
  final List<Alert>? alerts; // Список аварий/ошибок

  const HvacUnit({
    required this.id,
    required this.name,
    required this.power,
    required this.currentTemp,
    required this.targetTemp,
    required this.mode,
    required this.fanSpeed,
    required this.timestamp,
    this.macAddress,
    this.location,
    this.humidity = 50.0,
    this.deviceType = DeviceType.hvac,
    this.supplyAirTemp,
    this.roomTemp,
    this.outdoorTemp,
    this.heatingTemp,
    this.coolingTemp,
    this.supplyFanSpeed,
    this.exhaustFanSpeed,
    this.ventMode,
    this.modePresets,
    this.schedule,
    this.wifiStatus,
    this.alerts,
  });

  /// Create a copy with updated fields
  HvacUnit copyWith({
    String? id,
    String? name,
    bool? power,
    double? currentTemp,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
    DateTime? timestamp,
    String? macAddress,
    String? location,
    double? humidity,
    DeviceType? deviceType,
    double? supplyAirTemp,
    double? roomTemp,
    double? outdoorTemp,
    double? heatingTemp,
    double? coolingTemp,
    int? supplyFanSpeed,
    int? exhaustFanSpeed,
    VentilationMode? ventMode,
    Map<VentilationMode, ModePreset>? modePresets,
    WeekSchedule? schedule,
    WiFiStatus? wifiStatus,
    List<Alert>? alerts,
  }) {
    return HvacUnit(
      id: id ?? this.id,
      name: name ?? this.name,
      power: power ?? this.power,
      currentTemp: currentTemp ?? this.currentTemp,
      targetTemp: targetTemp ?? this.targetTemp,
      mode: mode ?? this.mode,
      fanSpeed: fanSpeed ?? this.fanSpeed,
      timestamp: timestamp ?? this.timestamp,
      macAddress: macAddress ?? this.macAddress,
      location: location ?? this.location,
      humidity: humidity ?? this.humidity,
      deviceType: deviceType ?? this.deviceType,
      supplyAirTemp: supplyAirTemp ?? this.supplyAirTemp,
      roomTemp: roomTemp ?? this.roomTemp,
      outdoorTemp: outdoorTemp ?? this.outdoorTemp,
      heatingTemp: heatingTemp ?? this.heatingTemp,
      coolingTemp: coolingTemp ?? this.coolingTemp,
      supplyFanSpeed: supplyFanSpeed ?? this.supplyFanSpeed,
      exhaustFanSpeed: exhaustFanSpeed ?? this.exhaustFanSpeed,
      ventMode: ventMode ?? this.ventMode,
      modePresets: modePresets ?? this.modePresets,
      schedule: schedule ?? this.schedule,
      wifiStatus: wifiStatus ?? this.wifiStatus,
      alerts: alerts ?? this.alerts,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        power,
        currentTemp,
        targetTemp,
        mode,
        fanSpeed,
        timestamp,
        macAddress,
        location,
        humidity,
        deviceType,
        supplyAirTemp,
        roomTemp,
        outdoorTemp,
        heatingTemp,
        coolingTemp,
        supplyFanSpeed,
        exhaustFanSpeed,
        ventMode,
        modePresets,
        schedule,
        wifiStatus,
        alerts,
      ];

  /// Check if this is a ventilation unit
  bool get isVentilation => deviceType == DeviceType.ventilation;

  /// Get current mode preset for ventilation
  ModePreset? get currentModePreset {
    if (ventMode != null && modePresets != null) {
      return modePresets![ventMode];
    }
    return null;
  }

  @override
  String toString() {
    return 'HvacUnit(id: $id, name: $name, type: $deviceType, power: $power, currentTemp: $currentTemp°C, targetTemp: $targetTemp°C, mode: $mode, fanSpeed: $fanSpeed)';
  }
}
