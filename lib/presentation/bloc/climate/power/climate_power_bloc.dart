/// ClimatePowerBloc - Power and schedule toggle management
///
/// Responsibilities:
/// - Power toggle with pending/timeout
/// - Schedule toggle with pending/timeout
/// - SignalR confirmation handling
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_shared.dart';

import 'package:hvac_control/presentation/bloc/climate/power/climate_power_event.dart';
import 'package:hvac_control/presentation/bloc/climate/power/climate_power_state.dart';

export 'package:hvac_control/presentation/bloc/climate/power/climate_power_event.dart';
export 'package:hvac_control/presentation/bloc/climate/power/climate_power_state.dart';

/// BLoC for power and schedule control
class ClimatePowerBloc extends Bloc<ClimatePowerEvent, ClimatePowerState> {
  ClimatePowerBloc({
    required SetDevicePower setDevicePower,
    required SetScheduleEnabled setScheduleEnabled,
  })  : _setDevicePower = setDevicePower,
        _setScheduleEnabled = setScheduleEnabled,
        super(const ClimatePowerState()) {
    // Debug ID
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _blocId = timestamp.substring(timestamp.length - 4);
    developer.log('ClimatePowerBloc CREATED: blocId=$_blocId', name: 'ClimatePowerBloc');

    // Power events
    on<ClimatePowerToggleRequested>(_onPowerToggleRequested);
    on<ClimatePowerToggleTimeout>(_onPowerToggleTimeout);

    // Schedule events
    on<ClimatePowerScheduleToggleRequested>(_onScheduleToggleRequested);
    on<ClimatePowerScheduleToggleTimeout>(_onScheduleToggleTimeout);

    // SignalR confirmation
    on<ClimatePowerSignalRReceived>(_onSignalRReceived);

    // Reset
    on<ClimatePowerReset>(_onReset);
  }

  late final String _blocId;
  final SetDevicePower _setDevicePower;
  final SetScheduleEnabled _setScheduleEnabled;

  Timer? _powerToggleTimer;
  Timer? _scheduleToggleTimer;

  /// Power toggle
  ///
  /// Loader remains until SignalR confirmation (pendingPowerState)
  Future<void> _onPowerToggleRequested(
    ClimatePowerToggleRequested event,
    Emitter<ClimatePowerState> emit,
  ) async {
    // Block button and prevent double clicks
    if (state.isTogglingPower) {
      return;
    }

    developer.log('_onPowerToggleRequested called: isOn=${event.isOn}', name: 'ClimatePowerBloc');

    // Set pending state, loader stays until SignalR confirms
    emit(state.copyWith(
      isTogglingPower: true,
      pendingPowerState: event.isOn,
    ));

    try {
      await _setDevicePower(SetDevicePowerParams(isOn: event.isOn));
      developer.log('_onPowerToggleRequested: command sent, waiting for SignalR confirmation', name: 'ClimatePowerBloc');

      // Timeout in case SignalR doesn't send confirmation
      _powerToggleTimer?.cancel();
      _powerToggleTimer = Timer(kPowerToggleTimeout, () {
        if (!isClosed && state.isTogglingPower) {
          add(const ClimatePowerToggleTimeout());
        }
      });
    } catch (e, stackTrace) {
      developer.log(
        '_onPowerToggleRequested ERROR: $e',
        name: 'ClimatePowerBloc',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(
        isTogglingPower: false,
        clearPendingPower: true,
        errorMessage: 'Power toggle error: $e',
      ));
    }
  }

  /// Power toggle timeout
  void _onPowerToggleTimeout(
    ClimatePowerToggleTimeout event,
    Emitter<ClimatePowerState> emit,
  ) {
    developer.log(
      '_onPowerToggleTimeout: timeout waiting for SignalR confirmation',
      name: 'ClimatePowerBloc',
    );
    emit(state.copyWith(
      isTogglingPower: false,
      clearPendingPower: true,
      errorMessage: 'syncTimeout',
    ));
  }

