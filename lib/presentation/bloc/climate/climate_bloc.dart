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
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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
  final GetAlarmHistory _getAlarmHistory;
  final WatchCurrentClimate _watchCurrentClimate;
  final SetDevicePower _setDevicePower;
  final SetTemperature _setTemperature;
  final SetCoolingTemperature _setCoolingTemperature;
  final SetHumidity _setHumidity;
  final SetClimateMode _setClimateMode;
  final SetOperatingMode _setOperatingMode;
  final SetPreset _setPreset;
  final SetAirflow _setAirflow;

  StreamSubscription<ClimateState>? _climateSubscription;

  ClimateBloc({
    required GetCurrentClimateState getCurrentClimateState,
    required GetDeviceState getDeviceState,
    required GetDeviceFullState getDeviceFullState,
    required GetAlarmHistory getAlarmHistory,
    required WatchCurrentClimate watchCurrentClimate,
    required SetDevicePower setDevicePower,
    required SetTemperature setTemperature,
    required SetCoolingTemperature setCoolingTemperature,
    required SetHumidity setHumidity,
    required SetClimateMode setClimateMode,
    required SetOperatingMode setOperatingMode,
    required SetPreset setPreset,
    required SetAirflow setAirflow,
  })  : _getCurrentClimateState = getCurrentClimateState,
        _getDeviceState = getDeviceState,
        _getDeviceFullState = getDeviceFullState,
        _getAlarmHistory = getAlarmHistory,
        _watchCurrentClimate = watchCurrentClimate,
        _setDevicePower = setDevicePower,
        _setTemperature = setTemperature,
        _setCoolingTemperature = setCoolingTemperature,
        _setHumidity = setHumidity,
        _setClimateMode = setClimateMode,
        _setOperatingMode = setOperatingMode,
        _setPreset = setPreset,
        _setAirflow = setAirflow,
        super(const ClimateControlState()) {
    // События жизненного цикла
    on<ClimateSubscriptionRequested>(_onSubscriptionRequested);
    on<ClimateDeviceChanged>(_onDeviceChanged);

    // Обновления из стрима
    on<ClimateStateUpdated>(_onStateUpdated);
    on<ClimateFullStateLoaded>(_onFullStateLoaded);

    // История аварий
    on<ClimateAlarmHistoryRequested>(_onAlarmHistoryRequested);
    on<ClimateAlarmHistoryLoaded>(_onAlarmHistoryLoaded);

    // Управление устройством
    on<ClimatePowerToggled>(_onPowerToggled);
    on<ClimateTemperatureChanged>(_onTemperatureChanged);
    on<ClimateHeatingTempChanged>(_onHeatingTempChanged);
    on<ClimateCoolingTempChanged>(_onCoolingTempChanged);
    on<ClimateHumidityChanged>(_onHumidityChanged);
    on<ClimateModeChanged>(_onModeChanged);
    on<ClimateOperatingModeChanged>(_onOperatingModeChanged);
    on<ClimatePresetChanged>(_onPresetChanged);

    // Airflow events с restartable() - отменяет предыдущие запросы при новых событиях
    on<ClimateSupplyAirflowChanged>(
      _onSupplyAirflowChanged,
      transformer: restartable(),
    );
    on<ClimateExhaustAirflowChanged>(
      _onExhaustAirflowChanged,
      transformer: restartable(),
    );
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
        onError: (error) {
          // Игнорируем ошибки стрима - данные уже загружены
        },
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
    debugPrint('📡 ClimateBloc: Loading device ${event.deviceId}');
    emit(state.copyWith(status: ClimateControlStatus.loading));

    try {
      // Загружаем состояние выбранного устройства через Use Case
      final climate = await _getDeviceState(
        GetDeviceStateParams(deviceId: event.deviceId),
      );
      debugPrint('✅ ClimateBloc: Climate loaded for ${event.deviceId}');

      // Загружаем полное состояние (с авариями)
      DeviceFullState? fullState;
      try {
        fullState = await _getDeviceFullState(
          GetDeviceFullStateParams(deviceId: event.deviceId),
        );
        debugPrint('✅ ClimateBloc: FullState loaded, power=${fullState.power}');
      } catch (e) {
        // Аварии не критичны для отображения основного UI
        debugPrint('⚠️ ClimateBloc: Failed to load fullState: $e');
        ApiLogger.warning('[ClimateBloc] Не удалось загрузить аварии', e);
      }

      emit(state.copyWith(
        status: ClimateControlStatus.success,
        climate: climate,
        deviceFullState: fullState,
      ));
      debugPrint('✅ ClimateBloc: State emitted successfully');
    } catch (e) {
      debugPrint('❌ ClimateBloc: Error loading device: $e');
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

  /// Запрос на загрузку истории аварий
  Future<void> _onAlarmHistoryRequested(
    ClimateAlarmHistoryRequested event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      final history = await _getAlarmHistory(
        GetAlarmHistoryParams(deviceId: event.deviceId),
      );
      emit(state.copyWith(alarmHistory: history));
    } catch (e) {
      ApiLogger.warning('[ClimateBloc] Не удалось загрузить историю аварий', e);
      // Не критично — оставляем текущее состояние
    }
  }

  /// История аварий загружена
  void _onAlarmHistoryLoaded(
    ClimateAlarmHistoryLoaded event,
    Emitter<ClimateControlState> emit,
  ) {
    emit(state.copyWith(alarmHistory: event.history));
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
    final previousTemp = state.climate?.targetTemperature;

    // Optimistic update - сразу обновляем UI
    if (state.climate != null) {
      emit(state.copyWith(
        climate: state.climate!.copyWith(targetTemperature: event.temperature),
      ));
    }

    try {
      await _setTemperature(SetTemperatureParams(temperature: event.temperature));
    } catch (e) {
      // Откат при ошибке
      if (state.climate != null && previousTemp != null) {
        emit(state.copyWith(
          climate: state.climate!.copyWith(targetTemperature: previousTemp),
          errorMessage: 'Temperature setting error: $e',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'Temperature setting error: $e'));
      }
    }
  }

  /// Изменение температуры нагрева
  Future<void> _onHeatingTempChanged(
    ClimateHeatingTempChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    final previousTemp = state.deviceFullState?.heatingTemperature;

    // Optimistic update - сразу обновляем UI
    if (state.deviceFullState != null) {
      emit(state.copyWith(
        deviceFullState: state.deviceFullState!.copyWith(
          heatingTemperature: event.temperature,
        ),
      ));
    }

    try {
      await _setTemperature(SetTemperatureParams(temperature: event.temperature.toDouble()));
    } catch (e) {
      // Откат при ошибке
      if (state.deviceFullState != null && previousTemp != null) {
        emit(state.copyWith(
          deviceFullState: state.deviceFullState!.copyWith(
            heatingTemperature: previousTemp,
          ),
          errorMessage: 'Heating temperature error: $e',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'Heating temperature error: $e'));
      }
    }
  }

  /// Изменение температуры охлаждения
  Future<void> _onCoolingTempChanged(
    ClimateCoolingTempChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    final previousTemp = state.deviceFullState?.coolingTemperature;

    // Optimistic update - сразу обновляем UI
    if (state.deviceFullState != null) {
      emit(state.copyWith(
        deviceFullState: state.deviceFullState!.copyWith(
          coolingTemperature: event.temperature,
        ),
      ));
    }

    try {
      await _setCoolingTemperature(SetCoolingTemperatureParams(temperature: event.temperature));
    } catch (e) {
      // Откат при ошибке
      if (state.deviceFullState != null && previousTemp != null) {
        emit(state.copyWith(
          deviceFullState: state.deviceFullState!.copyWith(
            coolingTemperature: previousTemp,
          ),
          errorMessage: 'Cooling temperature error: $e',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'Cooling temperature error: $e'));
      }
    }
  }

  /// Изменение целевой влажности
  Future<void> _onHumidityChanged(
    ClimateHumidityChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    final previousHumidity = state.climate?.targetHumidity;

    // Optimistic update - сразу обновляем UI
    if (state.climate != null) {
      emit(state.copyWith(
        climate: state.climate!.copyWith(targetHumidity: event.humidity),
      ));
    }

    try {
      await _setHumidity(SetHumidityParams(humidity: event.humidity));
    } catch (e) {
      // Откат при ошибке
      if (state.climate != null && previousHumidity != null) {
        emit(state.copyWith(
          climate: state.climate!.copyWith(targetHumidity: previousHumidity),
          errorMessage: 'Humidity setting error: $e',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'Humidity setting error: $e'));
      }
    }
  }

  /// Смена режима климата (enum: heating, cooling, auto, etc.)
  Future<void> _onModeChanged(
    ClimateModeChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    final previousMode = state.climate?.mode;

    // Optimistic update - сразу обновляем UI
    if (state.climate != null) {
      emit(state.copyWith(
        climate: state.climate!.copyWith(mode: event.mode),
      ));
    }

    try {
      await _setClimateMode(SetClimateModeParams(mode: event.mode));
    } catch (e) {
      // Откат при ошибке
      if (state.climate != null && previousMode != null) {
        emit(state.copyWith(
          climate: state.climate!.copyWith(mode: previousMode),
          errorMessage: 'Mode change error: $e',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'Mode change error: $e'));
      }
    }
  }

  /// Смена режима работы установки (String: basic, intensive, economy, etc.)
  Future<void> _onOperatingModeChanged(
    ClimateOperatingModeChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    final previousPreset = state.climate?.preset;

    // Optimistic update - сразу обновляем UI
    if (state.climate != null) {
      emit(state.copyWith(
        climate: state.climate!.copyWith(preset: event.mode),
      ));
    }

    try {
      await _setOperatingMode(SetOperatingModeParams(mode: event.mode));
    } catch (e) {
      // Откат при ошибке
      if (state.climate != null && previousPreset != null) {
        emit(state.copyWith(
          climate: state.climate!.copyWith(preset: previousPreset),
          errorMessage: 'Operating mode error: $e',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'Operating mode error: $e'));
      }
    }
  }

  /// Смена пресета
  Future<void> _onPresetChanged(
    ClimatePresetChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    final previousPreset = state.climate?.preset;

    // Optimistic update - сразу обновляем UI
    if (state.climate != null) {
      emit(state.copyWith(
        climate: state.climate!.copyWith(preset: event.preset),
      ));
    }

    try {
      await _setPreset(SetPresetParams(preset: event.preset));
    } catch (e) {
      // Откат при ошибке
      if (state.climate != null && previousPreset != null) {
        emit(state.copyWith(
          climate: state.climate!.copyWith(preset: previousPreset),
          errorMessage: 'Preset change error: $e',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'Preset change error: $e'));
      }
    }
  }

  /// Изменение притока воздуха
  Future<void> _onSupplyAirflowChanged(
    ClimateSupplyAirflowChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    final previousValue = state.climate?.supplyAirflow;

    // Optimistic update - сразу обновляем UI
    if (state.climate != null) {
      emit(state.copyWith(
        climate: state.climate!.copyWith(supplyAirflow: event.value.toDouble()),
      ));
    }

    try {
      await _setAirflow(SetAirflowParams(
        type: AirflowType.supply,
        value: event.value,
      ));
    } catch (e) {
      // Откатываем optimistic update при ошибке
      if (state.climate != null && previousValue != null) {
        emit(state.copyWith(
          climate: state.climate!.copyWith(supplyAirflow: previousValue),
          errorMessage: 'Supply airflow error: $e',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'Supply airflow error: $e'));
      }
    }
  }

  /// Изменение вытяжки воздуха
  Future<void> _onExhaustAirflowChanged(
    ClimateExhaustAirflowChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    final previousValue = state.climate?.exhaustAirflow;

    // Optimistic update - сразу обновляем UI
    if (state.climate != null) {
      emit(state.copyWith(
        climate: state.climate!.copyWith(exhaustAirflow: event.value.toDouble()),
      ));
    }

    try {
      await _setAirflow(SetAirflowParams(
        type: AirflowType.exhaust,
        value: event.value,
      ));
    } catch (e) {
      // Откатываем optimistic update при ошибке
      if (state.climate != null && previousValue != null) {
        emit(state.copyWith(
          climate: state.climate!.copyWith(exhaustAirflow: previousValue),
          errorMessage: 'Exhaust airflow error: $e',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'Exhaust airflow error: $e'));
      }
    }
  }

  @override
  Future<void> close() {
    _climateSubscription?.cancel();
    return super.close();
  }
}
