part of 'climate_bloc.dart';

/// Статус загрузки ClimateBloc
enum ClimateControlStatus {
  /// Начальное состояние
  initial,

  /// Загрузка состояния климата
  loading,

  /// Успешная загрузка
  success,

  /// Ошибка загрузки
  failure,
}

/// Состояние управления климатом
final class ClimateControlState extends Equatable {

  const ClimateControlState({
    this.status = ClimateControlStatus.initial,
    this.climate,
    this.deviceFullState,
    this.alarmHistory = const [],
    this.errorMessage,
    this.isTogglingPower = false,
    this.pendingPowerState,
    this.isTogglingSchedule = false,
    this.pendingScheduleState,
    this.isSyncing = false,
    this.isPendingHeatingTemperature = false,
    this.isPendingCoolingTemperature = false,
    this.isPendingSupplyFan = false,
    this.isPendingExhaustFan = false,
    this.pendingHeatingTemp,
    this.pendingCoolingTemp,
    this.pendingSupplyFan,
    this.pendingExhaustFan,
    this.isPendingOperatingMode = false,
    this.pendingOperatingMode,
  });
  /// Статус загрузки
  final ClimateControlStatus status;

  /// Текущее состояние климата
  final ClimateState? climate;

  /// Полное состояние устройства (с авариями)
  final DeviceFullState? deviceFullState;

  /// История аварий
  final List<AlarmHistory> alarmHistory;

  /// Сообщение об ошибке
  final String? errorMessage;

  /// Флаг переключения питания (для блокировки кнопки)
  final bool isTogglingPower;

  /// Ожидаемое состояние питания (null = нет ожидания)
  /// Используется для удержания лоадера пока SignalR не подтвердит
  final bool? pendingPowerState;

  /// Флаг переключения расписания (для блокировки кнопки)
  final bool isTogglingSchedule;

  /// Ожидаемое состояние расписания (null = нет ожидания)
  /// Используется для удержания лоадера пока SignalR не подтвердит
  final bool? pendingScheduleState;

  /// Флаг синхронизации данных (для анимации иконки)
  final bool isSyncing;

  /// Ожидание подтверждения изменения температуры нагрева
  final bool isPendingHeatingTemperature;

  /// Ожидание подтверждения изменения температуры охлаждения
  final bool isPendingCoolingTemperature;

  /// Ожидание подтверждения изменения приточного вентилятора
  final bool isPendingSupplyFan;

  /// Ожидание подтверждения изменения вытяжного вентилятора
  final bool isPendingExhaustFan;

  /// Ожидаемое значение температуры нагрева (null = нет ожидания)
  final int? pendingHeatingTemp;

  /// Ожидаемое значение температуры охлаждения (null = нет ожидания)
  final int? pendingCoolingTemp;

  /// Ожидаемое значение приточного вентилятора (null = нет ожидания)
  final int? pendingSupplyFan;

  /// Ожидаемое значение вытяжного вентилятора (null = нет ожидания)
  final int? pendingExhaustFan;

  /// Ожидание подтверждения смены режима работы
  final bool isPendingOperatingMode;

  /// Ожидаемый режим работы (null = нет ожидания)
  final String? pendingOperatingMode;

  // ============================================
  // ГЕТТЕРЫ ДЛЯ УДОБСТВА
  // ============================================

  /// Устройство включено
  bool get isOn => climate?.isOn ?? false;

  /// Текущая температура
  double? get currentTemperature => climate?.currentTemperature;

  /// Целевая температура
  double? get targetTemperature => climate?.targetTemperature;

  /// Влажность
  double? get humidity => climate?.humidity;

  /// Целевая влажность
  double? get targetHumidity => climate?.targetHumidity;

  /// Текущий режим
  ClimateMode? get mode => climate?.mode;

  /// Текущий пресет
  String? get preset => climate?.preset;

  /// Приток воздуха
  double? get supplyAirflow => climate?.supplyAirflow;

  /// Вытяжка воздуха
  double? get exhaustAirflow => climate?.exhaustAirflow;

  /// Качество воздуха
  AirQualityLevel? get airQuality => climate?.airQuality;

  /// Уровень CO2
  int? get co2Ppm => climate?.co2Ppm;

