/// ClimateParametersBloc - Temperature, fan, and mode management
///
/// Responsibilities:
/// - Temperature handlers (heating, cooling, humidity)
/// - Fan handlers (supply, exhaust)
/// - Mode handlers (operating mode, preset, settings)
/// - Timeout handlers
/// - SignalR confirmation handling
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_shared.dart';

import 'package:hvac_control/presentation/bloc/climate/parameters/climate_parameters_event.dart';
import 'package:hvac_control/presentation/bloc/climate/parameters/climate_parameters_state.dart';

export 'package:hvac_control/presentation/bloc/climate/parameters/climate_parameters_event.dart';
export 'package:hvac_control/presentation/bloc/climate/parameters/climate_parameters_state.dart';

/// Callback type for getting current quick mode params
typedef GetQuickModeParamsCallback = SetQuickModeParams? Function();

/// BLoC for temperature, fan, and mode control
class ClimateParametersBloc extends Bloc<ClimateParametersEvent, ClimateParametersState> {
  ClimateParametersBloc({
    required SetTemperature setTemperature,
    required SetCoolingTemperature setCoolingTemperature,
    required SetHumidity setHumidity,
    required SetClimateMode setClimateMode,
    required SetOperatingMode setOperatingMode,
    required SetPreset setPreset,
    required SetAirflow setAirflow,
    required SetModeSettings setModeSettings,
    required SetQuickMode setQuickMode,
    required GetQuickModeParamsCallback getQuickModeParams,
  })  : _setTemperature = setTemperature,
        _setCoolingTemperature = setCoolingTemperature,
        _setHumidity = setHumidity,
        _setClimateMode = setClimateMode,
        _setOperatingMode = setOperatingMode,
        _setPreset = setPreset,
        _setAirflow = setAirflow,
        _setModeSettings = setModeSettings,
        _setQuickMode = setQuickMode,
        _getQuickModeParams = getQuickModeParams,
        super(const ClimateParametersState()) {
    // Debug ID
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _blocId = timestamp.substring(timestamp.length - 4);
    developer.log('ClimateParametersBloc CREATED: blocId=$_blocId', name: 'ClimateParametersBloc');

    // Temperature events (instant UI update, API call via Commit)
    on<ClimateParametersTemperatureChanged>(_onTemperatureChanged, transformer: debounceRestartable());
    on<ClimateParametersHeatingTempChanged>(_onHeatingTempChanged);
    on<ClimateParametersHeatingTempCommit>(_onHeatingTempCommit, transformer: debounceRestartable());
    on<ClimateParametersCoolingTempChanged>(_onCoolingTempChanged);
    on<ClimateParametersCoolingTempCommit>(_onCoolingTempCommit, transformer: debounceRestartable());
    on<ClimateParametersHumidityChanged>(_onHumidityChanged);

    // Mode events
    on<ClimateParametersModeChanged>(_onModeChanged);
    on<ClimateParametersOperatingModeChanged>(_onOperatingModeChanged);
    on<ClimateParametersPresetChanged>(_onPresetChanged);

    // Fan events (instant UI update, API call via Commit)
    on<ClimateParametersSupplyAirflowChanged>(_onSupplyAirflowChanged);
    on<ClimateParametersSupplyAirflowCommit>(_onSupplyAirflowCommit, transformer: debounceRestartable());
    on<ClimateParametersExhaustAirflowChanged>(_onExhaustAirflowChanged);
    on<ClimateParametersExhaustAirflowCommit>(_onExhaustAirflowCommit, transformer: debounceRestartable());

    // Mode settings
    on<ClimateParametersModeSettingsChanged>(_onModeSettingsChanged);

    // Timeout handlers
    on<ClimateParametersHeatingTempTimeout>(_onHeatingTempTimeout);
    on<ClimateParametersCoolingTempTimeout>(_onCoolingTempTimeout);
    on<ClimateParametersSupplyFanTimeout>(_onSupplyFanTimeout);
    on<ClimateParametersExhaustFanTimeout>(_onExhaustFanTimeout);
    on<ClimateParametersOperatingModeTimeout>(_onOperatingModeTimeout);

    // SignalR confirmation
    on<ClimateParametersSignalRReceived>(_onSignalRReceived);

    // Reset
    on<ClimateParametersReset>(_onReset);
  }

