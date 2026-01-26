/// Climate BLoC - Barrel export for all climate-related BLoCs
///
/// This file provides a single import point for all climate BLoCs.
/// After the refactoring, ClimateBloc is split into 4 specialized BLoCs:
///
/// - ClimateCoreBloc: Lifecycle, SignalR, deviceFullState
/// - ClimatePowerBloc: Power + Schedule toggle
/// - ClimateParametersBloc: Temps, fans, modes
/// - ClimateAlarmsBloc: Alarm history and management
///
/// The old monolithic ClimateBloc (~1500 lines) has been replaced with
/// these smaller, focused BLoCs for better maintainability and testability.
library;

export 'alarms/climate_alarms_bloc.dart';
export 'climate_shared.dart';
export 'core/climate_core_bloc.dart';
export 'parameters/climate_parameters_bloc.dart';
export 'power/climate_power_bloc.dart';
