/// HVAC List BLoC
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_all_units.dart';
import 'hvac_list_event.dart';
import 'hvac_list_state.dart';

class HvacListBloc extends Bloc<HvacListEvent, HvacListState> {
  final GetAllUnits getAllUnits;
  StreamSubscription? _unitsSubscription;

  HvacListBloc({
    required this.getAllUnits,
  }) : super(const HvacListInitial()) {
    on<LoadHvacUnitsEvent>(_onLoadHvacUnits);
    on<RefreshHvacUnitsEvent>(_onRefreshHvacUnits);
  }

  Future<void> _onLoadHvacUnits(
    LoadHvacUnitsEvent event,
    Emitter<HvacListState> emit,
  ) async {
    emit(const HvacListLoading());

    try {
      await _unitsSubscription?.cancel();
      _unitsSubscription = getAllUnits().listen(
        (units) {
          if (!isClosed) {
            add(const RefreshHvacUnitsEvent());
          }
        },
      );

      // Get initial data
      final stream = getAllUnits();
      await for (final units in stream) {
        if (!isClosed) {
          emit(HvacListLoaded(units));
        }
        break; // Get first emit then rely on subscription
      }
    } catch (e) {
      emit(HvacListError(e.toString()));
    }
  }

  Future<void> _onRefreshHvacUnits(
    RefreshHvacUnitsEvent event,
    Emitter<HvacListState> emit,
  ) async {
    try {
      final stream = getAllUnits();
      await for (final units in stream) {
        if (!isClosed) {
          emit(HvacListLoaded(units));
        }
        break;
      }
    } catch (e) {
      emit(HvacListError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _unitsSubscription?.cancel();
    return super.close();
  }
}