  late final String _blocId;
  final SetTemperature _setTemperature;
  final SetCoolingTemperature _setCoolingTemperature;
  final SetHumidity _setHumidity;
  final SetClimateMode _setClimateMode;
  final SetOperatingMode _setOperatingMode;
  final SetPreset _setPreset;
  final SetAirflow _setAirflow;
  final SetModeSettings _setModeSettings;
  final SetQuickMode _setQuickMode;
  final GetQuickModeParamsCallback _getQuickModeParams;

  Timer? _heatingTempTimer;
  Timer? _coolingTempTimer;
  Timer? _supplyFanTimer;
  Timer? _exhaustFanTimer;
  Timer? _operatingModeTimer;

  // ==========================================================================
  // TEMPERATURE HANDLERS
  // ==========================================================================

  /// Legacy temperature change (for old API)
  Future<void> _onTemperatureChanged(
    ClimateParametersTemperatureChanged event,
    Emitter<ClimateParametersState> emit,
  ) async {
    try {
      await _setTemperature(SetTemperatureParams(temperature: event.temperature));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Temperature setting error: $e'));
    }
  }

  /// UI update: Heating temperature changed
  ///
  /// Save pendingHeatingTemp immediately (before debounce) so UI shows
  /// correct value even if SignalR overwrites modeSettings.
  void _onHeatingTempChanged(
    ClimateParametersHeatingTempChanged event,
    Emitter<ClimateParametersState> emit,
  ) {
    // Clamp temperature within limits
    final clampedTemp = event.temperature.clamp(
      TemperatureLimits.min,
      TemperatureLimits.max,
    );

    // Save pending value IMMEDIATELY, before debounce
    emit(state.copyWith(
      pendingHeatingTemp: clampedTemp,
    ));

    // Queue actual API request (with debounce)
    // Loader will appear in Commit after debounce
    add(ClimateParametersHeatingTempCommit(clampedTemp));
  }

  /// API call: Send heating temperature via quick-mode
  Future<void> _onHeatingTempCommit(
    ClimateParametersHeatingTempCommit event,
    Emitter<ClimateParametersState> emit,
  ) async {
    // Loader + expected value for SignalR comparison
    emit(state.copyWith(
      isPendingHeatingTemperature: true,
      pendingHeatingTemp: event.temperature,
    ));

    try {
      final params = _getQuickModeParams();
      if (params != null) {
        await _setQuickMode(params);
      } else {
        await _setTemperature(SetTemperatureParams(temperature: event.temperature.toDouble()));
      }

      // Timeout: if SignalR doesn't confirm in 10 seconds, reset pending
      _heatingTempTimer?.cancel();
      _heatingTempTimer = Timer(kParamChangeTimeout, () {
        if (!isClosed) {
          add(const ClimateParametersHeatingTempTimeout());
        }
      });
    } catch (e) {
      emit(state.copyWith(
        isPendingHeatingTemperature: false,
        clearPendingHeatingTemp: true,
        errorMessage: 'Heating temperature error: $e',
      ));
    }
  }

  /// UI update: Cooling temperature changed
  void _onCoolingTempChanged(
    ClimateParametersCoolingTempChanged event,
    Emitter<ClimateParametersState> emit,
  ) {
    // Clamp temperature within limits
    final clampedTemp = event.temperature.clamp(
      TemperatureLimits.min,
      TemperatureLimits.max,
    );

    // Save pending value IMMEDIATELY, before debounce
    emit(state.copyWith(
      pendingCoolingTemp: clampedTemp,
    ));

    // Queue actual API request (with debounce)
    add(ClimateParametersCoolingTempCommit(clampedTemp));
  }

  /// API call: Send cooling temperature via quick-mode
  Future<void> _onCoolingTempCommit(
    ClimateParametersCoolingTempCommit event,
    Emitter<ClimateParametersState> emit,
  ) async {
    // Loader + expected value for SignalR comparison
    emit(state.copyWith(
      isPendingCoolingTemperature: true,
      pendingCoolingTemp: event.temperature,
    ));

    try {
      final params = _getQuickModeParams();
      if (params != null) {
        await _setQuickMode(params);
      } else {
        await _setCoolingTemperature(SetCoolingTemperatureParams(temperature: event.temperature));
      }

      // Timeout: if SignalR doesn't confirm in 10 seconds, reset pending
      _coolingTempTimer?.cancel();
      _coolingTempTimer = Timer(kParamChangeTimeout, () {
        if (!isClosed) {
          add(const ClimateParametersCoolingTempTimeout());
        }
      });
    } catch (e) {
      emit(state.copyWith(
        isPendingCoolingTemperature: false,
        clearPendingCoolingTemp: true,
        errorMessage: 'Cooling temperature error: $e',
      ));
    }
  }

