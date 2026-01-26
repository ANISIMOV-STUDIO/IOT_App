/// Events for ClimateParametersBloc
///
/// Handles temperature, fan, and mode changes
library;

import 'package:equatable/equatable.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';

/// Base event for ClimateParametersBloc
sealed class ClimateParametersEvent extends Equatable {
  const ClimateParametersEvent();

  @override
  List<Object?> get props => [];
}

// =============================================================================
// TEMPERATURE EVENTS
// =============================================================================

/// Heating temperature changed (UI update)
final class ClimateParametersHeatingTempChanged extends ClimateParametersEvent {
  const ClimateParametersHeatingTempChanged(this.temperature);
  final int temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Heating temperature commit (API call after debounce)
final class ClimateParametersHeatingTempCommit extends ClimateParametersEvent {
  const ClimateParametersHeatingTempCommit(this.temperature);
  final int temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Heating temperature timeout
final class ClimateParametersHeatingTempTimeout extends ClimateParametersEvent {
  const ClimateParametersHeatingTempTimeout();
}

/// Cooling temperature changed (UI update)
final class ClimateParametersCoolingTempChanged extends ClimateParametersEvent {
  const ClimateParametersCoolingTempChanged(this.temperature);
  final int temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Cooling temperature commit (API call after debounce)
final class ClimateParametersCoolingTempCommit extends ClimateParametersEvent {
  const ClimateParametersCoolingTempCommit(this.temperature);
  final int temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Cooling temperature timeout
final class ClimateParametersCoolingTempTimeout extends ClimateParametersEvent {
  const ClimateParametersCoolingTempTimeout();
}

/// Legacy temperature change (for old API)
final class ClimateParametersTemperatureChanged extends ClimateParametersEvent {
  const ClimateParametersTemperatureChanged(this.temperature);
  final double temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Humidity changed
final class ClimateParametersHumidityChanged extends ClimateParametersEvent {
  const ClimateParametersHumidityChanged(this.humidity);
  final double humidity;

  @override
  List<Object?> get props => [humidity];
}

// =============================================================================
// FAN EVENTS
// =============================================================================

/// Supply airflow changed (UI update)
final class ClimateParametersSupplyAirflowChanged extends ClimateParametersEvent {
  const ClimateParametersSupplyAirflowChanged(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

/// Supply airflow commit (API call after debounce)
final class ClimateParametersSupplyAirflowCommit extends ClimateParametersEvent {
  const ClimateParametersSupplyAirflowCommit(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

/// Supply fan timeout
final class ClimateParametersSupplyFanTimeout extends ClimateParametersEvent {
  const ClimateParametersSupplyFanTimeout();
}

/// Exhaust airflow changed (UI update)
final class ClimateParametersExhaustAirflowChanged extends ClimateParametersEvent {
  const ClimateParametersExhaustAirflowChanged(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

/// Exhaust airflow commit (API call after debounce)
final class ClimateParametersExhaustAirflowCommit extends ClimateParametersEvent {
  const ClimateParametersExhaustAirflowCommit(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

/// Exhaust fan timeout
final class ClimateParametersExhaustFanTimeout extends ClimateParametersEvent {
  const ClimateParametersExhaustFanTimeout();
}

// =============================================================================
// MODE EVENTS
// =============================================================================

/// Climate mode changed (heating, cooling, auto, etc.)
final class ClimateParametersModeChanged extends ClimateParametersEvent {
  const ClimateParametersModeChanged(this.mode);
  final ClimateMode mode;

  @override
  List<Object?> get props => [mode];
}

/// Operating mode changed (basic, intensive, economy, etc.)
final class ClimateParametersOperatingModeChanged extends ClimateParametersEvent {
  const ClimateParametersOperatingModeChanged(this.mode);
  final String mode;

  @override
  List<Object?> get props => [mode];
}

/// Operating mode timeout
final class ClimateParametersOperatingModeTimeout extends ClimateParametersEvent {
  const ClimateParametersOperatingModeTimeout();
}

/// Preset changed
final class ClimateParametersPresetChanged extends ClimateParametersEvent {
  const ClimateParametersPresetChanged(this.preset);
  final String preset;

  @override
  List<Object?> get props => [preset];
}

/// Mode settings changed (temperatures and fan speeds for specific mode)
final class ClimateParametersModeSettingsChanged extends ClimateParametersEvent {
  const ClimateParametersModeSettingsChanged({
    required this.modeName,
    required this.settings,
  });

  final String modeName;
  final ModeSettings settings;

  @override
  List<Object?> get props => [modeName, settings];
}

// =============================================================================
// SIGNALR CONFIRMATION
// =============================================================================

/// SignalR confirmation received for parameters
final class ClimateParametersSignalRReceived extends ClimateParametersEvent {
  const ClimateParametersSignalRReceived({
    required this.operatingMode,
    required this.modeSettings,
  });
  final String operatingMode;
  final Map<String, ModeSettings>? modeSettings;

  @override
  List<Object?> get props => [operatingMode, modeSettings];
}

// =============================================================================
// RESET
// =============================================================================

/// Reset parameters bloc state (on device change)
final class ClimateParametersReset extends ClimateParametersEvent {
  const ClimateParametersReset();
}
