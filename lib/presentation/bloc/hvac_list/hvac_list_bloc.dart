/// HVAC List BLoC
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import '../../../core/di/injection_container.dart';
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
    on<AddDeviceEvent>(_onAddDevice);
    on<RemoveDeviceEvent>(_onRemoveDevice);
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

  Future<void> _onAddDevice(
    AddDeviceEvent event,
    Emitter<HvacListState> emit,
  ) async {
    try {
      final apiService = sl<ApiService>();

      // Call API to add device
      await apiService.post('/devices', body: {
        'mac_address': event.macAddress,
        'name': event.name,
        'location': event.location,
      });

      // Refresh the device list
      add(const RefreshHvacUnitsEvent());
    } catch (e) {
      emit(HvacListError('Failed to add device: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveDevice(
    RemoveDeviceEvent event,
    Emitter<HvacListState> emit,
  ) async {
    try {
      final apiService = sl<ApiService>();

      // Call API to remove device
      await apiService.delete('/devices/${event.deviceId}');

      // Refresh the device list
      add(const RefreshHvacUnitsEvent());
    } catch (e) {
      emit(HvacListError('Failed to remove device: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _unitsSubscription?.cancel();
    return super.close();
  }
}