  /// Humidity change
  Future<void> _onHumidityChanged(
    ClimateParametersHumidityChanged event,
    Emitter<ClimateParametersState> emit,
  ) async {
    try {
      await _setHumidity(SetHumidityParams(humidity: event.humidity));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Humidity setting error: $e'));
    }
  }

  // ==========================================================================
  // FAN HANDLERS
  // ==========================================================================

  /// UI update: Supply airflow changed
  void _onSupplyAirflowChanged(
    ClimateParametersSupplyAirflowChanged event,
    Emitter<ClimateParametersState> emit,
  ) {
    // Save pending value IMMEDIATELY, before debounce
    emit(state.copyWith(
      pendingSupplyFan: event.value.round(),
    ));

    // Loader will appear in Commit after debounce
    add(ClimateParametersSupplyAirflowCommit(event.value));
  }

  /// API call: Send supply airflow via quick-mode
  Future<void> _onSupplyAirflowCommit(
    ClimateParametersSupplyAirflowCommit event,
    Emitter<ClimateParametersState> emit,
  ) async {
    // Loader + expected value for SignalR comparison
    emit(state.copyWith(
      isPendingSupplyFan: true,
      pendingSupplyFan: event.value.round(),
    ));

    try {
      final params = _getQuickModeParams();
      if (params != null) {
        await _setQuickMode(params);
      } else {
        await _setAirflow(SetAirflowParams(
          type: AirflowType.supply,
          value: event.value,
        ));
      }

      // Timeout: if SignalR doesn't confirm in 10 seconds, reset pending
      _supplyFanTimer?.cancel();
      _supplyFanTimer = Timer(kParamChangeTimeout, () {
        if (!isClosed) {
          add(const ClimateParametersSupplyFanTimeout());
        }
      });
    } catch (e) {
      emit(state.copyWith(
        isPendingSupplyFan: false,
        clearPendingSupplyFan: true,
        errorMessage: 'Supply airflow error: $e',
      ));
    }
  }

  /// UI update: Exhaust airflow changed
  void _onExhaustAirflowChanged(
    ClimateParametersExhaustAirflowChanged event,
    Emitter<ClimateParametersState> emit,
  ) {
    // Save pending value IMMEDIATELY, before debounce
    emit(state.copyWith(
      pendingExhaustFan: event.value.round(),
    ));

    // Loader will appear in Commit after debounce
    add(ClimateParametersExhaustAirflowCommit(event.value));
  }

  /// API call: Send exhaust airflow via quick-mode
  Future<void> _onExhaustAirflowCommit(
    ClimateParametersExhaustAirflowCommit event,
    Emitter<ClimateParametersState> emit,
  ) async {
    // Loader + expected value for SignalR comparison
    emit(state.copyWith(
      isPendingExhaustFan: true,
      pendingExhaustFan: event.value.round(),
    ));

    try {
      final params = _getQuickModeParams();
      if (params != null) {
        await _setQuickMode(params);
      } else {
        await _setAirflow(SetAirflowParams(
          type: AirflowType.exhaust,
          value: event.value,
        ));
      }

      // Timeout: if SignalR doesn't confirm in 10 seconds, reset pending
      _exhaustFanTimer?.cancel();
      _exhaustFanTimer = Timer(kParamChangeTimeout, () {
        if (!isClosed) {
          add(const ClimateParametersExhaustFanTimeout());
        }
      });
    } catch (e) {
      emit(state.copyWith(
        isPendingExhaustFan: false,
        clearPendingExhaustFan: true,
        errorMessage: 'Exhaust airflow error: $e',
      ));
    }
  }

  // ==========================================================================
  // MODE HANDLERS
  // ==========================================================================

  /// Climate mode change (enum: heating, cooling, auto, etc.)
  Future<void> _onModeChanged(
    ClimateParametersModeChanged event,
    Emitter<ClimateParametersState> emit,
  ) async {
    try {
      await _setClimateMode(SetClimateModeParams(mode: event.mode));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Mode change error: $e'));
    }
  }

