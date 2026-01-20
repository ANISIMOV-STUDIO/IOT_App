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
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
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

/// Таймаут ожидания подтверждения от устройства
const _powerToggleTimeout = Duration(seconds: 15);

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
///
/// Timer отменяется при handleDone и handleError для избежания race condition
extension DebounceExtension<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    Timer? timer;
    return transform(StreamTransformer<T, T>.fromHandlers(
      handleData: (data, sink) {
        timer?.cancel();
        timer = Timer(duration, () => sink.add(data));
      },
      handleError: (error, stackTrace, sink) {
        timer?.cancel();
        timer = null;
        sink.addError(error, stackTrace);
      },
      handleDone: (sink) {
        timer?.cancel();
        timer = null;
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
    required ResetAlarm resetAlarm,
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
    required SetModeSettings setModeSettings,
    required WatchDeviceFullState watchDeviceFullState,
    required RequestDeviceUpdate requestDeviceUpdate,
  })  : _getCurrentClimateState = getCurrentClimateState,
        _getDeviceFullState = getDeviceFullState,
        _getAlarmHistory = getAlarmHistory,
        _resetAlarm = resetAlarm,
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
        _setModeSettings = setModeSettings,
        _watchDeviceFullState = watchDeviceFullState,
        _requestDeviceUpdate = requestDeviceUpdate,
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
    on<ClimateAlarmResetRequested>(_onAlarmResetRequested);

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

    // Настройки режима
    on<ClimateModeSettingsChanged>(_onModeSettingsChanged);

    // Обновление локального состояния
    on<ClimateQuickSensorsUpdated>(_onQuickSensorsUpdated);
  }
  final GetCurrentClimateState _getCurrentClimateState;
  final GetDeviceFullState _getDeviceFullState;
  final GetAlarmHistory _getAlarmHistory;
  final ResetAlarm _resetAlarm;
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
  final SetModeSettings _setModeSettings;
  final WatchDeviceFullState _watchDeviceFullState;
  final RequestDeviceUpdate _requestDeviceUpdate;

  StreamSubscription<ClimateState>? _climateSubscription;
  StreamSubscription<DeviceFullState>? _deviceFullStateSubscription;
  Timer? _powerToggleTimer;

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

      // Запрашиваем актуальные данные от устройства (fire-and-forget)
      // Устройство опубликует свежие данные в MQTT, которые придут через SignalR
      if (climate.roomId.isNotEmpty) {
        _requestDeviceUpdate(climate.roomId).ignore();
      }
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
        // Получаем значения вентиляторов из настроек текущего режима
        supplyAirflow: fullState.modeSettings?[fullState.operatingMode]?.supplyFan?.toDouble() ?? 50,
        exhaustAirflow: fullState.modeSettings?[fullState.operatingMode]?.exhaustFan?.toDouble() ?? 50,
        mode: fullState.mode,
        preset: fullState.operatingMode,
        airQuality: AirQualityLevel.good, // В DeviceFullState нет явного airQuality, используем default
        co2Ppm: fullState.co2Level ?? 400,
        isOn: fullState.power,
      );

      emit(state.copyWith(
        status: ClimateControlStatus.success,
        climate: climate,
        deviceFullState: fullState,
        // Сбрасываем ВСЕ pending флаги при смене/перезагрузке устройства.
        // Это критично для page refresh: debounce события могут потеряться,
        // но pending флаги останутся true навсегда.
        isPendingHeatingTemperature: false,
        isPendingCoolingTemperature: false,
        isPendingSupplyFan: false,
        isPendingExhaustFan: false,
        isTogglingPower: false,
        isTogglingSchedule: false,
        clearPendingPower: true,
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

      // Запрашиваем актуальные данные от устройства (fire-and-forget)
      _requestDeviceUpdate(event.deviceId).ignore();
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
    // Проверяем, подтвердилось ли ожидаемое состояние питания
    final pendingPower = state.pendingPowerState;
    final powerConfirmed = pendingPower == null || event.climate.isOn == pendingPower;

    if (powerConfirmed && pendingPower != null) {
      developer.log(
        'Power state confirmed by SignalR: isOn=${event.climate.isOn}',
        name: 'ClimateBloc',
      );
      _powerToggleTimer?.cancel();
      _powerToggleTimer = null;
    }

    emit(state.copyWith(
      climate: event.climate,
      // Сбрасываем лоадер только если power подтверждён
      isTogglingPower: !powerConfirmed && state.isTogglingPower,
      clearPendingPower: powerConfirmed,
      // Pending температуры/вентиляторов НЕ сбрасываем здесь —
      // они сбрасываются после успешного API ответа в *Commit handlers
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

    // Мержим modeSettings: если в incoming null, берём из existing
    final mergedModeSettings = _mergeModeSettings(
      existing?.modeSettings,
      incoming.modeSettings,
    );

    // Сохраняем quickSensors - это user preference, не телеметрия
    final mergedState = existing != null
        ? incoming.copyWith(
            quickSensors: existing.quickSensors,
            modeSettings: mergedModeSettings,
          )
        : incoming;

    // Проверяем, подтвердилось ли ожидаемое состояние питания
    final pendingPower = state.pendingPowerState;
    final powerConfirmed = pendingPower == null || incoming.power == pendingPower;

    if (powerConfirmed && pendingPower != null) {
      developer.log(
        'Power state confirmed by SignalR (full state): power=${incoming.power}',
        name: 'ClimateBloc',
      );
      _powerToggleTimer?.cancel();
      _powerToggleTimer = null;
    }

    emit(state.copyWith(
      deviceFullState: mergedState,
      // Сбрасываем лоадер только если power подтверждён
      isTogglingPower: !powerConfirmed && state.isTogglingPower,
      clearPendingPower: powerConfirmed,
      // Pending температуры/вентиляторов НЕ сбрасываем здесь —
      // они сбрасываются после успешного API ответа в *Commit handlers
    ));
  }

  /// Мержит modeSettings: incoming значения приоритетнее, но null не перезаписывает.
  /// Также не перезаписываем поля, которые сейчас в pending состоянии —
  /// иначе SignalR может вернуть старое значение и затереть локальное изменение.
  Map<String, ModeSettings>? _mergeModeSettings(
    Map<String, ModeSettings>? existing,
    Map<String, ModeSettings>? incoming,
  ) {
    if (incoming == null) {
      return existing;
    }
    if (existing == null) {
      return incoming;
    }

    final merged = <String, ModeSettings>{...existing};
    for (final entry in incoming.entries) {
      final existingSettings = existing[entry.key];
      if (existingSettings == null) {
        merged[entry.key] = entry.value;
      } else {
        // Мержим отдельные поля: incoming приоритетнее, но null не перезаписывает.
        // Если поле в pending состоянии — сохраняем existing (локальное изменение).
        merged[entry.key] = ModeSettings(
          heatingTemperature: state.isPendingHeatingTemperature
              ? existingSettings.heatingTemperature
              : (entry.value.heatingTemperature ?? existingSettings.heatingTemperature),
          coolingTemperature: state.isPendingCoolingTemperature
              ? existingSettings.coolingTemperature
              : (entry.value.coolingTemperature ?? existingSettings.coolingTemperature),
          supplyFan: state.isPendingSupplyFan
              ? existingSettings.supplyFan
              : (entry.value.supplyFan ?? existingSettings.supplyFan),
          exhaustFan: state.isPendingExhaustFan
              ? existingSettings.exhaustFan
              : (entry.value.exhaustFan ?? existingSettings.exhaustFan),
        );
      }
    }
    return merged;
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

  /// Сброс активных аварий
  Future<void> _onAlarmResetRequested(
    ClimateAlarmResetRequested event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _resetAlarm(event.deviceId);
      // После сброса аварий очищаем локальный список
      final updatedDeviceState = state.deviceFullState?.copyWith(
        activeAlarms: const {},
      );
      emit(state.copyWith(deviceFullState: updatedDeviceState));
    } catch (e) {
      developer.log('Failed to reset alarms: $e', name: 'ClimateBloc');
    }
  }

  /// Включение/выключение устройства
  ///
  /// Лоадер остаётся до подтверждения от SignalR (pendingPowerState)
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
    // pendingPowerState — ожидаемое значение, лоадер останется пока SignalR не подтвердит
    final optimisticClimate = state.climate?.copyWith(isOn: event.isOn);
    emit(state.copyWith(
      isTogglingPower: true,
      pendingPowerState: event.isOn,
      climate: optimisticClimate,
    ));

    try {
      await _setDevicePower(SetDevicePowerParams(isOn: event.isOn));
      developer.log('_onPowerToggled: command sent, waiting for SignalR confirmation', name: 'ClimateBloc');

      // Таймаут на случай если SignalR не пришлёт подтверждение
      _powerToggleTimer?.cancel();
      _powerToggleTimer = Timer(_powerToggleTimeout, () {
        if (!isClosed && state.isTogglingPower) {
          developer.log(
            '_onPowerToggled: timeout waiting for SignalR confirmation',
            name: 'ClimateBloc',
          );
          // ignore: invalid_use_of_visible_for_testing_member
          emit(state.copyWith(
            isTogglingPower: false,
            clearPendingPower: true,
          ));
        }
      });
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
        clearPendingPower: true,
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

  /// Обновляет modeSettings для текущего режима
  Map<String, ModeSettings>? _updateCurrentModeSettings({
    int? heatingTemperature,
    int? coolingTemperature,
    int? supplyFan,
    int? exhaustFan,
  }) {
    final fullState = state.deviceFullState;
    if (fullState == null) {
      return null;
    }

    final currentMode = fullState.operatingMode;
    final currentSettings = fullState.modeSettings?[currentMode];
    if (currentSettings == null) {
      return fullState.modeSettings;
    }

    final updatedSettings = currentSettings.copyWith(
      heatingTemperature: heatingTemperature,
      coolingTemperature: coolingTemperature,
      supplyFan: supplyFan,
      exhaustFan: exhaustFan,
    );

    return {
      ...?fullState.modeSettings,
      currentMode: updatedSettings,
    };
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
    final fullState = state.deviceFullState;
    if (fullState != null) {
      final updatedModeSettings = _updateCurrentModeSettings(
        heatingTemperature: clampedTemp,
      );

      emit(state.copyWith(
        isPendingHeatingTemperature: true,
        deviceFullState: fullState.copyWith(
          modeSettings: updatedModeSettings,
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
      // Сбрасываем pending после успешного API ответа
      emit(state.copyWith(isPendingHeatingTemperature: false));
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
    final fullState = state.deviceFullState;
    if (fullState != null) {
      final updatedModeSettings = _updateCurrentModeSettings(
        coolingTemperature: clampedTemp,
      );

      emit(state.copyWith(
        isPendingCoolingTemperature: true,
        deviceFullState: fullState.copyWith(
          modeSettings: updatedModeSettings,
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
      // Сбрасываем pending после успешного API ответа
      emit(state.copyWith(isPendingCoolingTemperature: false));
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
    developer.log(
      '_onOperatingModeChanged called: mode=${event.mode}',
      name: 'ClimateBloc',
    );

    final previousPreset = state.climate?.preset;

    // Optimistic update - сразу обновляем UI
    if (state.climate != null) {
      emit(state.copyWith(
        climate: state.climate!.copyWith(preset: event.mode),
      ));
    }

    try {
      developer.log(
        '_onOperatingModeChanged: calling _setOperatingMode with mode=${event.mode}',
        name: 'ClimateBloc',
      );
      final result = await _setOperatingMode(SetOperatingModeParams(mode: event.mode));
      developer.log(
        '_onOperatingModeChanged: success, result preset=${result.preset}',
        name: 'ClimateBloc',
      );
    } catch (e) {
      developer.log(
        '_onOperatingModeChanged: error $e',
        name: 'ClimateBloc',
      );
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
    final fullState = state.deviceFullState;
    if (state.climate != null && fullState != null) {
      final updatedModeSettings = _updateCurrentModeSettings(
        supplyFan: event.value.round(),
      );

      emit(state.copyWith(
        isPendingSupplyFan: true,
        climate: state.climate!.copyWith(supplyAirflow: event.value),
        deviceFullState: fullState.copyWith(
          modeSettings: updatedModeSettings,
        ),
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
      // Сбрасываем pending после успешного API ответа
      emit(state.copyWith(isPendingSupplyFan: false));
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
    final fullState = state.deviceFullState;
    if (state.climate != null && fullState != null) {
      final updatedModeSettings = _updateCurrentModeSettings(
        exhaustFan: event.value.round(),
      );

      emit(state.copyWith(
        isPendingExhaustFan: true,
        climate: state.climate!.copyWith(exhaustAirflow: event.value),
        deviceFullState: fullState.copyWith(
          modeSettings: updatedModeSettings,
        ),
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
      // Сбрасываем pending после успешного API ответа
      emit(state.copyWith(isPendingExhaustFan: false));
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

  /// Изменение настроек режима (температуры и скорости вентиляторов)
  Future<void> _onModeSettingsChanged(
    ClimateModeSettingsChanged event,
    Emitter<ClimateControlState> emit,
  ) async {
    try {
      await _setModeSettings(SetModeSettingsParams(
        modeName: event.modeName,
        settings: event.settings,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Mode settings error: $e',
      ));
    }
  }

  @override
  Future<void> close() {
    _climateSubscription?.cancel();
    _deviceFullStateSubscription?.cancel();
    _powerToggleTimer?.cancel();
    return super.close();
  }
}
