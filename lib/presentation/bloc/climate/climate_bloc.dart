/// Climate Control BLoC — управление климатом устройства
///
/// Отвечает за:
/// - Включение/выключение устройства
/// - Управление температурой и влажностью
/// - Смену режима и пресета
/// - Настройку воздушного потока
/// - Отслеживание аварий
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/climate.dart';
import '../../../domain/entities/device_full_state.dart';
import '../../../domain/entities/alarm_info.dart';
import '../../../domain/repositories/climate_repository.dart';

part 'climate_event.dart';
part 'climate_state.dart';

/// BLoC для управления климатом текущего устройства
class ClimateBloc extends Bloc<ClimateEvent, ClimateControlState> {
  final ClimateRepository _climateRepository;

  StreamSubscription<ClimateState>? _climateSubscription;

  ClimateBloc({
    required ClimateRepository climateRepository,
  })  : _climateRepository = climateRepository,
        super(const ClimateControlState()) {
    // События жизненного цикла
    on<ClimateSubscriptionRequested>(_onSubscriptionRequested);
    on<ClimateDeviceChanged>(_onDeviceChanged);

    // Обновления из стрима
    on<ClimateStateUpdated>(_onStateUpdated);
    on<ClimateFullStateLoaded>(_onFullStateLoaded);

    // Управление устройством
    on<ClimatePowerToggled>(_onPowerToggled);
    on<ClimateTemperatureChanged>(_onTemperatureChanged);
    on<ClimateHumidityChanged>(_onHumidityChanged);
    on<ClimateModeChanged>(_onModeChanged);
    on<ClimatePresetChanged>(_onPresetChanged);
    on<ClimateSupplyAirflowChanged>(_onSupplyAirflowChanged);
    on<ClimateExhaustAirflowChanged>(_onExhaustAirflowChanged);
  }

  /// Запрос на подписку к состоянию климата
  Future<void> _onSubscriptionRequested(
    ClimateSubscriptionRequested event,
    Emitter<ClimateControlState> emit,
  ) async {
    emit(state.copyWith(status: ClimateControlStatus.loading));

    try {
      // Загружаем текущее состояние
      final climate = await _climateRepository.getCurrentState();

      emit(state.copyWith(
        status: ClimateControlStatus.success,
        climate: climate,
      ));

      // Подписываемся на обновления
      await _climateSubscription?.cancel();
      _climateSubscription = _climateRepository.watchClimate().listen(
        (climate) => add(ClimateStateUpdated(climate)),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ClimateControlStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Смена устройства — загружаем его состояние
  Future<void> _onDeviceChanged(
    ClimateDeviceChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    emit(state.copyWith(status: ClimateControlStatus.loading));

    try {
      // Загружаем состояние выбранного устройства
      final climate = await _climateRepository.getDeviceState(event.deviceId);

      // Загружаем полное состояние (с авариями)
      DeviceFullState? fullState;
      try {
        fullState = await _climateRepository.getDeviceFullState(event.deviceId);
      } catch (_) {
        // Аварии не критичны
      }

      emit(state.copyWith(
        status: ClimateControlStatus.success,
        climate: climate,
        deviceFullState: fullState,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClimateControlStatus.failure,
        errorMessage: 'Ошибка загрузки состояния: $e',
      ));
    }
  }

  /// Обновление состояния климата из стрима
  void _onStateUpdated(
    ClimateStateUpdated event,
    Emitter<ClimateControlState> emit,
  ) {
    emit(state.copyWith(climate: event.climate));
  }

  /// Загружено полное состояние устройства
  void _onFullStateLoaded(
    ClimateFullStateLoaded event,
    Emitter<ClimateControlState> emit,
  ) {
    emit(state.copyWith(deviceFullState: event.fullState));
  }

  /// Включение/выключение устройства
  Future<void> _onPowerToggled(
    ClimatePowerToggled event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _climateRepository.setPower(event.isOn);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка переключения питания: $e'));
    }
  }

  /// Изменение целевой температуры
  Future<void> _onTemperatureChanged(
    ClimateTemperatureChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _climateRepository.setTargetTemperature(event.temperature);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка установки температуры: $e'));
    }
  }

  /// Изменение целевой влажности
  Future<void> _onHumidityChanged(
    ClimateHumidityChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _climateRepository.setHumidity(event.humidity);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка установки влажности: $e'));
    }
  }

  /// Смена режима климата
  Future<void> _onModeChanged(
    ClimateModeChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _climateRepository.setMode(event.mode);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка смены режима: $e'));
    }
  }

  /// Смена пресета
  Future<void> _onPresetChanged(
    ClimatePresetChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _climateRepository.setPreset(event.preset);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка смены пресета: $e'));
    }
  }

  /// Изменение притока воздуха
  Future<void> _onSupplyAirflowChanged(
    ClimateSupplyAirflowChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _climateRepository.setSupplyAirflow(event.value);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка настройки притока: $e'));
    }
  }

  /// Изменение вытяжки воздуха
  Future<void> _onExhaustAirflowChanged(
    ClimateExhaustAirflowChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _climateRepository.setExhaustAirflow(event.value);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка настройки вытяжки: $e'));
    }
  }

  @override
  Future<void> close() {
    _climateSubscription?.cancel();
    return super.close();
  }
}
