/// HVAC List BLoC
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/hvac_repository.dart';
import '../../../domain/usecases/get_all_units.dart';
import 'hvac_list_event.dart';
import 'hvac_list_state.dart';

class HvacListBloc extends Bloc<HvacListEvent, HvacListState> {
  final GetAllUnits getAllUnits;
  final HvacRepository repository;
  StreamSubscription? _unitsSubscription;

  HvacListBloc({
    required this.getAllUnits,
    required this.repository,
  }) : super(const HvacListInitial()) {
    on<LoadHvacUnitsEvent>(_onLoadHvacUnits);
    on<RefreshHvacUnitsEvent>(_onRefreshHvacUnits);
    on<RetryConnectionEvent>(_onRetryConnection);
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

  Future<void> _onRetryConnection(
    RetryConnectionEvent event,
    Emitter<HvacListState> emit,
  ) async {
    emit(const HvacListLoading());

    try {
      await repository.connect();
      add(const LoadHvacUnitsEvent());
    } catch (e) {
      emit(HvacListError('Connection failed: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _unitsSubscription?.cancel();
    return super.close();
  }
}
