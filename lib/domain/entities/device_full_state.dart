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
    this.recuperatorTemperature,
    this.indoorTemperature,
    this.supplyTemperature,
    this.coIndicator,
    this.freeCooling = false,
    this.heaterPower,
    this.coolerStatus,
    this.ductPressure,
    this.actualSupplyFan,
    this.actualExhaustFan,
    this.temperatureSetpoint,
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

  /// Температура рекуператора (°C)
  final double? recuperatorTemperature;

  // ============================================
  // НОВЫЕ ДАТЧИКИ ДЛЯ SENSORS GRID
  // ============================================

  /// Температура воздуха в помещении
  final double? indoorTemperature;

  /// Температура приточного воздуха
  final double? supplyTemperature;

  /// Индикатор угарного газа CO
  final int? coIndicator;

  /// Свободное охлаждение рекуператора (Вкл/Выкл)
  final bool freeCooling;

  /// Мощность работы нагревателя (%) - из JSON поля "power"
  final int? heaterPower;

  /// Статус охладителя (Отсутствует/Выключен/Включен)
  final String? coolerStatus;

  /// Давление в воздуховоде (Па)
  final int? ductPressure;

  /// Фактические обороты приточного вентилятора (0-100%)
  final int? actualSupplyFan;

  /// Фактические обороты вытяжного вентилятора (0-100%)
  final int? actualExhaustFan;

  /// Текущая уставка температуры с пульта
  final double? temperatureSetpoint;

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
    double? recuperatorTemperature,
    double? indoorTemperature,
    double? supplyTemperature,
    int? coIndicator,
    bool? freeCooling,
    int? heaterPower,
    String? coolerStatus,
    int? ductPressure,
    int? actualSupplyFan,
    int? actualExhaustFan,
    double? temperatureSetpoint,
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
      recuperatorTemperature: recuperatorTemperature ?? this.recuperatorTemperature,
      indoorTemperature: indoorTemperature ?? this.indoorTemperature,
      supplyTemperature: supplyTemperature ?? this.supplyTemperature,
      coIndicator: coIndicator ?? this.coIndicator,
      freeCooling: freeCooling ?? this.freeCooling,
      heaterPower: heaterPower ?? this.heaterPower,
      coolerStatus: coolerStatus ?? this.coolerStatus,
      ductPressure: ductPressure ?? this.ductPressure,
      actualSupplyFan: actualSupplyFan ?? this.actualSupplyFan,
      actualExhaustFan: actualExhaustFan ?? this.actualExhaustFan,
      temperatureSetpoint: temperatureSetpoint ?? this.temperatureSetpoint,
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
        recuperatorTemperature,
        indoorTemperature,
        supplyTemperature,
        recuperatorTemperature,
        coIndicator,
        freeCooling,
        heaterPower,
        coolerStatus,
        ductPressure,
        actualSupplyFan,
        actualExhaustFan,
        temperatureSetpoint,
        modeSettings,
        timerSettings,
        activeAlarms,
        isScheduleEnabled,
        quickSensors,
        deviceTime,
        updatedAt,
      ];
}
