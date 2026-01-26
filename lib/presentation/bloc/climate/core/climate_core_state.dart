/// State for ClimateCoreBloc
///
/// Contains core device state: status, climate data, deviceFullState, sync status
library;

import 'package:equatable/equatable.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';

/// Loading status for ClimateCoreBloc
enum ClimateCoreStatus {
  /// Initial state
  initial,

  /// Loading climate state
  loading,

  /// Successful loading
  success,

  /// Loading error
  failure,
}

/// Core climate control state
final class ClimateCoreState extends Equatable {
  const ClimateCoreState({
    this.status = ClimateCoreStatus.initial,
    this.climate,
    this.deviceFullState,
    this.errorMessage,
    this.isSyncing = false,
  });

  /// Loading status
  final ClimateCoreStatus status;

  /// Current climate state
  final ClimateState? climate;

  /// Full device state (with alarms and settings)
  final DeviceFullState? deviceFullState;

  /// Error message
  final String? errorMessage;

  /// Sync indicator (for refresh animation)
  final bool isSyncing;

  // =============================================================================
  // CONVENIENCE GETTERS
  // =============================================================================

  /// Device is on
  bool get isOn => climate?.isOn ?? false;

  /// Current temperature
  double? get currentTemperature => climate?.currentTemperature;

  /// Target temperature
  double? get targetTemperature => climate?.targetTemperature;

  /// Humidity
  double? get humidity => climate?.humidity;

  /// Target humidity
  double? get targetHumidity => climate?.targetHumidity;

  /// Current mode
  ClimateMode? get mode => climate?.mode;

  /// Current preset
  String? get preset => climate?.preset;

  /// Supply airflow
  double? get supplyAirflow => climate?.supplyAirflow;

  /// Exhaust airflow
  double? get exhaustAirflow => climate?.exhaustAirflow;

  /// Air quality
  AirQualityLevel? get airQuality => climate?.airQuality;

  /// CO2 level
  int? get co2Ppm => climate?.co2Ppm;

  /// Has active alarms
  bool get hasAlarms => deviceFullState?.hasAlarms ?? false;

  /// Active alarm count
  int get alarmCount => deviceFullState?.alarmCount ?? 0;

  /// Active alarms
  Map<String, AlarmInfo> get activeAlarms =>
      deviceFullState?.activeAlarms ?? {};

  /// Schedule enabled
  bool get isScheduleEnabled => deviceFullState?.isScheduleEnabled ?? false;

  /// Device online
  bool get isOnline => deviceFullState?.isOnline ?? false;

  /// Current operating mode
  String get operatingMode => deviceFullState?.operatingMode ?? '';

  ClimateCoreState copyWith({
    ClimateCoreStatus? status,
    ClimateState? climate,
    DeviceFullState? deviceFullState,
    String? errorMessage,
    bool? isSyncing,
  }) => ClimateCoreState(
      status: status ?? this.status,
      climate: climate ?? this.climate,
      deviceFullState: deviceFullState ?? this.deviceFullState,
      errorMessage: errorMessage,
      isSyncing: isSyncing ?? this.isSyncing,
    );

  @override
  List<Object?> get props => [
        status,
        climate,
        deviceFullState,
        errorMessage,
        isSyncing,
      ];
}
