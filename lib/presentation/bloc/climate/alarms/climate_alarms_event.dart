/// Events for ClimateAlarmsBloc
///
/// Handles alarm history and active alarms
library;

import 'package:equatable/equatable.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';

/// Base event for ClimateAlarmsBloc
sealed class ClimateAlarmsEvent extends Equatable {
  const ClimateAlarmsEvent();

  @override
  List<Object?> get props => [];
}

// =============================================================================
// ALARM EVENTS
// =============================================================================

/// Request to load alarm history
final class ClimateAlarmsHistoryRequested extends ClimateAlarmsEvent {
  const ClimateAlarmsHistoryRequested(this.deviceId);
  final String deviceId;

  @override
  List<Object?> get props => [deviceId];
}

/// Alarm history loaded
final class ClimateAlarmsHistoryLoaded extends ClimateAlarmsEvent {
  const ClimateAlarmsHistoryLoaded(this.history);
  final List<AlarmHistory> history;

  @override
  List<Object?> get props => [history];
}

/// Request to reset active alarms
final class ClimateAlarmsResetRequested extends ClimateAlarmsEvent {
  const ClimateAlarmsResetRequested(this.deviceId);
  final String deviceId;

  @override
  List<Object?> get props => [deviceId];
}

/// Active alarms updated from SignalR
final class ClimateAlarmsActiveUpdated extends ClimateAlarmsEvent {
  const ClimateAlarmsActiveUpdated(this.activeAlarms);
  final Map<String, AlarmInfo> activeAlarms;

  @override
  List<Object?> get props => [activeAlarms];
}

// =============================================================================
// RESET
// =============================================================================

/// Reset alarms bloc state (on device change)
final class ClimateAlarmsReset extends ClimateAlarmsEvent {
  const ClimateAlarmsReset();
}
