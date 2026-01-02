import 'package:equatable/equatable.dart';

import 'climate.dart';
import 'alarm_info.dart';
import 'mode_settings.dart';

/// Полное состояние устройства с бэкенда
/// Включает настройки режимов, таймера и аварии
class DeviceFullState extends Equatable {
  final String id;
  final String name;
  final String macAddress;
  final bool power;
  final ClimateMode mode;
  final double currentTemperature;
  final double targetTemperature;
  final double humidity;
  final String? supplyFan;
  final String? exhaustFan;
  final int? scheduleIndicator;
  final int? devicePower;
  final bool isOnline;

  /// Настройки режимов (basic, intensive, economy и т.д.)
  final Map<String, ModeSettings>? modeSettings;

  /// Настройки таймера по дням недели
  final Map<String, TimerSettings>? timerSettings;

  /// Активные аварии
  final Map<String, AlarmInfo>? activeAlarms;

  const DeviceFullState({
    required this.id,
    required this.name,
    this.macAddress = '',
    this.power = false,
    this.mode = ClimateMode.auto,
    this.currentTemperature = 20.0,
    this.targetTemperature = 22.0,
    this.humidity = 50.0,
    this.supplyFan,
    this.exhaustFan,
    this.scheduleIndicator,
    this.devicePower,
    this.isOnline = true,
    this.modeSettings,
    this.timerSettings,
    this.activeAlarms,
  });

  /// Есть ли активные аварии
  bool get hasAlarms => activeAlarms != null && activeAlarms!.isNotEmpty;

  /// Количество активных аварий
  int get alarmCount => activeAlarms?.length ?? 0;

  /// Включено ли расписание
  bool get isScheduleEnabled => scheduleIndicator != null && scheduleIndicator! > 0;

  DeviceFullState copyWith({
    String? id,
    String? name,
    String? macAddress,
    bool? power,
    ClimateMode? mode,
    double? currentTemperature,
    double? targetTemperature,
    double? humidity,
    String? supplyFan,
    String? exhaustFan,
    int? scheduleIndicator,
    int? devicePower,
    bool? isOnline,
    Map<String, ModeSettings>? modeSettings,
    Map<String, TimerSettings>? timerSettings,
    Map<String, AlarmInfo>? activeAlarms,
  }) {
    return DeviceFullState(
      id: id ?? this.id,
      name: name ?? this.name,
      macAddress: macAddress ?? this.macAddress,
      power: power ?? this.power,
      mode: mode ?? this.mode,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      targetTemperature: targetTemperature ?? this.targetTemperature,
      humidity: humidity ?? this.humidity,
      supplyFan: supplyFan ?? this.supplyFan,
      exhaustFan: exhaustFan ?? this.exhaustFan,
      scheduleIndicator: scheduleIndicator ?? this.scheduleIndicator,
      devicePower: devicePower ?? this.devicePower,
      isOnline: isOnline ?? this.isOnline,
      modeSettings: modeSettings ?? this.modeSettings,
      timerSettings: timerSettings ?? this.timerSettings,
      activeAlarms: activeAlarms ?? this.activeAlarms,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        macAddress,
        power,
        mode,
        currentTemperature,
        targetTemperature,
        humidity,
        supplyFan,
        exhaustFan,
        scheduleIndicator,
        devicePower,
        isOnline,
        modeSettings,
        timerSettings,
        activeAlarms,
      ];
}
