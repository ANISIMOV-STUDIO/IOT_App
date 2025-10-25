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
