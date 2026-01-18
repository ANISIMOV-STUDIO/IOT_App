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

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/data/api/mappers/device_json_mapper.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';

part 'climate_event.dart';
part 'climate_state.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы ограничений температуры
abstract class TemperatureLimits {
  /// Минимальная температура (нагрев и охлаждение)
  static const int min = 15;

  /// Максимальная температура (нагрев и охлаждение)
  static const int max = 35;
}

/// Debounce трансформер для быстрых кликов
/// Ждёт 500мс после последнего события, затем обрабатывает только последнее
EventTransformer<E> debounceRestartable<E>({
  Duration duration = const Duration(milliseconds: 500),
}) =>
    (events, mapper) => restartable<E>().call(
          events.debounce(duration),
          mapper,
        );

/// Extension для debounce на Stream
extension DebounceExtension<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    Timer? timer;
    return transform(StreamTransformer<T, T>.fromHandlers(
      handleData: (data, sink) {
        timer?.cancel();
        timer = Timer(duration, () => sink.add(data));
      },
      handleDone: (sink) {
        timer?.cancel();
        sink.close();
      },
    ));
  }
}

/// BLoC для управления климатом текущего устройства
class ClimateBloc extends Bloc<ClimateEvent, ClimateControlState> {

  ClimateBloc({
    required GetCurrentClimateState getCurrentClimateState,
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
    required SetScheduleEnabled setScheduleEnabled,
    required WatchDeviceFullState watchDeviceFullState,
  })  : _getCurrentClimateState = getCurrentClimateState,
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
        _setScheduleEnabled = setScheduleEnabled,
        _watchDeviceFullState = watchDeviceFullState,
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

    // Температура (мгновенное обновление UI, отправка через Commit)
    on<ClimateTemperatureChanged>(_onTemperatureChanged, transformer: debounceRestartable());
    on<ClimateHeatingTempChanged>(_onHeatingTempChanged);
    on<ClimateHeatingTempCommit>(_onHeatingTempCommit, transformer: debounceRestartable());
    on<ClimateCoolingTempChanged>(_onCoolingTempChanged);
    on<ClimateCoolingTempCommit>(_onCoolingTempCommit, transformer: debounceRestartable());
    on<ClimateHumidityChanged>(_onHumidityChanged);
    on<ClimateModeChanged>(_onModeChanged);
    on<ClimateOperatingModeChanged>(_onOperatingModeChanged);
    on<ClimatePresetChanged>(_onPresetChanged);

    // Вентиляторы (мгновенное обновление UI, отправка через Commit)
    on<ClimateSupplyAirflowChanged>(_onSupplyAirflowChanged);
    on<ClimateSupplyAirflowCommit>(_onSupplyAirflowCommit, transformer: debounceRestartable());

    on<ClimateExhaustAirflowChanged>(_onExhaustAirflowChanged);
    on<ClimateExhaustAirflowCommit>(_onExhaustAirflowCommit, transformer: debounceRestartable());

    // Расписание
    on<ClimateScheduleToggled>(_onScheduleToggled);

