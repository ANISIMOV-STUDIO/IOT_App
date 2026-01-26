/// State for ClimatePowerBloc
///
/// Contains power and schedule toggle state with pending flags
library;

import 'package:equatable/equatable.dart';

/// Power control state
final class ClimatePowerState extends Equatable {
  const ClimatePowerState({
    this.isTogglingPower = false,
    this.pendingPowerState,
    this.isTogglingSchedule = false,
    this.pendingScheduleState,
    this.errorMessage,
  });

  /// Power toggle in progress (button blocker)
  final bool isTogglingPower;

  /// Expected power state (null = no pending)
  /// Used to hold loader until SignalR confirms
  final bool? pendingPowerState;

  /// Schedule toggle in progress (button blocker)
  final bool isTogglingSchedule;

  /// Expected schedule state (null = no pending)
  /// Used to hold loader until SignalR confirms
  final bool? pendingScheduleState;

  /// Error message
  final String? errorMessage;

  ClimatePowerState copyWith({
    bool? isTogglingPower,
    bool? pendingPowerState,
    bool clearPendingPower = false,
    bool? isTogglingSchedule,
    bool? pendingScheduleState,
    bool clearPendingSchedule = false,
    String? errorMessage,
  }) => ClimatePowerState(
      isTogglingPower: isTogglingPower ?? this.isTogglingPower,
      pendingPowerState: clearPendingPower ? null : (pendingPowerState ?? this.pendingPowerState),
      isTogglingSchedule: isTogglingSchedule ?? this.isTogglingSchedule,
      pendingScheduleState: clearPendingSchedule ? null : (pendingScheduleState ?? this.pendingScheduleState),
      errorMessage: errorMessage,
    );

  @override
  List<Object?> get props => [
        isTogglingPower,
        pendingPowerState,
        isTogglingSchedule,
        pendingScheduleState,
        errorMessage,
      ];
}
