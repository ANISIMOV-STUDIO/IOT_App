/// Climate State Provider - Interface for climate state access
library;

import 'package:hvac_control/domain/entities/climate.dart';

/// Interface for climate state data access
abstract class ClimateStateProvider {
  /// Get state of a specific device
  Future<ClimateState> getDeviceState(String deviceId);

  /// Watch for climate updates of a specific device
  Stream<ClimateState> watchDeviceClimate(String deviceId);

  /// Get current state (selected device) - legacy support
  Future<ClimateState> getCurrentState();

  /// Watch current climate (selected device) - legacy support
  Stream<ClimateState> watchClimate();
}