  /// Operating mode change (String: basic, intensive, economy, etc.)
  Future<void> _onOperatingModeChanged(
    ClimateParametersOperatingModeChanged event,
    Emitter<ClimateParametersState> emit,
  ) async {
    developer.log(
      '[$_blocId] MODE CHANGE START: ${event.mode} at ${DateTime.now()}',
      name: 'ClimateParametersBloc',
    );

    // Loader + expected mode for SignalR comparison
    emit(state.copyWith(
      isPendingOperatingMode: true,
      pendingOperatingMode: event.mode,
    ));

    try {
      await _setOperatingMode(SetOperatingModeParams(mode: event.mode));

      // Timeout: if SignalR doesn't confirm in 10 seconds, reset pending
      _operatingModeTimer?.cancel();
      _operatingModeTimer = Timer(kParamChangeTimeout, () {
        if (!isClosed) {
          add(const ClimateParametersOperatingModeTimeout());
        }
      });
    } catch (e) {
      developer.log(
        '[$_blocId] MODE CHANGE ERROR: $e at ${DateTime.now()}',
        name: 'ClimateParametersBloc',
      );
      emit(state.copyWith(
        isPendingOperatingMode: false,
        clearPendingOperatingMode: true,
        errorMessage: 'Operating mode error: $e',
      ));
    }
  }

  /// Preset change
  Future<void> _onPresetChanged(
    ClimateParametersPresetChanged event,
    Emitter<ClimateParametersState> emit,
  ) async {
    try {
      await _setPreset(SetPresetParams(preset: event.preset));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Preset change error: $e'));
    }
  }

