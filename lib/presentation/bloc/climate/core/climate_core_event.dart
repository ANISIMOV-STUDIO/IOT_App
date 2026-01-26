/// Events for ClimateCoreBloc
///
/// Handles lifecycle, SignalR updates, and sync operations
library;

import 'package:equatable/equatable.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';

/// Base event for ClimateCoreBloc
sealed class ClimateCoreEvent extends Equatable {
  const ClimateCoreEvent();

  @override
  List<Object?> get props => [];
}

// =============================================================================
// LIFECYCLE EVENTS
// =============================================================================

/// Request to subscribe to climate state (initialization)
final class ClimateCoreSubscriptionRequested extends ClimateCoreEvent {
  const ClimateCoreSubscriptionRequested();
}

/// Request to force refresh device data
final class ClimateCoreRefreshRequested extends ClimateCoreEvent {
  const ClimateCoreRefreshRequested();
}

/// Device changed - reload state
final class ClimateCoreDeviceChanged extends ClimateCoreEvent {
  const ClimateCoreDeviceChanged(this.deviceId);
  final String deviceId;

  @override
  List<Object?> get props => [deviceId];
}

// =============================================================================
// STREAM UPDATES
// =============================================================================

/// Climate state updated (from stream)
final class ClimateCoreStateUpdated extends ClimateCoreEvent {
  const ClimateCoreStateUpdated(this.climate);
  final ClimateState climate;

  @override
  List<Object?> get props => [climate];
}

/// Full device state loaded (with alarms)
final class ClimateCoreFullStateLoaded extends ClimateCoreEvent {
  const ClimateCoreFullStateLoaded(this.fullState);
  final DeviceFullState fullState;

  @override
  List<Object?> get props => [fullState];
}

// =============================================================================
// INTERNAL EVENTS
// =============================================================================

/// Sync timeout event
final class ClimateCoreSyncTimeout extends ClimateCoreEvent {
  const ClimateCoreSyncTimeout();
}

/// Quick sensors updated (local state update after successful save)
final class ClimateCoreQuickSensorsUpdated extends ClimateCoreEvent {
  const ClimateCoreQuickSensorsUpdated(this.quickSensors);
  final List<String> quickSensors;

  @override
  List<Object?> get props => [quickSensors];
}