  /// Schedule toggle
  ///
  /// Loader remains until SignalR confirmation (pendingScheduleState)
  Future<void> _onScheduleToggleRequested(
    ClimatePowerScheduleToggleRequested event,
    Emitter<ClimatePowerState> emit,
  ) async {
    // Block button - prevent double clicks
    if (state.isTogglingSchedule) {
      return;
    }

    developer.log('_onScheduleToggleRequested called: enabled=${event.enabled}', name: 'ClimatePowerBloc');

    // NO optimistic update - wait for SignalR confirmation
    emit(state.copyWith(
      isTogglingSchedule: true,
      pendingScheduleState: event.enabled,
    ));

    try {
      await _setScheduleEnabled(SetScheduleEnabledParams(
        deviceId: event.deviceId,
        enabled: event.enabled,
      ));
      developer.log('_onScheduleToggleRequested: command sent, waiting for SignalR confirmation', name: 'ClimatePowerBloc');

      // Timeout in case SignalR doesn't send confirmation
      _scheduleToggleTimer?.cancel();
      _scheduleToggleTimer = Timer(kPowerToggleTimeout, () {
        if (!isClosed && state.isTogglingSchedule) {
          add(const ClimatePowerScheduleToggleTimeout());
        }
      });
    } catch (e, stackTrace) {
      developer.log(
        '_onScheduleToggleRequested ERROR: $e',
        name: 'ClimatePowerBloc',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(
        isTogglingSchedule: false,
        clearPendingSchedule: true,
        errorMessage: 'Schedule toggle error: $e',
      ));
    }
  }

  /// Schedule toggle timeout
  void _onScheduleToggleTimeout(
    ClimatePowerScheduleToggleTimeout event,
    Emitter<ClimatePowerState> emit,
  ) {
    developer.log(
      '_onScheduleToggleTimeout: timeout waiting for SignalR confirmation',
      name: 'ClimatePowerBloc',
    );
    emit(state.copyWith(
      isTogglingSchedule: false,
      clearPendingSchedule: true,
      errorMessage: 'syncTimeout',
    ));
  }

  /// SignalR confirmation received
  void _onSignalRReceived(
    ClimatePowerSignalRReceived event,
    Emitter<ClimatePowerState> emit,
  ) {
    // Check if expected power state is confirmed
    final pendingPower = state.pendingPowerState;
    final powerConfirmed = pendingPower == null || event.power == pendingPower;

    if (powerConfirmed && pendingPower != null) {
      developer.log(
        'Power state confirmed by SignalR: power=${event.power}',
        name: 'ClimatePowerBloc',
      );
      _powerToggleTimer?.cancel();
      _powerToggleTimer = null;
    }

    // Check if expected schedule state is confirmed
    final pendingSchedule = state.pendingScheduleState;
    final scheduleConfirmed = pendingSchedule == null || event.isScheduleEnabled == pendingSchedule;

    if (scheduleConfirmed && pendingSchedule != null) {
      developer.log(
        'Schedule state confirmed by SignalR: isScheduleEnabled=${event.isScheduleEnabled}',
        name: 'ClimatePowerBloc',
      );
      _scheduleToggleTimer?.cancel();
      _scheduleToggleTimer = null;
    }

    emit(state.copyWith(
      // Reset loader only if power confirmed
      isTogglingPower: !powerConfirmed && state.isTogglingPower,
      clearPendingPower: powerConfirmed,
      // Reset loader only if schedule confirmed
      isTogglingSchedule: !scheduleConfirmed && state.isTogglingSchedule,
      clearPendingSchedule: scheduleConfirmed,
    ));
  }

  /// Reset state (on device change)
  void _onReset(
    ClimatePowerReset event,
    Emitter<ClimatePowerState> emit,
  ) {
    _powerToggleTimer?.cancel();
    _powerToggleTimer = null;
    _scheduleToggleTimer?.cancel();
    _scheduleToggleTimer = null;

    emit(const ClimatePowerState());
  }

  @override
  Future<void> close() async {
    developer.log('ClimatePowerBloc CLOSED: blocId=$_blocId', name: 'ClimatePowerBloc');

    _powerToggleTimer?.cancel();
    _scheduleToggleTimer?.cancel();

    return super.close();
  }
}
