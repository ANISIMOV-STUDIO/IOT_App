import 'package:equatable/equatable.dart';

/// Настройки режима (нагрев/охлаждение)
class ModeSettings extends Equatable {
  final int heatingTemperature;
  final int coolingTemperature;

  const ModeSettings({
    required this.heatingTemperature,
    required this.coolingTemperature,
  });

  factory ModeSettings.fromJson(Map<String, dynamic> json) {
    return ModeSettings(
      heatingTemperature: json['heatingTemperature'] as int? ?? 22,
      coolingTemperature: json['coolingTemperature'] as int? ?? 24,
    );
  }

  Map<String, dynamic> toJson() => {
    'heatingTemperature': heatingTemperature,
    'coolingTemperature': coolingTemperature,
  };

  @override
  List<Object?> get props => [heatingTemperature, coolingTemperature];
}

/// Настройки таймера для дня недели
class TimerSettings extends Equatable {
  final int onHour;
  final int onMinute;
  final int offHour;
  final int offMinute;
  final bool enabled;

  const TimerSettings({
    required this.onHour,
    required this.onMinute,
    required this.offHour,
    required this.offMinute,
    this.enabled = false,
  });

  factory TimerSettings.fromJson(Map<String, dynamic> json) {
    return TimerSettings(
      onHour: json['onHour'] as int? ?? 8,
      onMinute: json['onMinute'] as int? ?? 0,
      offHour: json['offHour'] as int? ?? 22,
      offMinute: json['offMinute'] as int? ?? 0,
      enabled: json['enabled'] as bool? ?? false,
    );
  }

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
