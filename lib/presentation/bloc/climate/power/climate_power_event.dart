/// Events for ClimatePowerBloc
///
/// Handles power toggle and schedule toggle operations
library;

import 'package:equatable/equatable.dart';

/// Base event for ClimatePowerBloc
sealed class ClimatePowerEvent extends Equatable {
  const ClimatePowerEvent();

  @override
  List<Object?> get props => [];
}

// =============================================================================
// POWER EVENTS
// =============================================================================

/// Power toggle requested
final class ClimatePowerToggleRequested extends ClimatePowerEvent {
  const ClimatePowerToggleRequested({required this.isOn});
  final bool isOn;

  @override
  List<Object?> get props => [isOn];
}

/// Power toggle timeout
final class ClimatePowerToggleTimeout extends ClimatePowerEvent {
  const ClimatePowerToggleTimeout();
}

// =============================================================================
// SCHEDULE EVENTS
// =============================================================================

/// Schedule toggle requested
final class ClimatePowerScheduleToggleRequested extends ClimatePowerEvent {
  const ClimatePowerScheduleToggleRequested({
    required this.enabled,
    required this.deviceId,
  });
  final bool enabled;
  final String deviceId;

  @override
  List<Object?> get props => [enabled, deviceId];
}

/// Schedule toggle timeout
final class ClimatePowerScheduleToggleTimeout extends ClimatePowerEvent {
  const ClimatePowerScheduleToggleTimeout();
}

// =============================================================================
// SIGNALR CONFIRMATION
// =============================================================================

/// SignalR confirmation received for power/schedule
final class ClimatePowerSignalRReceived extends ClimatePowerEvent {
  const ClimatePowerSignalRReceived({
    required this.power,
    required this.isScheduleEnabled,
  });
  final bool power;
  final bool isScheduleEnabled;

  @override
  List<Object?> get props => [power, isScheduleEnabled];
}

// =============================================================================
// RESET
// =============================================================================

/// Reset power bloc state (on device change)
final class ClimatePowerReset extends ClimatePowerEvent {
  const ClimatePowerReset();
}
