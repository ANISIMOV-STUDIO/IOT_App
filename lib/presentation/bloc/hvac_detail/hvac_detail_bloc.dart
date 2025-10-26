/// HVAC Detail BLoC
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/usecases/get_unit_by_id.dart';
import '../../../domain/usecases/update_unit.dart';
import '../../../domain/usecases/get_temperature_history.dart';
import 'hvac_detail_event.dart';
import 'hvac_detail_state.dart';

class HvacDetailBloc extends Bloc<HvacDetailEvent, HvacDetailState> {
  final String unitId;
  final GetUnitById getUnitById;
  final UpdateUnit updateUnit;
  final GetTemperatureHistory getTemperatureHistory;
  StreamSubscription? _unitSubscription;

  HvacDetailBloc({
    required this.unitId,
    required this.getUnitById,
    required this.updateUnit,
    required this.getTemperatureHistory,
  }) : super(const HvacDetailInitial()) {
    on<LoadUnitDetailEvent>(_onLoadUnitDetail);
    on<UpdatePowerEvent>(_onUpdatePower);
    on<UpdateTargetTempEvent>(_onUpdateTargetTemp);
    on<UpdateModeEvent>(_onUpdateMode);
    on<UpdateFanSpeedEvent>(_onUpdateFanSpeed);
    on<LoadTemperatureHistoryEvent>(_onLoadTemperatureHistory);
  }

  Future<void> _onLoadUnitDetail(
    LoadUnitDetailEvent event,
    Emitter<HvacDetailState> emit,
  ) async {
    emit(const HvacDetailLoading());

    try {
      await _unitSubscription?.cancel();

      // Subscribe to unit updates
      await emit.forEach<HvacUnit>(
        getUnitById(unitId),
        onData: (unit) {
          if (state is HvacDetailLoaded) {
            final currentState = state as HvacDetailLoaded;
            return currentState.copyWith(unit: unit);
          } else {
            // First time loading - also load temperature history
            add(const LoadTemperatureHistoryEvent());
            return HvacDetailLoaded(unit: unit);
          }
        },
        onError: (error, stackTrace) => HvacDetailError(error.toString()),
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(HvacDetailError(e.toString()));
      }
    }
  }

  Future<void> _onUpdatePower(
    UpdatePowerEvent event,
    Emitter<HvacDetailState> emit,
  ) async {
    if (state is! HvacDetailLoaded) return;

    try {
      // Don't emit intermediate state - reduces rebuilds from 2 to 1
      await updateUnit(
        unitId: unitId,
        power: event.power,
      );
      // State will update via subscription in _unitSubscription
    } catch (e) {
      emit(HvacDetailError(e.toString()));
    }
  }

  Future<void> _onUpdateTargetTemp(
    UpdateTargetTempEvent event,
    Emitter<HvacDetailState> emit,
  ) async {
    if (state is! HvacDetailLoaded) return;

    try {
      // Don't emit intermediate state - reduces rebuilds
      await updateUnit(
        unitId: unitId,
        targetTemp: event.targetTemp,
      );
    } catch (e) {
      emit(HvacDetailError(e.toString()));
    }
  }

  Future<void> _onUpdateMode(
    UpdateModeEvent event,
    Emitter<HvacDetailState> emit,
  ) async {
    if (state is! HvacDetailLoaded) return;

    try {
      // Don't emit intermediate state - reduces rebuilds
      await updateUnit(
        unitId: unitId,
        mode: event.mode,
      );
    } catch (e) {
      emit(HvacDetailError(e.toString()));
    }
  }

  Future<void> _onUpdateFanSpeed(
    UpdateFanSpeedEvent event,
    Emitter<HvacDetailState> emit,
  ) async {
    if (state is! HvacDetailLoaded) return;

    try {
      // Don't emit intermediate state - reduces rebuilds
      await updateUnit(
        unitId: unitId,
        fanSpeed: event.fanSpeed,
      );
    } catch (e) {
      emit(HvacDetailError(e.toString()));
    }
  }

  Future<void> _onLoadTemperatureHistory(
    LoadTemperatureHistoryEvent event,
    Emitter<HvacDetailState> emit,
  ) async {
    if (state is! HvacDetailLoaded) return;

    try {
      final history = await getTemperatureHistory(unitId, hours: 24);

      if (!isClosed && state is HvacDetailLoaded) {
        final currentState = state as HvacDetailLoaded;
        emit(currentState.copyWith(
          history: history,
          isUpdating: false,
        ));
      }
    } catch (e) {
      // Don't emit error for history loading failure
      if (state is HvacDetailLoaded) {
        final currentState = state as HvacDetailLoaded;
        emit(currentState.copyWith(isUpdating: false));
      }
    }
  }

  @override
  Future<void> close() {
    _unitSubscription?.cancel();
    return super.close();
  }
}