    // Обновление локального состояния
    on<ClimateQuickSensorsUpdated>(_onQuickSensorsUpdated);
  }
  final GetCurrentClimateState _getCurrentClimateState;
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
  final SetScheduleEnabled _setScheduleEnabled;
  final WatchDeviceFullState _watchDeviceFullState;

  StreamSubscription<ClimateState>? _climateSubscription;
  StreamSubscription<DeviceFullState>? _deviceFullStateSubscription;

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
    emit(state.copyWith(status: ClimateControlStatus.loading));

    try {
      // Загружаем полное состояние устройства (сразу включает климатическое + аварии)
      final fullState = await _getDeviceFullState(
        GetDeviceFullStateParams(deviceId: event.deviceId),
      );

      // Формируем ClimateState на основе полного состояния для оптимизации запросов
      final climate = ClimateState(
        roomId: fullState.id,
        deviceName: fullState.name,
        currentTemperature: fullState.currentTemperature,
        targetTemperature: fullState.targetTemperature,
        humidity: fullState.humidity,
        targetHumidity: fullState.targetHumidity,
        // Используем маппер из entities package или парсим вручную если хелперы недоступны.
        // Здесь мы знаем формат данных:
        supplyAirflow: DeviceJsonMapper.parseFanValue(fullState.supplyFan),
        exhaustAirflow: DeviceJsonMapper.parseFanValue(fullState.exhaustFan),
        mode: fullState.mode,
        preset: fullState.operatingMode, // Теперь у нас есть точное значение
        airQuality: AirQualityLevel.good, // В DeviceFullState нет явного airQuality, используем default
        co2Ppm: fullState.co2Level ?? 400,
        isOn: fullState.power,
      );

      emit(state.copyWith(
        status: ClimateControlStatus.success,
        climate: climate,
        deviceFullState: fullState,
      ));

      // Подписываемся на real-time обновления DeviceFullState (SignalR)
      await _deviceFullStateSubscription?.cancel();
      _deviceFullStateSubscription = _watchDeviceFullState(
        WatchDeviceFullStateParams(deviceId: event.deviceId),
      ).listen(
        (fullState) => add(ClimateFullStateLoaded(fullState)),
        onError: (Object error) {
          // Не критично, если SignalR не работает
          ApiLogger.warning('[ClimateBloc] DeviceFullState stream error', error);
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: ClimateControlStatus.failure,
        errorMessage: 'State loading error: $e',
      ));
    }
  }

  /// Обновление состояния климата из стрима
  /// Приходит через SignalR когда устройство подтверждает изменения
  void _onStateUpdated(
    ClimateStateUpdated event,
    Emitter<ClimateControlState> emit,
  ) {
    // Backend фильтрует старые значения — просто сбрасываем pending
    emit(state.copyWith(
      climate: event.climate,
      isPendingHeatingTemperature: false,
      isPendingCoolingTemperature: false,
      isPendingSupplyFan: false,
      isPendingExhaustFan: false,
    ));
  }

  /// Загружено полное состояние устройства
  /// Приходит через SignalR когда устройство подтверждает изменения
  ///
  /// ВАЖНО: quickSensors - это пользовательская настройка, не телеметрия.
  /// SignalR обновления могут не содержать quickSensors, поэтому сохраняем
  /// существующее значение. Обновление через ClimateQuickSensorsUpdated event.
  void _onFullStateLoaded(
    ClimateFullStateLoaded event,
    Emitter<ClimateControlState> emit,
  ) {
    final existing = state.deviceFullState;
    final incoming = event.fullState;

    // Сохраняем quickSensors - это user preference, не телеметрия
    final mergedState = existing != null
        ? incoming.copyWith(quickSensors: existing.quickSensors)
        : incoming;

    emit(state.copyWith(
      deviceFullState: mergedState,
      isPendingHeatingTemperature: false,
      isPendingCoolingTemperature: false,
      isPendingSupplyFan: false,
      isPendingExhaustFan: false,
    ));
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
    if (state.isTogglingPower) {
      return; // Предотвращаем двойные нажатия
    }

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

  /// UI update: Изменение температуры нагрева
  void _onHeatingTempChanged(
    ClimateHeatingTempChanged event,
    Emitter<ClimateControlState> emit,
  ) {
    // Ограничиваем температуру в допустимых пределах
    final clampedTemp = event.temperature.clamp(
      TemperatureLimits.min,
      TemperatureLimits.max,
    );

    // Optimistic update - сразу обновляем UI + показываем pending
    if (state.deviceFullState != null) {
      emit(state.copyWith(
        isPendingHeatingTemperature: true,
        deviceFullState: state.deviceFullState!.copyWith(
          heatingTemperature: clampedTemp,
        ),
      ));

      // Ставим в очередь реальный запрос (с debounce)
      add(ClimateHeatingTempCommit(clampedTemp));
    }
  }

  /// API call: Отправка температуры нагрева
  Future<void> _onHeatingTempCommit(
    ClimateHeatingTempCommit event,
    Emitter<ClimateControlState> emit,
  ) async {
    // Запоминаем текущее состояние для возможного отката
    // ВАЖНО: берем значение, которое было ДО начала всей серии изменений, если возможно
    // Но здесь у нас нет доступа к истории, поэтому если API упадет - вернем то, что сейчас в UI (что неверно)
    // НО, так как мы используем optimistic UI, пользователь уже видит новое значение.
    // Если ошибка - лучше показать тоаст ошибки, чем ломать UI
    
    try {
      await _setTemperature(SetTemperatureParams(temperature: event.temperature.toDouble()));
      // pending сбросится когда придёт SignalR update
    } catch (e) {
      emit(state.copyWith(
        isPendingHeatingTemperature: false,
        errorMessage: 'Heating temperature error: $e',
      ));
    }
  }

  /// UI update: Изменение температуры охлаждения
  void _onCoolingTempChanged(
    ClimateCoolingTempChanged event,
    Emitter<ClimateControlState> emit,
  ) {
    // Ограничиваем температуру в допустимых пределах
    final clampedTemp = event.temperature.clamp(
      TemperatureLimits.min,
      TemperatureLimits.max,
    );

    // Optimistic update - сразу обновляем UI + показываем pending
    if (state.deviceFullState != null) {
      emit(state.copyWith(
        isPendingCoolingTemperature: true,
        deviceFullState: state.deviceFullState!.copyWith(
          coolingTemperature: clampedTemp,
        ),
      ));

      // Ставим в очередь реальный запрос (с debounce)
      add(ClimateCoolingTempCommit(clampedTemp));
    }
  }

  /// API call: Отправка температуры охлаждения
  Future<void> _onCoolingTempCommit(
    ClimateCoolingTempCommit event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setCoolingTemperature(SetCoolingTemperatureParams(temperature: event.temperature));
      // pending сбросится когда придёт SignalR update
    } catch (e) {
      emit(state.copyWith(
        isPendingCoolingTemperature: false,
        errorMessage: 'Cooling temperature error: $e',
      ));
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

  /// UI update: Изменение притока воздуха
  void _onSupplyAirflowChanged(
    ClimateSupplyAirflowChanged event,
    Emitter<ClimateControlState> emit,
  ) {
    // Optimistic update - сразу обновляем UI + показываем pending
    if (state.climate != null) {
      emit(state.copyWith(
        isPendingSupplyFan: true,
        climate: state.climate!.copyWith(supplyAirflow: event.value),
      ));
      
      add(ClimateSupplyAirflowCommit(event.value));
    }
  }

  /// API call: Отправка притока воздуха
  Future<void> _onSupplyAirflowCommit(
    ClimateSupplyAirflowCommit event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setAirflow(SetAirflowParams(
        type: AirflowType.supply,
        value: event.value,
      ));
      // pending сбросится когда придёт SignalR update
    } catch (e) {
      emit(state.copyWith(
        isPendingSupplyFan: false,
        errorMessage: 'Supply airflow error: $e',
      ));
    }
  }

  /// UI update: Изменение вытяжки воздуха
  void _onExhaustAirflowChanged(
    ClimateExhaustAirflowChanged event,
    Emitter<ClimateControlState> emit,
  ) {
    // Optimistic update - сразу обновляем UI + показываем pending
    if (state.climate != null) {
      emit(state.copyWith(
        isPendingExhaustFan: true,
        climate: state.climate!.copyWith(exhaustAirflow: event.value),
      ));
      
      add(ClimateExhaustAirflowCommit(event.value));
    }
  }

  /// API call: Отправка вытяжки воздуха
  Future<void> _onExhaustAirflowCommit(
    ClimateExhaustAirflowCommit event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setAirflow(SetAirflowParams(
        type: AirflowType.exhaust,
        value: event.value,
      ));
      // pending сбросится когда придёт SignalR update
    } catch (e) {
      emit(state.copyWith(
        isPendingExhaustFan: false,
        errorMessage: 'Exhaust airflow error: $e',
      ));
    }
  }

  /// Включение/выключение расписания
  Future<void> _onScheduleToggled(
    ClimateScheduleToggled event,
    Emitter<ClimateControlState> emit,
  ) async {
    // Блокируем кнопку на время запроса
    if (state.isTogglingSchedule) {
      return;
    }

    final deviceId = state.deviceFullState?.id;
    if (deviceId == null) {
      emit(state.copyWith(errorMessage: 'Device ID not found'));
      return;
    }

    emit(state.copyWith(isTogglingSchedule: true));

    try {
      await _setScheduleEnabled(SetScheduleEnabledParams(
        deviceId: deviceId,
        enabled: event.enabled,
      ));
      
      // Обновляем локальное состояние (optimistic update)
      if (state.deviceFullState != null) {
        emit(state.copyWith(
          isTogglingSchedule: false,
          deviceFullState: state.deviceFullState!.copyWith(
            isScheduleEnabled: event.enabled,
          ),
        ));
      } else {
        emit(state.copyWith(isTogglingSchedule: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isTogglingSchedule: false,
        errorMessage: 'Schedule toggle error: $e',
      ));
    }
  }

  /// Обновление quickSensors в локальном состоянии (после успешного сохранения)
  void _onQuickSensorsUpdated(
    ClimateQuickSensorsUpdated event,
    Emitter<ClimateControlState> emit,
  ) {
    if (state.deviceFullState != null) {
      emit(state.copyWith(
        deviceFullState: state.deviceFullState!.copyWith(
          quickSensors: event.quickSensors,
        ),
      ));
    }
  }

  @override
  Future<void> close() {
    _climateSubscription?.cancel();
    _deviceFullStateSubscription?.cancel();
    return super.close();
  }
}
