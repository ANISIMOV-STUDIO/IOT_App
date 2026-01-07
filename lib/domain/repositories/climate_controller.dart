/// Climate Controller - Interface for climate control operations
library;

import '../entities/climate.dart';

/// Interface for climate control operations
abstract class ClimateController {
  /// Turn device on/off
  Future<ClimateState> setPower(bool isOn, {String? deviceId});

  /// Set target temperature (defaults to heating)
  Future<ClimateState> setTargetTemperature(double temperature, {String? deviceId});

  /// Set heating temperature
  Future<ClimateState> setHeatingTemperature(int temperature, {String? deviceId});

  /// Set cooling temperature
  Future<ClimateState> setCoolingTemperature(int temperature, {String? deviceId});

  /// Set target humidity
  Future<ClimateState> setHumidity(double humidity, {String? deviceId});

  /// Set climate mode
  Future<ClimateState> setMode(ClimateMode mode, {String? deviceId});

  /// Set supply airflow (0-100%)
  Future<ClimateState> setSupplyAirflow(double value, {String? deviceId});

  /// Set exhaust airflow (0-100%)
  Future<ClimateState> setExhaustAirflow(double value, {String? deviceId});

  /// Set preset (auto, night, turbo, eco, away)
  Future<ClimateState> setPreset(String preset, {String? deviceId});
}
