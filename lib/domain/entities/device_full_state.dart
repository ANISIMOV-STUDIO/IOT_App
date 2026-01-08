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

  /// Целевая температура нагрева
  final int? heatingTemperature;

  /// Целевая температура охлаждения
  final int? coolingTemperature;
  final String? supplyFan;
  final String? exhaustFan;
  final int? scheduleIndicator;
  final int? devicePower;
  final bool isOnline;

  /// Уличная температура (с датчика устройства)
  final double? outdoorTemperature;

  /// КПД рекуператора (0-100%)
  final int? kpdRecuperator;

  // ============================================
  // НОВЫЕ ДАТЧИКИ ДЛЯ SENSORS GRID
  // ============================================

  /// Температура воздуха в помещении
  final double? indoorTemperature;

  /// Температура приточного воздуха
  final double? supplyTemperature;

  /// Температура приточного воздуха после рекуператора (setpoint)
  final double? supplyTempAfterRecup;

  /// Концентрация CO2 (ppm)
  final int? co2Level;

  /// Свободное охлаждение рекуператора (м³/ч)
  final int? freeCooling;

  /// Производительность электрического нагревателя (%)
  final int? heaterPerformance;

  /// Статус охладителя (%)
  final int? coolerStatus;

  /// Давление в воздуховоде (Па)
  final int? ductPressure;

  /// Настройки режимов (basic, intensive, economy и т.д.)
  final Map<String, ModeSettings>? modeSettings;

  /// Настройки таймера по дням недели
  final Map<String, TimerSettings>? timerSettings;

  /// Активные аварии
  final Map<String, AlarmInfo>? activeAlarms;

  /// Включено ли расписание
  final bool isScheduleEnabled;

  const DeviceFullState({
    required this.id,
    required this.name,
    this.macAddress = '',
    this.power = false,
    this.mode = ClimateMode.auto,
    this.currentTemperature = 20.0,
    this.targetTemperature = 22.0,
    this.humidity = 50.0,
    this.heatingTemperature,
    this.coolingTemperature,
    this.supplyFan,
    this.exhaustFan,
    this.scheduleIndicator,
    this.devicePower,
    this.isOnline = true,
    this.outdoorTemperature,
    this.kpdRecuperator,
    this.indoorTemperature,
    this.supplyTemperature,
    this.supplyTempAfterRecup,
    this.co2Level,
    this.freeCooling,
    this.heaterPerformance,
    this.coolerStatus,
    this.ductPressure,
    this.modeSettings,
    this.timerSettings,
    this.activeAlarms,
    this.isScheduleEnabled = false,
  });

  /// Есть ли активные аварии
  bool get hasAlarms => activeAlarms != null && activeAlarms!.isNotEmpty;

  /// Количество активных аварий
  int get alarmCount => activeAlarms?.length ?? 0;

  DeviceFullState copyWith({
    String? id,
    String? name,
    String? macAddress,
    bool? power,
    ClimateMode? mode,
    double? currentTemperature,
    double? targetTemperature,
    double? humidity,
    int? heatingTemperature,
    int? coolingTemperature,
    String? supplyFan,
    String? exhaustFan,
    int? scheduleIndicator,
    int? devicePower,
    bool? isOnline,
    double? outdoorTemperature,
    int? kpdRecuperator,
    double? indoorTemperature,
    double? supplyTemperature,
    double? supplyTempAfterRecup,
    int? co2Level,
    int? freeCooling,
    int? heaterPerformance,
    int? coolerStatus,
    int? ductPressure,
    Map<String, ModeSettings>? modeSettings,
    Map<String, TimerSettings>? timerSettings,
    Map<String, AlarmInfo>? activeAlarms,
    bool? isScheduleEnabled,
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
      heatingTemperature: heatingTemperature ?? this.heatingTemperature,
      coolingTemperature: coolingTemperature ?? this.coolingTemperature,
      supplyFan: supplyFan ?? this.supplyFan,
      exhaustFan: exhaustFan ?? this.exhaustFan,
      scheduleIndicator: scheduleIndicator ?? this.scheduleIndicator,
      devicePower: devicePower ?? this.devicePower,
      isOnline: isOnline ?? this.isOnline,
      outdoorTemperature: outdoorTemperature ?? this.outdoorTemperature,
      kpdRecuperator: kpdRecuperator ?? this.kpdRecuperator,
      indoorTemperature: indoorTemperature ?? this.indoorTemperature,
      supplyTemperature: supplyTemperature ?? this.supplyTemperature,
      supplyTempAfterRecup: supplyTempAfterRecup ?? this.supplyTempAfterRecup,
      co2Level: co2Level ?? this.co2Level,
      freeCooling: freeCooling ?? this.freeCooling,
      heaterPerformance: heaterPerformance ?? this.heaterPerformance,
      coolerStatus: coolerStatus ?? this.coolerStatus,
      ductPressure: ductPressure ?? this.ductPressure,
      modeSettings: modeSettings ?? this.modeSettings,
      timerSettings: timerSettings ?? this.timerSettings,
      activeAlarms: activeAlarms ?? this.activeAlarms,
      isScheduleEnabled: isScheduleEnabled ?? this.isScheduleEnabled,
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
        heatingTemperature,
        coolingTemperature,
        supplyFan,
        exhaustFan,
        scheduleIndicator,
        devicePower,
        isOnline,
        outdoorTemperature,
        kpdRecuperator,
        indoorTemperature,
        supplyTemperature,
        supplyTempAfterRecup,
        co2Level,
        freeCooling,
        heaterPerformance,
        coolerStatus,
        ductPressure,
        modeSettings,
        timerSettings,
        activeAlarms,
        isScheduleEnabled,
      ];
}
