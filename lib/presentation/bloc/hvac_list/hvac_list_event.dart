/// HVAC List Events
library;

import 'package:equatable/equatable.dart';
import '../../../../domain/entities/week_schedule.dart';

abstract class HvacListEvent extends Equatable {
  const HvacListEvent();

  @override
  List<Object?> get props => [];
}

/// Update device schedule
class UpdateDeviceScheduleEvent extends HvacListEvent {
  final String deviceId;
  final WeekSchedule schedule;

  const UpdateDeviceScheduleEvent({
    required this.deviceId,
    required this.schedule,
  });

  @override
  List<Object?> get props => [deviceId, schedule];
}

/// Load all HVAC units
class LoadHvacUnitsEvent extends HvacListEvent {
  const LoadHvacUnitsEvent();
}

/// Refresh HVAC units
class RefreshHvacUnitsEvent extends HvacListEvent {
  const RefreshHvacUnitsEvent();
}

/// Retry connection
class RetryConnectionEvent extends HvacListEvent {
  const RetryConnectionEvent();
}

/// Add a new device
class AddDeviceEvent extends HvacListEvent {
  final String macAddress;
  final String name;
  final String? location;
  final String? pairingCode;

  const AddDeviceEvent({
    required this.macAddress,
    required this.name,
    this.location,
    this.pairingCode,
  });

  @override
  List<Object?> get props => [macAddress, name, location, pairingCode];
}

/// Remove a device
class RemoveDeviceEvent extends HvacListEvent {
  final String deviceId;
  final bool? factoryReset;

  const RemoveDeviceEvent({
    required this.deviceId,
    this.factoryReset,
  });

  @override
  List<Object?> get props => [deviceId, factoryReset];
}

/// Update device power state
class UpdateDevicePowerEvent extends HvacListEvent {
  final String deviceId;
  final bool power;

  const UpdateDevicePowerEvent({
    required this.deviceId,
    required this.power,
  });

  @override
  List<Object?> get props => [deviceId, power];
}

/// Update device mode
class UpdateDeviceModeEvent extends HvacListEvent {
  final String deviceId;
  final String mode;

  const UpdateDeviceModeEvent({
    required this.deviceId,
    required this.mode,
  });


  @override
  List<Object?> get props => [deviceId, mode];
}

/// Update specific fan speed
class UpdateDeviceFanSpeedEvent extends HvacListEvent {
  final String deviceId;
  final int speed;

  const UpdateDeviceFanSpeedEvent({
    required this.deviceId,
    required this.speed,
  });

  @override
  List<Object?> get props => [deviceId, speed];
}

/// Update target temperature
class UpdateDeviceTargetTemperatureEvent extends HvacListEvent {
  final String deviceId;
  final double temperature;

  const UpdateDeviceTargetTemperatureEvent({
    required this.deviceId,
    required this.temperature,
  });

  @override
  List<Object?> get props => [deviceId, temperature];
}
