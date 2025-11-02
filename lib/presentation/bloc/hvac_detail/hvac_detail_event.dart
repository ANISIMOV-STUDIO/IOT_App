/// HVAC Detail Events
library;

import 'package:equatable/equatable.dart';

abstract class HvacDetailEvent extends Equatable {
  const HvacDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load unit details
class LoadUnitDetailEvent extends HvacDetailEvent {
  const LoadUnitDetailEvent();
}

/// Update power
class UpdatePowerEvent extends HvacDetailEvent {
  final bool power;

  const UpdatePowerEvent(this.power);

  @override
  List<Object?> get props => [power];
}

/// Update target temperature
class UpdateTargetTempEvent extends HvacDetailEvent {
  final double targetTemp;

  const UpdateTargetTempEvent(this.targetTemp);

  @override
  List<Object?> get props => [targetTemp];
}

/// Update mode
class UpdateModeEvent extends HvacDetailEvent {
  final String mode;

  const UpdateModeEvent(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Update fan speed
class UpdateFanSpeedEvent extends HvacDetailEvent {
  final String fanSpeed;

  const UpdateFanSpeedEvent(this.fanSpeed);

  @override
  List<Object?> get props => [fanSpeed];
}

/// Load temperature history
class LoadTemperatureHistoryEvent extends HvacDetailEvent {
  const LoadTemperatureHistoryEvent();
}

/// Update ventilation mode
class UpdateVentilationModeEvent extends HvacDetailEvent {
  final String mode; // VentilationMode enum name

  const UpdateVentilationModeEvent(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Update supply fan speed
class UpdateSupplyFanSpeedEvent extends HvacDetailEvent {
  final int speed; // 0-100%

  const UpdateSupplyFanSpeedEvent(this.speed);

  @override
  List<Object?> get props => [speed];
}

/// Update exhaust fan speed
class UpdateExhaustFanSpeedEvent extends HvacDetailEvent {
  final int speed; // 0-100%

  const UpdateExhaustFanSpeedEvent(this.speed);

  @override
  List<Object?> get props => [speed];
}

/// Update day schedule
class UpdateDayScheduleEvent extends HvacDetailEvent {
  final int dayOfWeek; // 1=Monday, 7=Sunday
  final String? turnOnTime; // HH:MM format
  final String? turnOffTime; // HH:MM format
  final bool timerEnabled;

  const UpdateDayScheduleEvent({
    required this.dayOfWeek,
    this.turnOnTime,
    this.turnOffTime,
    required this.timerEnabled,
  });

  @override
  List<Object?> get props => [dayOfWeek, turnOnTime, turnOffTime, timerEnabled];
}
