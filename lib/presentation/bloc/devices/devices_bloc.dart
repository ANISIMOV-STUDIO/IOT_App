/// Devices BLoC — управление списком HVAC устройств
///
/// Отвечает за:
/// - Загрузку списка устройств
/// - Выбор текущего устройства
/// - Регистрацию новых устройств
/// - Удаление и переименование устройств
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/api_exception.dart';
import '../../../domain/entities/hvac_device.dart';
import '../../../domain/repositories/climate_repository.dart';

part 'devices_event.dart';
part 'devices_state.dart';

/// BLoC для управления списком HVAC устройств
class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  final ClimateRepository _climateRepository;

  StreamSubscription<List<HvacDevice>>? _devicesSubscription;

  DevicesBloc({
    required ClimateRepository climateRepository,
  })  : _climateRepository = climateRepository,
        super(const DevicesState()) {
    // События жизненного цикла
    on<DevicesSubscriptionRequested>(_onSubscriptionRequested);

    // События выбора устройства
    on<DevicesDeviceSelected>(_onDeviceSelected);
    on<DevicesListUpdated>(_onListUpdated);

    // События управления устройствами
    on<DevicesRegistrationRequested>(_onRegistrationRequested);
    on<DevicesRegistrationErrorCleared>(_onRegistrationErrorCleared);
    on<DevicesDeletionRequested>(_onDeletionRequested);
    on<DevicesRenameRequested>(_onRenameRequested);
  }

  /// Запрос на подписку к списку устройств
  Future<void> _onSubscriptionRequested(
    DevicesSubscriptionRequested event,
    Emitter<DevicesState> emit,
  ) async {
    emit(state.copyWith(status: DevicesStatus.loading));

    try {
      // Загружаем список устройств
      final devices = await _climateRepository.getAllHvacDevices();
      final selectedId = devices.isNotEmpty ? devices.first.id : null;

      // Устанавливаем выбранное устройство в репозитории
      if (selectedId != null) {
        _climateRepository.setSelectedDevice(selectedId);
      }

      emit(state.copyWith(
        status: DevicesStatus.success,
        devices: devices,
        selectedDeviceId: selectedId,
      ));

      // Подписываемся на обновления
      await _devicesSubscription?.cancel();
      _devicesSubscription = _climateRepository.watchHvacDevices().listen(
        (devices) => add(DevicesListUpdated(devices)),
      );
    } catch (e) {
      emit(state.copyWith(
        status: DevicesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Выбор устройства
  void _onDeviceSelected(
    DevicesDeviceSelected event,
    Emitter<DevicesState> emit,
  ) {
    _climateRepository.setSelectedDevice(event.deviceId);
    emit(state.copyWith(selectedDeviceId: event.deviceId));
  }

  /// Обновление списка устройств из стрима
  void _onListUpdated(
    DevicesListUpdated event,
    Emitter<DevicesState> emit,
  ) {
    emit(state.copyWith(devices: event.devices));
  }

  /// Регистрация нового устройства
  Future<void> _onRegistrationRequested(
    DevicesRegistrationRequested event,
    Emitter<DevicesState> emit,
  ) async {
    emit(state.copyWith(isRegistering: true, registrationError: null));

    try {
      final device = await _climateRepository.registerDevice(
        event.macAddress,
        event.name,
      );

      // Обновляем список устройств и выбираем новое
      final updatedDevices = [...state.devices, device];
      emit(state.copyWith(
        isRegistering: false,
        devices: updatedDevices,
        selectedDeviceId: device.id,
      ));
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Не удалось зарегистрировать устройство';
      }
      emit(state.copyWith(
        isRegistering: false,
        registrationError: errorMessage,
      ));
    }
  }

  /// Очистка ошибки регистрации
  void _onRegistrationErrorCleared(
    DevicesRegistrationErrorCleared event,
    Emitter<DevicesState> emit,
  ) {
    emit(state.copyWith(registrationError: null));
  }

  /// Удаление устройства
  Future<void> _onDeletionRequested(
    DevicesDeletionRequested event,
    Emitter<DevicesState> emit,
  ) async {
    try {
      await _climateRepository.deleteDevice(event.deviceId);

      // Удаляем из локального списка
      final updatedDevices = state.devices
          .where((d) => d.id != event.deviceId)
          .toList();

      // Выбираем другое устройство если удалено текущее
      String? newSelectedId = state.selectedDeviceId;
      if (state.selectedDeviceId == event.deviceId) {
        newSelectedId = updatedDevices.isNotEmpty ? updatedDevices.first.id : null;
        if (newSelectedId != null) {
          _climateRepository.setSelectedDevice(newSelectedId);
        }
      }

      emit(state.copyWith(
        devices: updatedDevices,
        selectedDeviceId: newSelectedId,
      ));
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Не удалось удалить устройство';
      }
      emit(state.copyWith(registrationError: errorMessage));
    }
  }

  /// Переименование устройства
  Future<void> _onRenameRequested(
    DevicesRenameRequested event,
    Emitter<DevicesState> emit,
  ) async {
    try {
      await _climateRepository.renameDevice(event.deviceId, event.newName);

      // Обновляем имя в локальном списке
      final updatedDevices = state.devices.map((d) {
        if (d.id == event.deviceId) {
          return d.copyWith(name: event.newName);
        }
        return d;
      }).toList();

      emit(state.copyWith(devices: updatedDevices));
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Не удалось переименовать устройство';
      }
      emit(state.copyWith(registrationError: errorMessage));
    }
  }

  @override
  Future<void> close() {
    _devicesSubscription?.cancel();
    return super.close();
  }
}