  /// Mode settings change (temperatures and fan speeds)
  Future<void> _onModeSettingsChanged(
    ClimateParametersModeSettingsChanged event,
    Emitter<ClimateParametersState> emit,
  ) async {
    try {
      await _setModeSettings(SetModeSettingsParams(
        modeName: event.modeName,
        settings: event.settings,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Mode settings error: $e'));
    }
  }

  // ==========================================================================
  // TIMEOUT HANDLERS
  // ==========================================================================

  void _onHeatingTempTimeout(
    ClimateParametersHeatingTempTimeout event,
    Emitter<ClimateParametersState> emit,
  ) {
    if (state.isPendingHeatingTemperature) {
      developer.log(
        '[$_blocId] _onHeatingTempTimeout: SignalR did not confirm value',
        name: 'ClimateParametersBloc',
      );
      emit(state.copyWith(
        isPendingHeatingTemperature: false,
        clearPendingHeatingTemp: true,
      ));
    }
  }

  void _onCoolingTempTimeout(
    ClimateParametersCoolingTempTimeout event,
    Emitter<ClimateParametersState> emit,
  ) {
    if (state.isPendingCoolingTemperature) {
      developer.log(
        '[$_blocId] _onCoolingTempTimeout: SignalR did not confirm value',
        name: 'ClimateParametersBloc',
      );
      emit(state.copyWith(
        isPendingCoolingTemperature: false,
        clearPendingCoolingTemp: true,
      ));
    }
  }

  void _onSupplyFanTimeout(
    ClimateParametersSupplyFanTimeout event,
    Emitter<ClimateParametersState> emit,
  ) {
    if (state.isPendingSupplyFan) {
      developer.log(
        '[$_blocId] _onSupplyFanTimeout: SignalR did not confirm value',
        name: 'ClimateParametersBloc',
      );
      emit(state.copyWith(
        isPendingSupplyFan: false,
        clearPendingSupplyFan: true,
      ));
    }
  }

  void _onExhaustFanTimeout(
    ClimateParametersExhaustFanTimeout event,
    Emitter<ClimateParametersState> emit,
  ) {
    if (state.isPendingExhaustFan) {
      developer.log(
        '[$_blocId] _onExhaustFanTimeout: SignalR did not confirm value',
        name: 'ClimateParametersBloc',
      );
      emit(state.copyWith(
        isPendingExhaustFan: false,
        clearPendingExhaustFan: true,
      ));
    }
  }

  void _onOperatingModeTimeout(
    ClimateParametersOperatingModeTimeout event,
    Emitter<ClimateParametersState> emit,
  ) {
    if (state.isPendingOperatingMode) {
      developer.log(
        '[$_blocId] _onOperatingModeTimeout: SignalR did not confirm value',
        name: 'ClimateParametersBloc',
      );
      emit(state.copyWith(
        isPendingOperatingMode: false,
        clearPendingOperatingMode: true,
      ));
    }
  }

  // ==========================================================================
  // SIGNALR CONFIRMATION
  // ==========================================================================

  void _onSignalRReceived(
    ClimateParametersSignalRReceived event,
    Emitter<ClimateParametersState> emit,
  ) {
    // Get current values from incoming modeSettings
    final currentMode = event.operatingMode;
    final incomingSettings = event.modeSettings?[currentMode];
    final incomingHeating = incomingSettings?.heatingTemperature;
    final incomingCooling = incomingSettings?.coolingTemperature;
    final incomingSupply = incomingSettings?.supplyFan;
    final incomingExhaust = incomingSettings?.exhaustFan;

    // Check confirmation for each pending value
    // Reset ONLY if pending was set AND value matches
    final heatingConfirmed = state.pendingHeatingTemp != null &&
        incomingHeating == state.pendingHeatingTemp;

    final coolingConfirmed = state.pendingCoolingTemp != null &&
        incomingCooling == state.pendingCoolingTemp;

    final supplyConfirmed = state.pendingSupplyFan != null &&
        incomingSupply == state.pendingSupplyFan;

    final exhaustConfirmed = state.pendingExhaustFan != null &&
        incomingExhaust == state.pendingExhaustFan;

    // Check operating mode confirmation
    final operatingModeConfirmed = state.pendingOperatingMode != null &&
        currentMode.toLowerCase() == state.pendingOperatingMode!.toLowerCase();

    developer.log(
      '[$_blocId] SIGNALR MODE: $currentMode, pending: ${state.pendingOperatingMode}, '
      'confirmed: $operatingModeConfirmed at ${DateTime.now()}',
      name: 'ClimateParametersBloc',
    );

    // Cancel timers on confirmation
    if (heatingConfirmed) {
      _heatingTempTimer?.cancel();
      _heatingTempTimer = null;
    }
    if (coolingConfirmed) {
      _coolingTempTimer?.cancel();
      _coolingTempTimer = null;
    }
    if (supplyConfirmed) {
      _supplyFanTimer?.cancel();
      _supplyFanTimer = null;
    }
    if (exhaustConfirmed) {
      _exhaustFanTimer?.cancel();
      _exhaustFanTimer = null;
    }
    if (operatingModeConfirmed) {
      _operatingModeTimer?.cancel();
      _operatingModeTimer = null;
    }

    emit(state.copyWith(
      // Reset pending flags only when SignalR confirmed our value
      isPendingHeatingTemperature: heatingConfirmed ? false : null,
      clearPendingHeatingTemp: heatingConfirmed,
      isPendingCoolingTemperature: coolingConfirmed ? false : null,
      clearPendingCoolingTemp: coolingConfirmed,
      isPendingSupplyFan: supplyConfirmed ? false : null,
      clearPendingSupplyFan: supplyConfirmed,
      isPendingExhaustFan: exhaustConfirmed ? false : null,
      clearPendingExhaustFan: exhaustConfirmed,
      isPendingOperatingMode: operatingModeConfirmed ? false : null,
      clearPendingOperatingMode: operatingModeConfirmed,
    ));
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  void _onReset(
    ClimateParametersReset event,
    Emitter<ClimateParametersState> emit,
  ) {
    _heatingTempTimer?.cancel();
    _heatingTempTimer = null;
    _coolingTempTimer?.cancel();
    _coolingTempTimer = null;
    _supplyFanTimer?.cancel();
    _supplyFanTimer = null;
    _exhaustFanTimer?.cancel();
    _exhaustFanTimer = null;
    _operatingModeTimer?.cancel();
    _operatingModeTimer = null;

    emit(const ClimateParametersState());
  }

  @override
  Future<void> close() async {
    developer.log('ClimateParametersBloc CLOSED: blocId=$_blocId', name: 'ClimateParametersBloc');

    _heatingTempTimer?.cancel();
    _coolingTempTimer?.cancel();
    _supplyFanTimer?.cancel();
    _exhaustFanTimer?.cancel();
    _operatingModeTimer?.cancel();

    return super.close();
  }
}