  /// Уровень загрязнений
  int? get pollutantsAqi => climate?.pollutantsAqi;

  /// Есть ли активные аварии
  bool get hasAlarms => deviceFullState?.hasAlarms ?? false;

  /// Количество активных аварий
  int get alarmCount => deviceFullState?.alarmCount ?? 0;

  /// Активные аварии
  Map<String, AlarmInfo> get activeAlarms =>
      deviceFullState?.activeAlarms ?? {};

  /// Включено ли расписание
  bool get isScheduleEnabled => deviceFullState?.isScheduleEnabled ?? false;

  /// Устройство онлайн
  bool get isOnline => deviceFullState?.isOnline ?? false;

  ClimateControlState copyWith({
    ClimateControlStatus? status,
    ClimateState? climate,
    DeviceFullState? deviceFullState,
    List<AlarmHistory>? alarmHistory,
    String? errorMessage,
    bool? isTogglingPower,
    bool? pendingPowerState,
    bool clearPendingPower = false,
    bool? isTogglingSchedule,
    bool? pendingScheduleState,
    bool clearPendingSchedule = false,
    bool? isSyncing,
    bool? isPendingHeatingTemperature,
    bool? isPendingCoolingTemperature,
    bool? isPendingSupplyFan,
    bool? isPendingExhaustFan,
    int? pendingHeatingTemp,
    bool clearPendingHeatingTemp = false,
    int? pendingCoolingTemp,
    bool clearPendingCoolingTemp = false,
    int? pendingSupplyFanValue,
    bool clearPendingSupplyFan = false,
    int? pendingExhaustFanValue,
    bool clearPendingExhaustFan = false,
    bool? isPendingOperatingMode,
    String? pendingOperatingMode,
    bool clearPendingOperatingMode = false,
  }) => ClimateControlState(
      status: status ?? this.status,
      climate: climate ?? this.climate,
      deviceFullState: deviceFullState ?? this.deviceFullState,
      alarmHistory: alarmHistory ?? this.alarmHistory,
      errorMessage: errorMessage,
      isTogglingPower: isTogglingPower ?? this.isTogglingPower,
      pendingPowerState: clearPendingPower ? null : (pendingPowerState ?? this.pendingPowerState),
      isTogglingSchedule: isTogglingSchedule ?? this.isTogglingSchedule,
      pendingScheduleState: clearPendingSchedule ? null : (pendingScheduleState ?? this.pendingScheduleState),
      isSyncing: isSyncing ?? this.isSyncing,
      isPendingHeatingTemperature:
          isPendingHeatingTemperature ?? this.isPendingHeatingTemperature,
      isPendingCoolingTemperature:
          isPendingCoolingTemperature ?? this.isPendingCoolingTemperature,
      isPendingSupplyFan: isPendingSupplyFan ?? this.isPendingSupplyFan,
      isPendingExhaustFan: isPendingExhaustFan ?? this.isPendingExhaustFan,
      pendingHeatingTemp: clearPendingHeatingTemp ? null : (pendingHeatingTemp ?? this.pendingHeatingTemp),
      pendingCoolingTemp: clearPendingCoolingTemp ? null : (pendingCoolingTemp ?? this.pendingCoolingTemp),
      pendingSupplyFan: clearPendingSupplyFan ? null : (pendingSupplyFanValue ?? pendingSupplyFan),
      pendingExhaustFan: clearPendingExhaustFan ? null : (pendingExhaustFanValue ?? pendingExhaustFan),
      isPendingOperatingMode: isPendingOperatingMode ?? this.isPendingOperatingMode,
      pendingOperatingMode: clearPendingOperatingMode ? null : (pendingOperatingMode ?? this.pendingOperatingMode),
    );

  @override
  List<Object?> get props => [
        status,
        climate,
        deviceFullState,
        alarmHistory,
        errorMessage,
        isTogglingPower,
        pendingPowerState,
        isTogglingSchedule,
        pendingScheduleState,
        isSyncing,
        isPendingHeatingTemperature,
        isPendingCoolingTemperature,
        isPendingSupplyFan,
        isPendingExhaustFan,
        pendingHeatingTemp,
        pendingCoolingTemp,
        pendingSupplyFan,
        pendingExhaustFan,
        isPendingOperatingMode,
        pendingOperatingMode,
      ];
}
