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

// HVAC Device events
class HvacDeviceSelected extends DashboardEvent {
  final String deviceId;
  const HvacDeviceSelected(this.deviceId);
  @override
  List<Object?> get props => [deviceId];
}

class HvacDevicesUpdated extends DashboardEvent {
  final List<HvacDevice> devices;
  const HvacDevicesUpdated(this.devices);
  @override
  List<Object?> get props => [devices];
}

// Schedule events
class ScheduleLoaded extends DashboardEvent {
  final List<ScheduleEntry> schedule;
  const ScheduleLoaded(this.schedule);
  @override
  List<Object?> get props => [schedule];
}

class ScheduleEntryToggled extends DashboardEvent {
  final String entryId;
  final bool isActive;
  const ScheduleEntryToggled(this.entryId, this.isActive);
  @override
  List<Object?> get props => [entryId, isActive];
}

// Notification events
class NotificationsLoaded extends DashboardEvent {
  final List<UnitNotification> notifications;
  const NotificationsLoaded(this.notifications);
  @override
  List<Object?> get props => [notifications];
}

class NotificationRead extends DashboardEvent {
  final String notificationId;
  const NotificationRead(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}

class NotificationDismissed extends DashboardEvent {
  final String notificationId;
  const NotificationDismissed(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}

// Graph events
class GraphDataLoaded extends DashboardEvent {
  final List<GraphDataPoint> data;
  const GraphDataLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class GraphMetricChanged extends DashboardEvent {
  final GraphMetric metric;
  const GraphMetricChanged(this.metric);
  @override
  List<Object?> get props => [metric];
}

// Connectivity events
class ConnectivityChanged extends DashboardEvent {
  final bool isOffline;
  const ConnectivityChanged(this.isOffline);
  @override
  List<Object?> get props => [isOffline];
}

// Device full state events (аварии, настройки режимов, таймер)
class DeviceFullStateLoaded extends DashboardEvent {
  final DeviceFullState deviceFullState;
  const DeviceFullStateLoaded(this.deviceFullState);
  @override
  List<Object?> get props => [deviceFullState];
}

class AlarmHistoryLoaded extends DashboardEvent {
  final List<AlarmHistory> alarmHistory;
  const AlarmHistoryLoaded(this.alarmHistory);
  @override
  List<Object?> get props => [alarmHistory];
}

class LoadAlarmHistory extends DashboardEvent {
  final String deviceId;
  const LoadAlarmHistory(this.deviceId);
  @override
  List<Object?> get props => [deviceId];
}

// Device registration events
class RegisterDeviceRequested extends DashboardEvent {
  final String macAddress;
  final String name;
  const RegisterDeviceRequested(this.macAddress, this.name);
  @override
  List<Object?> get props => [macAddress, name];
}

class DeviceRegistered extends DashboardEvent {
  final HvacDevice device;
  const DeviceRegistered(this.device);
  @override
  List<Object?> get props => [device];
}

class DeviceRegistrationFailed extends DashboardEvent {
  final String error;
  const DeviceRegistrationFailed(this.error);
  @override
  List<Object?> get props => [error];
}

/// Очистить ошибку регистрации после показа
class ClearRegistrationError extends DashboardEvent {
  const ClearRegistrationError();
  @override
  List<Object?> get props => [];
}
