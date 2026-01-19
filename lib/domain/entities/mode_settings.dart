import 'package:equatable/equatable.dart';

/// Настройки режима (температуры и скорости вентиляторов)
class ModeSettings extends Equatable {

  const ModeSettings({
    required this.heatingTemperature,
    required this.coolingTemperature,
    this.supplyFan = 50,
    this.exhaustFan = 50,
  });

  factory ModeSettings.fromJson(Map<String, dynamic> json) => ModeSettings(
      heatingTemperature: json['heatingTemperature'] as int? ?? 22,
      coolingTemperature: json['coolingTemperature'] as int? ?? 24,
      supplyFan: json['supplyFan'] as int? ?? 50,
      exhaustFan: json['exhaustFan'] as int? ?? 50,
    );

  /// Температура нагрева (°C)
  final int heatingTemperature;

  /// Температура охлаждения (°C)
  final int coolingTemperature;

  /// Скорость приточного вентилятора (%)
  final int supplyFan;

  /// Скорость вытяжного вентилятора (%)
  final int exhaustFan;

  Map<String, dynamic> toJson() => {
    'heatingTemperature': heatingTemperature,
    'coolingTemperature': coolingTemperature,
    'supplyFan': supplyFan,
    'exhaustFan': exhaustFan,
  };

  ModeSettings copyWith({
    int? heatingTemperature,
    int? coolingTemperature,
    int? supplyFan,
    int? exhaustFan,
  }) => ModeSettings(
      heatingTemperature: heatingTemperature ?? this.heatingTemperature,
      coolingTemperature: coolingTemperature ?? this.coolingTemperature,
      supplyFan: supplyFan ?? this.supplyFan,
      exhaustFan: exhaustFan ?? this.exhaustFan,
    );

  @override
  List<Object?> get props => [
    heatingTemperature,
    coolingTemperature,
    supplyFan,
    exhaustFan,
  ];
}

/// Настройки таймера для дня недели
class TimerSettings extends Equatable {

  const TimerSettings({
    required this.onHour,
    required this.onMinute,
    required this.offHour,
    required this.offMinute,
    this.enabled = false,
  });

  factory TimerSettings.fromJson(Map<String, dynamic> json) => TimerSettings(
      onHour: json['onHour'] as int? ?? 8,
      onMinute: json['onMinute'] as int? ?? 0,
      offHour: json['offHour'] as int? ?? 22,
      offMinute: json['offMinute'] as int? ?? 0,
      enabled: json['enabled'] as bool? ?? false,
    );
  final int onHour;
  final int onMinute;
  final int offHour;
  final int offMinute;
  final bool enabled;

  Map<String, dynamic> toJson() => {
    'onHour': onHour,
    'onMinute': onMinute,
    'offHour': offHour,
    'offMinute': offMinute,
    'enabled': enabled,
  };

  /// Время включения в формате HH:MM
  String get onTimeFormatted =>
      '${onHour.toString().padLeft(2, '0')}:${onMinute.toString().padLeft(2, '0')}';

  /// Время выключения в формате HH:MM
  String get offTimeFormatted =>
      '${offHour.toString().padLeft(2, '0')}:${offMinute.toString().padLeft(2, '0')}';

  @override
  List<Object?> get props => [onHour, onMinute, offHour, offMinute, enabled];
}
