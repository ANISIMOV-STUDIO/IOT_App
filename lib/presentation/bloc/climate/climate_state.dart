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
    this.pendingHeatingTemperature,
    this.pendingCoolingTemperature,
    this.pendingSupplyFan,
    this.pendingExhaustFan,
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

  /// Ожидаемое значение температуры нагрева (null = нет ожидания)
  /// Используется для сравнения с SignalR ответом
  final int? pendingHeatingTemperature;

  /// Ожидаемое значение температуры охлаждения (null = нет ожидания)
  final int? pendingCoolingTemperature;

  /// Ожидаемое значение приточного вентилятора (null = нет ожидания)
  final int? pendingSupplyFan;

  /// Ожидаемое значение вытяжного вентилятора (null = нет ожидания)
  final int? pendingExhaustFan;

  // ============================================
  // ГЕТТЕРЫ PENDING СОСТОЯНИЙ
  // ============================================

  /// Ожидание подтверждения изменения температуры нагрева
  bool get isPendingHeatingTemperature => pendingHeatingTemperature != null;

  /// Ожидание подтверждения изменения температуры охлаждения
  bool get isPendingCoolingTemperature => pendingCoolingTemperature != null;

  /// Ожидание подтверждения приточного вентилятора
  bool get isPendingSupplyFan => pendingSupplyFan != null;

  /// Ожидание подтверждения вытяжного вентилятора
  bool get isPendingExhaustFan => pendingExhaustFan != null;

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
    int? pendingHeatingTemperature,
    bool clearPendingHeatingTemperature = false,
    int? pendingCoolingTemperature,
    bool clearPendingCoolingTemperature = false,
    int? pendingSupplyFan,
    bool clearPendingSupplyFan = false,
    int? pendingExhaustFan,
    bool clearPendingExhaustFan = false,
  }) => ClimateControlState(
      status: status ?? this.status,
      climate: climate ?? this.climate,
      deviceFullState: deviceFullState ?? this.deviceFullState,
      alarmHistory: alarmHistory ?? this.alarmHistory,
      errorMessage: errorMessage,
      isTogglingPower: isTogglingPower ?? this.isTogglingPower,
      pendingPowerState: clearPendingPower ? null : (pendingPowerState ?? this.pendingPowerState),
      isTogglingSchedule: isTogglingSchedule ?? this.isTogglingSchedule,
      pendingHeatingTemperature: clearPendingHeatingTemperature
          ? null
          : (pendingHeatingTemperature ?? this.pendingHeatingTemperature),
      pendingCoolingTemperature: clearPendingCoolingTemperature
          ? null
          : (pendingCoolingTemperature ?? this.pendingCoolingTemperature),
      pendingSupplyFan: clearPendingSupplyFan
          ? null
          : (pendingSupplyFan ?? this.pendingSupplyFan),
      pendingExhaustFan: clearPendingExhaustFan
          ? null
          : (pendingExhaustFan ?? this.pendingExhaustFan),
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
        pendingHeatingTemperature,
        pendingCoolingTemperature,
        pendingSupplyFan,
        pendingExhaustFan,
      ];
}
