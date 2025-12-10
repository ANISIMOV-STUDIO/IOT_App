/// HVAC List BLoC - Clean Architecture Version
///
/// Refactored to follow clean architecture principles
/// Uses domain use cases instead of direct API/repository access
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/usecases/get_all_units.dart';
import '../../../domain/usecases/device/add_device.dart';
import '../../../domain/usecases/device/remove_device.dart';
import '../../../domain/usecases/device/connect_to_devices.dart';
import 'hvac_list_event.dart';
import 'hvac_list_state.dart';

/// HVAC List BLoC
///
/// Manages the list of HVAC units using clean architecture principles
/// All business logic is delegated to use cases
class HvacListBloc extends Bloc<HvacListEvent, HvacListState> {
  final GetAllUnits _getAllUnits;
  final AddDevice _addDevice;
  final RemoveDevice _removeDevice;
  final ConnectToDevices _connectToDevices;

  StreamSubscription<List<HvacUnit>>? _unitsSubscription;

  HvacListBloc({
    required GetAllUnits getAllUnits,
    required AddDevice addDevice,
    required RemoveDevice removeDevice,
    required ConnectToDevices connectToDevices,
  })  : _getAllUnits = getAllUnits,
        _addDevice = addDevice,
        _removeDevice = removeDevice,
        _connectToDevices = connectToDevices,
        super(const HvacListInitial()) {
    on<LoadHvacUnitsEvent>(_onLoadHvacUnits);
    on<RefreshHvacUnitsEvent>(_onRefreshHvacUnits);
    on<RetryConnectionEvent>(_onRetryConnection);
    on<AddDeviceEvent>(_onAddDevice);
    on<RemoveDeviceEvent>(_onRemoveDevice);
  }

  /// Handle load HVAC units event
  Future<void> _onLoadHvacUnits(
    LoadHvacUnitsEvent event,
    Emitter<HvacListState> emit,
  ) async {
    emit(const HvacListLoading());

    try {
      // Cancel existing subscription if any
      await _unitsSubscription?.cancel();

      // Subscribe to units stream for real-time updates
      _unitsSubscription = _getAllUnits().listen(
        (units) {
          if (!isClosed) {
            add(const RefreshHvacUnitsEvent());
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(HvacListError(_formatError(error)));
          }
        },
      );

      // Get initial data
      final stream = _getAllUnits();
      await for (final units in stream) {
        if (!isClosed) {
          if (units.isEmpty) {
            emit(const HvacListEmpty());
          } else {
            emit(HvacListLoaded(units));
          }
        }
        break; // Get first emit then rely on subscription for updates
      }
    } catch (e) {
      emit(HvacListError(_formatError(e)));
    }
  }

  /// Handle refresh HVAC units event
  Future<void> _onRefreshHvacUnits(
    RefreshHvacUnitsEvent event,
    Emitter<HvacListState> emit,
  ) async {
    // Don't show loading state on refresh to avoid UI flicker
    try {
      final stream = _getAllUnits();
      await for (final units in stream) {
        if (!isClosed) {
          if (units.isEmpty) {
            emit(const HvacListEmpty());
          } else {
            emit(HvacListLoaded(units));
          }
        }
        break;
      }
    } catch (e) {
      // Don't emit error on refresh failure if we have cached data
      if (state is! HvacListLoaded) {
        emit(HvacListError(_formatError(e)));
      }
    }
  }

  /// Handle retry connection event
  Future<void> _onRetryConnection(
    RetryConnectionEvent event,
    Emitter<HvacListState> emit,
  ) async {
    emit(const HvacListLoading());

    try {
      // Use connect to devices use case
      final connected = await _connectToDevices();

      if (connected) {
        // Reload units after successful connection
        add(const LoadHvacUnitsEvent());
      } else {
        emit(const HvacListError('Failed to connect to device server'));
      }
    } catch (e) {
      emit(HvacListError(_formatError(e)));
    }
  }

  /// Handle add device event
  Future<void> _onAddDevice(
    AddDeviceEvent event,
    Emitter<HvacListState> emit,
  ) async {
    // Store current state to restore on error
    final previousState = state;

    try {
      // Show loading overlay while adding device
      if (state is HvacListLoaded) {
        emit(HvacListLoaded(
          (state as HvacListLoaded).units,
          isProcessing: true,
        ));
      }

      final params = AddDeviceParams(
        macAddress: event.macAddress,
        name: event.name,
        location: event.location,
        pairingCode: event.pairingCode,
      );

      await _addDevice(params);

      // Refresh the list to get updated data with proper HvacUnit type
      add(const RefreshHvacUnitsEvent());

      // Show success message (handled by UI layer)
    } catch (e) {
      // Restore previous state
      if (previousState is HvacListLoaded) {
        emit(previousState);
      }

      // Show error
      emit(HvacListError(_formatError(e)));

      // Return to previous state after showing error
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed && previousState is HvacListLoaded) {
        emit(previousState);
      }
    }
  }

  /// Handle remove device event
  Future<void> _onRemoveDevice(
    RemoveDeviceEvent event,
    Emitter<HvacListState> emit,
  ) async {
    // Store current state to restore on error
    final previousState = state;

    try {
      // Show loading overlay while removing device
      if (state is HvacListLoaded) {
        emit(HvacListLoaded(
          (state as HvacListLoaded).units,
          isProcessing: true,
        ));
      }

      final params = RemoveDeviceParams(
        deviceId: event.deviceId,
        factoryReset: event.factoryReset ?? false,
      );

      await _removeDevice(params);

      // Update list by removing device
      if (previousState is HvacListLoaded) {
        final updatedUnits = previousState.units
            .where((unit) => unit.id != event.deviceId)
            .toList();

        if (updatedUnits.isEmpty) {
          emit(const HvacListEmpty());
        } else {
          emit(HvacListLoaded(updatedUnits));
        }
      } else {
        // Refresh the entire list
        add(const RefreshHvacUnitsEvent());
      }

      // Show success message (handled by UI layer)
    } catch (e) {
      // Restore previous state
      if (previousState is HvacListLoaded) {
        emit(previousState);
      }

      // Show error
      emit(HvacListError(_formatError(e)));

      // Return to previous state after showing error
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed && previousState is HvacListLoaded) {
        emit(previousState);
      }
    }
  }

  /// Format error messages for display
  String _formatError(dynamic error) {
    String message = error.toString();

    // Remove exception prefix if present
    message = message.replaceAll('Exception: ', '');

    // Add default message for common errors
    if (message.contains('SocketException')) {
      return 'Network connection failed. Please check your internet connection.';
    } else if (message.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }

    // Capitalize first letter
    if (message.isNotEmpty) {
      message = message[0].toUpperCase() + message.substring(1);
    }

    return message;
  }

  @override
  Future<void> close() {
    _unitsSubscription?.cancel();
    return super.close();
  }
}

/// Extended state for loaded with processing flag
class HvacListLoaded extends HvacListState {
  final List<HvacUnit> units;
  final bool isProcessing;

  const HvacListLoaded(
    this.units, {
    this.isProcessing = false,
  });

  @override
  List<Object?> get props => [units, isProcessing];
}

/// Empty state when no devices are found
class HvacListEmpty extends HvacListState {
  const HvacListEmpty();
}
