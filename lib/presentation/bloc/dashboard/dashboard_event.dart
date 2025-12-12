part of 'dashboard_bloc.dart';

/// События Dashboard
sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

class DashboardRefreshed extends DashboardEvent {
  const DashboardRefreshed();
}

class DeviceToggled extends DashboardEvent {
  final String deviceId;
  final bool isOn;
  const DeviceToggled(this.deviceId, this.isOn);
  @override
  List<Object?> get props => [deviceId, isOn];
}

class DevicePowerToggled extends DashboardEvent {
  final bool isOn;
  const DevicePowerToggled(this.isOn);
  @override
  List<Object?> get props => [isOn];
}

class TemperatureChanged extends DashboardEvent {
  final double temperature;
  const TemperatureChanged(this.temperature);
  @override
  List<Object?> get props => [temperature];
}

class HumidityChanged extends DashboardEvent {
  final double humidity;
  const HumidityChanged(this.humidity);
  @override
  List<Object?> get props => [humidity];
}

class ClimateModeChanged extends DashboardEvent {
  final ClimateMode mode;
  const ClimateModeChanged(this.mode);
  @override
  List<Object?> get props => [mode];
}

class SupplyAirflowChanged extends DashboardEvent {
  final double value;
  const SupplyAirflowChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ExhaustAirflowChanged extends DashboardEvent {
  final double value;
  const ExhaustAirflowChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class PresetChanged extends DashboardEvent {
  final String preset;
  const PresetChanged(this.preset);
  @override
  List<Object?> get props => [preset];
}

class AllDevicesOff extends DashboardEvent {
  const AllDevicesOff();
}

// Internal events from streams
class DevicesUpdated extends DashboardEvent {
  final List<SmartDevice> devices;
  const DevicesUpdated(this.devices);
  @override
  List<Object?> get props => [devices];
}

class ClimateUpdated extends DashboardEvent {
  final ClimateState climate;
  const ClimateUpdated(this.climate);
  @override
  List<Object?> get props => [climate];
}

class EnergyUpdated extends DashboardEvent {
  final EnergyStats stats;
  const EnergyUpdated(this.stats);
  @override
  List<Object?> get props => [stats];
}

class OccupantsUpdated extends DashboardEvent {
  final List<Occupant> occupants;
  const OccupantsUpdated(this.occupants);
  @override
  List<Object?> get props => [occupants];
}
