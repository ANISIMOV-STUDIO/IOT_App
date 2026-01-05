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
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/logging/api_logger.dart';
import '../../../domain/entities/climate.dart';
import '../../../domain/entities/device_full_state.dart';
import '../../../domain/entities/alarm_info.dart';
import '../../../domain/usecases/usecases.dart';

part 'climate_event.dart';
part 'climate_state.dart';

/// BLoC для управления климатом текущего устройства
class ClimateBloc extends Bloc<ClimateEvent, ClimateControlState> {
  final GetCurrentClimateState _getCurrentClimateState;
  final GetDeviceState _getDeviceState;
  final GetDeviceFullState _getDeviceFullState;
  final WatchCurrentClimate _watchCurrentClimate;
  final SetDevicePower _setDevicePower;
  final SetTemperature _setTemperature;
  final SetHumidity _setHumidity;
  final SetClimateMode _setClimateMode;
  final SetPreset _setPreset;
  final SetAirflow _setAirflow;

  StreamSubscription<ClimateState>? _climateSubscription;

  ClimateBloc({
    required GetCurrentClimateState getCurrentClimateState,
    required GetDeviceState getDeviceState,
    required GetDeviceFullState getDeviceFullState,
    required WatchCurrentClimate watchCurrentClimate,
    required SetDevicePower setDevicePower,
    required SetTemperature setTemperature,
    required SetHumidity setHumidity,
    required SetClimateMode setClimateMode,
    required SetPreset setPreset,
    required SetAirflow setAirflow,
  })  : _getCurrentClimateState = getCurrentClimateState,
        _getDeviceState = getDeviceState,
        _getDeviceFullState = getDeviceFullState,
        _watchCurrentClimate = watchCurrentClimate,
        _setDevicePower = setDevicePower,
        _setTemperature = setTemperature,
        _setHumidity = setHumidity,
        _setClimateMode = setClimateMode,
        _setPreset = setPreset,
        _setAirflow = setAirflow,
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
    on<ClimateHeatingTempChanged>(_onHeatingTempChanged);
    on<ClimateCoolingTempChanged>(_onCoolingTempChanged);
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
      // Загружаем текущее состояние через Use Case
      final climate = await _getCurrentClimateState();

      emit(state.copyWith(
        status: ClimateControlStatus.success,
        climate: climate,
      ));

      // Подписываемся на обновления через Use Case
      await _climateSubscription?.cancel();
      _climateSubscription = _watchCurrentClimate().listen(
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
      // Загружаем состояние выбранного устройства через Use Case
      final climate = await _getDeviceState(
        GetDeviceStateParams(deviceId: event.deviceId),
      );

      // Загружаем полное состояние (с авариями)
      DeviceFullState? fullState;
      try {
        fullState = await _getDeviceFullState(
          GetDeviceFullStateParams(deviceId: event.deviceId),
        );
      } catch (e) {
        // Аварии не критичны для отображения основного UI
        ApiLogger.warning('[ClimateBloc] Не удалось загрузить аварии', e);
      }

      emit(state.copyWith(
        status: ClimateControlStatus.success,
        climate: climate,
        deviceFullState: fullState,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClimateControlStatus.failure,
        errorMessage: 'State loading error: $e',
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
    // Блокируем кнопку и делаем optimistic update
    if (state.isTogglingPower) return; // Предотвращаем двойные нажатия

    developer.log('_onPowerToggled called: isOn=${event.isOn}', name: 'ClimateBloc');

    // Optimistic update: сразу показываем новое состояние
    final optimisticClimate = state.climate?.copyWith(isOn: event.isOn);
    emit(state.copyWith(
      isTogglingPower: true,
      climate: optimisticClimate,
    ));

    try {
      await _setDevicePower(SetDevicePowerParams(isOn: event.isOn));
      developer.log('_onPowerToggled: command sent successfully', name: 'ClimateBloc');
      // Разблокируем кнопку после успешной отправки
      emit(state.copyWith(isTogglingPower: false));
    } catch (e, stackTrace) {
      developer.log(
        '_onPowerToggled ERROR: $e',
        name: 'ClimateBloc',
        error: e,
        stackTrace: stackTrace,
      );
      // Откатываем optimistic update при ошибке
      final revertedClimate = state.climate?.copyWith(isOn: !event.isOn);
      emit(state.copyWith(
        isTogglingPower: false,
        climate: revertedClimate,
        errorMessage: 'Power toggle error: $e',
      ));
    }
  }

  /// Изменение целевой температуры
  Future<void> _onTemperatureChanged(
    ClimateTemperatureChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setTemperature(SetTemperatureParams(temperature: event.temperature));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Temperature setting error: $e'));
    }
  }

  /// Изменение температуры нагрева
  Future<void> _onHeatingTempChanged(
    ClimateHeatingTempChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setTemperature(SetTemperatureParams(temperature: event.temperature.toDouble()));
      // TODO: Когда бэкенд поддержит отдельные температуры, использовать отдельный API
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Heating temperature error: $e'));
    }
  }

  /// Изменение температуры охлаждения
  Future<void> _onCoolingTempChanged(
    ClimateCoolingTempChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setTemperature(SetTemperatureParams(temperature: event.temperature.toDouble()));
      // TODO: Когда бэкенд поддержит отдельные температуры, использовать отдельный API
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Cooling temperature error: $e'));
    }
  }

  /// Изменение целевой влажности
  Future<void> _onHumidityChanged(
    ClimateHumidityChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setHumidity(SetHumidityParams(humidity: event.humidity));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Humidity setting error: $e'));
    }
  }

  /// Смена режима климата
  Future<void> _onModeChanged(
    ClimateModeChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setClimateMode(SetClimateModeParams(mode: event.mode));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Mode change error: $e'));
    }
  }

  /// Смена пресета
  Future<void> _onPresetChanged(
    ClimatePresetChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setPreset(SetPresetParams(preset: event.preset));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Preset change error: $e'));
    }
  }

  /// Изменение притока воздуха
  Future<void> _onSupplyAirflowChanged(
    ClimateSupplyAirflowChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setAirflow(SetAirflowParams(
        type: AirflowType.supply,
        value: event.value,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Supply airflow error: $e'));
    }
  }

  /// Изменение вытяжки воздуха
  Future<void> _onExhaustAirflowChanged(
    ClimateExhaustAirflowChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setAirflow(SetAirflowParams(
        type: AirflowType.exhaust,
        value: event.value,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Exhaust airflow error: $e'));
    }
  }

  @override
  Future<void> close() {
    _climateSubscription?.cancel();
    return super.close();
  }
}
