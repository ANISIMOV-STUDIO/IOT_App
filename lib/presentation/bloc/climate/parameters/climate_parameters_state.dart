/// State for ClimateParametersBloc
///
/// Contains temperature, fan, and mode pending state
library;

import 'package:equatable/equatable.dart';

/// Parameters control state
final class ClimateParametersState extends Equatable {
  const ClimateParametersState({
    this.isPendingHeatingTemperature = false,
    this.isPendingCoolingTemperature = false,
    this.isPendingSupplyFan = false,
    this.isPendingExhaustFan = false,
    this.isPendingOperatingMode = false,
    this.pendingHeatingTemp,
    this.pendingCoolingTemp,
    this.pendingSupplyFan,
    this.pendingExhaustFan,
    this.pendingOperatingMode,
    this.errorMessage,
  });

  /// Waiting for heating temperature confirmation
  final bool isPendingHeatingTemperature;

  /// Waiting for cooling temperature confirmation
  final bool isPendingCoolingTemperature;

  /// Waiting for supply fan confirmation
  final bool isPendingSupplyFan;

  /// Waiting for exhaust fan confirmation
  final bool isPendingExhaustFan;

  /// Waiting for operating mode confirmation
  final bool isPendingOperatingMode;

  /// Expected heating temperature value (null = no pending)
  final int? pendingHeatingTemp;

  /// Expected cooling temperature value (null = no pending)
  final int? pendingCoolingTemp;

  /// Expected supply fan value (null = no pending)
  final int? pendingSupplyFan;

  /// Expected exhaust fan value (null = no pending)
  final int? pendingExhaustFan;

  /// Expected operating mode (null = no pending)
  final String? pendingOperatingMode;

  /// Error message
  final String? errorMessage;

  ClimateParametersState copyWith({
    bool? isPendingHeatingTemperature,
    bool? isPendingCoolingTemperature,
    bool? isPendingSupplyFan,
    bool? isPendingExhaustFan,
    bool? isPendingOperatingMode,
    int? pendingHeatingTemp,
    bool clearPendingHeatingTemp = false,
    int? pendingCoolingTemp,
    bool clearPendingCoolingTemp = false,
    int? pendingSupplyFan,
    bool clearPendingSupplyFan = false,
    int? pendingExhaustFan,
    bool clearPendingExhaustFan = false,
    String? pendingOperatingMode,
    bool clearPendingOperatingMode = false,
    String? errorMessage,
  }) => ClimateParametersState(
      isPendingHeatingTemperature:
          isPendingHeatingTemperature ?? this.isPendingHeatingTemperature,
      isPendingCoolingTemperature:
          isPendingCoolingTemperature ?? this.isPendingCoolingTemperature,
      isPendingSupplyFan: isPendingSupplyFan ?? this.isPendingSupplyFan,
      isPendingExhaustFan: isPendingExhaustFan ?? this.isPendingExhaustFan,
      isPendingOperatingMode: isPendingOperatingMode ?? this.isPendingOperatingMode,
      pendingHeatingTemp: clearPendingHeatingTemp ? null : (pendingHeatingTemp ?? this.pendingHeatingTemp),
      pendingCoolingTemp: clearPendingCoolingTemp ? null : (pendingCoolingTemp ?? this.pendingCoolingTemp),
      pendingSupplyFan: clearPendingSupplyFan ? null : (pendingSupplyFan ?? this.pendingSupplyFan),
      pendingExhaustFan: clearPendingExhaustFan ? null : (pendingExhaustFan ?? this.pendingExhaustFan),
      pendingOperatingMode: clearPendingOperatingMode ? null : (pendingOperatingMode ?? this.pendingOperatingMode),
      errorMessage: errorMessage,
    );

  @override
  List<Object?> get props => [
        isPendingHeatingTemperature,
        isPendingCoolingTemperature,
        isPendingSupplyFan,
        isPendingExhaustFan,
        isPendingOperatingMode,
        pendingHeatingTemp,
        pendingCoolingTemp,
        pendingSupplyFan,
        pendingExhaustFan,
        pendingOperatingMode,
        errorMessage,
      ];
}
