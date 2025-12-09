/// HVAC List BLoC
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/repositories/hvac_repository.dart';
import '../../../domain/usecases/get_all_units.dart';
import '../../../domain/entities/hvac_unit.dart';
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
    on<UpdateDevicePowerEvent>(_onUpdateDevicePower);
    on<UpdateDeviceModeEvent>(_onUpdateDeviceMode);
    on<UpdateDeviceTargetTemperatureEvent>(_onUpdateDeviceTargetTemperature);
    on<UpdateDeviceFanSpeedEvent>(_onUpdateDeviceFanSpeed);
    on<UpdateDeviceScheduleEvent>(_onUpdateDeviceSchedule);
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

  Future<void> _onUpdateDevicePower(
    UpdateDevicePowerEvent event,
    Emitter<HvacListState> emit,
  ) async {
    if (state is! HvacListLoaded) return;

    try {
      final currentState = state as HvacListLoaded;
      final unit = currentState.units.firstWhere(
        (u) => u.id == event.deviceId,
      );

      // Create updated unit with new power state
      final updatedUnit = unit.copyWith(power: event.power);

      // Update via repository
      await repository.updateUnitEntity(updatedUnit);

      // State will update automatically via stream subscription
    } catch (e) {
      emit(HvacListError('Failed to update power: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateDeviceMode(
    UpdateDeviceModeEvent event,
    Emitter<HvacListState> emit,
  ) async {
    if (state is! HvacListLoaded) return;

    try {
      final currentState = state as HvacListLoaded;
      final unit = currentState.units.firstWhere(
        (u) => u.id == event.deviceId,
      );

      // Create updated unit with new mode
      final updatedUnit = unit.copyWith(mode: event.mode);

      // Update via repository
      await repository.updateUnitEntity(updatedUnit);

      // State will update automatically via stream subscription
    } catch (e) {
      emit(HvacListError('Failed to update mode: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateDeviceTargetTemperature(
    UpdateDeviceTargetTemperatureEvent event,
    Emitter<HvacListState> emit,
  ) async {
    if (state is! HvacListLoaded) return;

    try {
      final currentState = state as HvacListLoaded;
      final unit = currentState.units.firstWhere((u) => u.id == event.deviceId);

      // Create updated unit with new temp
      // HvacUnit uses targetTemp
      final updatedUnit = unit.copyWith(targetTemp: event.temperature);

      // Update via repository
      await repository.updateUnitEntity(updatedUnit);
    } catch (e) {
      emit(HvacListError('Failed to update temperature: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateDeviceFanSpeed(
    UpdateDeviceFanSpeedEvent event,
    Emitter<HvacListState> emit,
  ) async {
    if (state is! HvacListLoaded) return;

    try {
      final currentState = state as HvacListLoaded;
      final unit = currentState.units.firstWhere((u) => u.id == event.deviceId);
      
      // Update supply/exhaust fan speed if it's a ventilation unit
      // Or map to string fanSpeed if legacy
      HvacUnit updatedUnit;
      if (unit.isVentilation) {
         updatedUnit = unit.copyWith(
           supplyFanSpeed: event.speed,
           exhaustFanSpeed: event.speed,
         );
      } else {
         // Fallback map int to string for simple ACs
         String speedStr = 'auto';
         if (event.speed < 30) speedStr = 'low';
         else if (event.speed < 70) speedStr = 'medium';
         else speedStr = 'high';
         
         updatedUnit = unit.copyWith(fanSpeed: speedStr);
      }
      
      await repository.updateUnitEntity(updatedUnit);
    } catch (e) {
      emit(HvacListError('Failed to update fan speed: ${e.toString()}'));
    }
  }
  
  Future<void> _onUpdateDeviceSchedule(
    UpdateDeviceScheduleEvent event,
    Emitter<HvacListState> emit,
  ) async {
    if (state is! HvacListLoaded) return;

    try {
      final currentState = state as HvacListLoaded;
      final unit = currentState.units.firstWhere((u) => u.id == event.deviceId);

      // Create updated unit with new schedule
      final updatedUnit = unit.copyWith(schedule: event.schedule);

      // Update via repository
      await repository.updateUnitEntity(updatedUnit);
    } catch (e) {
      emit(HvacListError('Failed to update schedule: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _unitsSubscription?.cancel();
    return super.close();
  }
}
