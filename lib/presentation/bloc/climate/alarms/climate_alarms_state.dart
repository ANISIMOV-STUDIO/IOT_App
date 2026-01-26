/// State for ClimateAlarmsBloc
///
/// Contains alarm history and active alarms
library;

import 'package:equatable/equatable.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';

/// Alarms control state
final class ClimateAlarmsState extends Equatable {
  const ClimateAlarmsState({
    this.alarmHistory = const [],
    this.activeAlarms = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  /// Alarm history records
  final List<AlarmHistory> alarmHistory;

  /// Active alarms map
  final Map<String, AlarmInfo> activeAlarms;

  /// Loading indicator
  final bool isLoading;

  /// Error message
  final String? errorMessage;

  /// Has active alarms
  bool get hasAlarms => activeAlarms.isNotEmpty;

  /// Active alarm count
  int get alarmCount => activeAlarms.length;

  ClimateAlarmsState copyWith({
    List<AlarmHistory>? alarmHistory,
    Map<String, AlarmInfo>? activeAlarms,
    bool? isLoading,
    String? errorMessage,
  }) => ClimateAlarmsState(
      alarmHistory: alarmHistory ?? this.alarmHistory,
      activeAlarms: activeAlarms ?? this.activeAlarms,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );

  @override
  List<Object?> get props => [
        alarmHistory,
        activeAlarms,
        isLoading,
        errorMessage,
      ];
}
