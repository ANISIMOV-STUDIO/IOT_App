import 'package:equatable/equatable.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';

/// Полное состояние устройства с бэкенда
/// Включает настройки режимов, таймера и аварии
class DeviceFullState extends Equatable {

  const DeviceFullState({
    required this.id,
    required this.name,
    this.macAddress = '',
    this.power = false,
    this.mode = ClimateMode.auto,
    this.currentTemperature = 20.0,
    this.targetTemperature = 22.0,
    this.humidity = 50.0,
    this.targetHumidity = 50.0,
    this.operatingMode = 'basic',
    this.scheduleIndicator,
    this.isOnline = true,
    this.outdoorTemperature,
    this.kpdRecuperator,
    this.indoorTemperature,
    this.supplyTemperature,
    this.supplyTempAfterRecup,
    this.co2Level,
    this.freeCooling = false,
    this.heaterPower,
    this.coolerStatus,
    this.ductPressure,
    this.modeSettings,
    this.timerSettings,
    this.activeAlarms,
    this.isScheduleEnabled = false,
    this.quickSensors = const ['outside_temp', 'indoor_temp', 'humidity'],
    this.deviceTime,
    this.updatedAt,
  });
  final String id;
  final String name;
  final String macAddress;
  final bool power;
  final ClimateMode mode;
  final double currentTemperature;
  final double targetTemperature;
  final double humidity;
  final double targetHumidity;
  
  /// Текущий режим (Basic, Intensive и т.д.)
  final String operatingMode;

  final int? scheduleIndicator;
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

  /// Свободное охлаждение рекуператора (Вкл/Выкл)
  final bool freeCooling;

  /// Мощность работы нагревателя (%) - из JSON поля "power"
  final int? heaterPower;

  /// Статус охладителя (Отсутствует/Выключен/Включен)
  final String? coolerStatus;

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

  /// Быстрые показатели для главного экрана
  final List<String> quickSensors;

  /// Текущее время устройства
  final DateTime? deviceTime;

  /// Время последней синхронизации с сервером
  final DateTime? updatedAt;

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
    int? scheduleIndicator,
    bool? isOnline,
    double? outdoorTemperature,
    int? kpdRecuperator,
    double? indoorTemperature,
    double? supplyTemperature,
    double? supplyTempAfterRecup,
    int? co2Level,
    bool? freeCooling,
    int? heaterPower,
    String? coolerStatus,
    int? ductPressure,
    Map<String, ModeSettings>? modeSettings,
    Map<String, TimerSettings>? timerSettings,
    Map<String, AlarmInfo>? activeAlarms,
    bool? isScheduleEnabled,
    double? targetHumidity,
    String? operatingMode,
    List<String>? quickSensors,
    DateTime? deviceTime,
    DateTime? updatedAt,
  }) => DeviceFullState(
      id: id ?? this.id,
      name: name ?? this.name,
      macAddress: macAddress ?? this.macAddress,
      power: power ?? this.power,
      mode: mode ?? this.mode,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      targetTemperature: targetTemperature ?? this.targetTemperature,
      humidity: humidity ?? this.humidity,
      targetHumidity: targetHumidity ?? this.targetHumidity,
      operatingMode: operatingMode ?? this.operatingMode,
      scheduleIndicator: scheduleIndicator ?? this.scheduleIndicator,
      isOnline: isOnline ?? this.isOnline,
      outdoorTemperature: outdoorTemperature ?? this.outdoorTemperature,
      kpdRecuperator: kpdRecuperator ?? this.kpdRecuperator,
      indoorTemperature: indoorTemperature ?? this.indoorTemperature,
      supplyTemperature: supplyTemperature ?? this.supplyTemperature,
      supplyTempAfterRecup: supplyTempAfterRecup ?? this.supplyTempAfterRecup,
      co2Level: co2Level ?? this.co2Level,
      freeCooling: freeCooling ?? this.freeCooling,
      heaterPower: heaterPower ?? this.heaterPower,
      coolerStatus: coolerStatus ?? this.coolerStatus,
      ductPressure: ductPressure ?? this.ductPressure,
      modeSettings: modeSettings ?? this.modeSettings,
      timerSettings: timerSettings ?? this.timerSettings,
      activeAlarms: activeAlarms ?? this.activeAlarms,
      isScheduleEnabled: isScheduleEnabled ?? this.isScheduleEnabled,
      quickSensors: quickSensors ?? this.quickSensors,
      deviceTime: deviceTime ?? this.deviceTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );

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
        targetHumidity,
        operatingMode,
        scheduleIndicator,
        isOnline,
        outdoorTemperature,
        kpdRecuperator,
        indoorTemperature,
        supplyTemperature,
        supplyTempAfterRecup,
        co2Level,
        freeCooling,
        heaterPower,
        coolerStatus,
        ductPressure,
        modeSettings,
        timerSettings,
        activeAlarms,
        isScheduleEnabled,
        quickSensors,
        deviceTime,
        updatedAt,
      ];
}
