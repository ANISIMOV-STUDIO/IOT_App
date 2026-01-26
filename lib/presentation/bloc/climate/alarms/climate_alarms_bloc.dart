/// ClimateAlarmsBloc - Alarm history and management
///
/// Responsibilities:
/// - Alarm history loading
/// - Alarm reset
/// - Active alarms update from SignalR
library;

import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';

import 'package:hvac_control/presentation/bloc/climate/alarms/climate_alarms_event.dart';
import 'package:hvac_control/presentation/bloc/climate/alarms/climate_alarms_state.dart';

export 'package:hvac_control/presentation/bloc/climate/alarms/climate_alarms_event.dart';
export 'package:hvac_control/presentation/bloc/climate/alarms/climate_alarms_state.dart';

/// BLoC for alarm management
class ClimateAlarmsBloc extends Bloc<ClimateAlarmsEvent, ClimateAlarmsState> {
  ClimateAlarmsBloc({
    required GetAlarmHistory getAlarmHistory,
    required ResetAlarm resetAlarm,
  })  : _getAlarmHistory = getAlarmHistory,
        _resetAlarm = resetAlarm,
        super(const ClimateAlarmsState()) {
    // Debug ID
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _blocId = timestamp.substring(timestamp.length - 4);
    developer.log('ClimateAlarmsBloc CREATED: blocId=$_blocId', name: 'ClimateAlarmsBloc');

    // Alarm events
    on<ClimateAlarmsHistoryRequested>(_onHistoryRequested);
    on<ClimateAlarmsHistoryLoaded>(_onHistoryLoaded);
    on<ClimateAlarmsResetRequested>(_onResetRequested);
    on<ClimateAlarmsActiveUpdated>(_onActiveUpdated);

    // Reset
    on<ClimateAlarmsReset>(_onReset);
  }

  late final String _blocId;
  final GetAlarmHistory _getAlarmHistory;
  final ResetAlarm _resetAlarm;

  /// Request to load alarm history
  Future<void> _onHistoryRequested(
    ClimateAlarmsHistoryRequested event,
    Emitter<ClimateAlarmsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final history = await _getAlarmHistory(
        GetAlarmHistoryParams(deviceId: event.deviceId),
      );
      emit(state.copyWith(
        alarmHistory: history,
        isLoading: false,
      ));
    } catch (e) {
      ApiLogger.warning('[ClimateAlarmsBloc] Failed to load alarm history', e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load alarm history',
      ));
    }
  }

  /// Alarm history loaded
  void _onHistoryLoaded(
    ClimateAlarmsHistoryLoaded event,
    Emitter<ClimateAlarmsState> emit,
  ) {
    emit(state.copyWith(alarmHistory: event.history));
  }

  /// Reset active alarms
  Future<void> _onResetRequested(
    ClimateAlarmsResetRequested event,
    Emitter<ClimateAlarmsState> emit,
  ) async {
    try {
      await _resetAlarm(event.deviceId);
      // After reset, clear local alarm list
      emit(state.copyWith(activeAlarms: const {}));
    } catch (e) {
      developer.log('Failed to reset alarms: $e', name: 'ClimateAlarmsBloc');
      emit(state.copyWith(errorMessage: 'Failed to reset alarms'));
    }
  }

  /// Active alarms updated from SignalR
  void _onActiveUpdated(
    ClimateAlarmsActiveUpdated event,
    Emitter<ClimateAlarmsState> emit,
  ) {
    emit(state.copyWith(activeAlarms: event.activeAlarms));
  }

  /// Reset state (on device change)
  void _onReset(
    ClimateAlarmsReset event,
    Emitter<ClimateAlarmsState> emit,
  ) {
    emit(const ClimateAlarmsState());
  }

  @override
  Future<void> close() async {
    developer.log('ClimateAlarmsBloc CLOSED: blocId=$_blocId', name: 'ClimateAlarmsBloc');
    return super.close();
  }
}
