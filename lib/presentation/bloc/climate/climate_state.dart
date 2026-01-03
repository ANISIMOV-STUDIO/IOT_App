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

  const ClimateControlState({
    this.status = ClimateControlStatus.initial,
    this.climate,
    this.deviceFullState,
    this.alarmHistory = const [],
    this.errorMessage,
    this.isTogglingPower = false,
  });

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

  ClimateControlState copyWith({
    ClimateControlStatus? status,
    ClimateState? climate,
    DeviceFullState? deviceFullState,
    List<AlarmHistory>? alarmHistory,
    String? errorMessage,
    bool? isTogglingPower,
  }) {
    return ClimateControlState(
      status: status ?? this.status,
      climate: climate ?? this.climate,
      deviceFullState: deviceFullState ?? this.deviceFullState,
      alarmHistory: alarmHistory ?? this.alarmHistory,
      errorMessage: errorMessage,
      isTogglingPower: isTogglingPower ?? this.isTogglingPower,
    );
  }

  @override
  List<Object?> get props => [
        status,
        climate,
        deviceFullState,
        alarmHistory,
        errorMessage,
        isTogglingPower,
      ];
}
