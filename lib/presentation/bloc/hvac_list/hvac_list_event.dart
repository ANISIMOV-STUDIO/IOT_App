/// HVAC List Events
library;

import 'package:equatable/equatable.dart';

abstract class HvacListEvent extends Equatable {
  const HvacListEvent();

  @override
  List<Object?> get props => [];
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

  const AddDeviceEvent({
    required this.macAddress,
    required this.name,
    this.location,
  });

  @override
  List<Object?> get props => [macAddress, name, location];
}

/// Remove a device
class RemoveDeviceEvent extends HvacListEvent {
  final String deviceId;

  const RemoveDeviceEvent({required this.deviceId});

  @override
  List<Object?> get props => [deviceId];
}
