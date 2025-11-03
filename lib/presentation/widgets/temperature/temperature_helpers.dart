/// Temperature calculation utilities for HVAC system monitoring
///
/// Provides helper methods for temperature delta calculations,
/// efficiency measurements, and system status checks.
library;

class TemperatureHelpers {
  const TemperatureHelpers._();

  /// Checks if all primary temperature data is available
  static bool hasAllData(double? supplyTemp, double? extractTemp) {
    return supplyTemp != null && extractTemp != null;
  }

  /// Checks if secondary temperature data is available
  static bool hasSecondaryData(double? outdoorTemp, double? indoorTemp) {
    return outdoorTemp != null || indoorTemp != null;
  }

  /// Determines if the system is operating within normal parameters
  /// Normal operation is defined as temperature delta < 15°C
  static bool isSystemNormal(double? supplyTemp, double? extractTemp) {
    if (supplyTemp == null || extractTemp == null) return true;
    final delta = (supplyTemp - extractTemp).abs();
    return delta < 15.0;
  }

  /// Calculates the temperature difference between supply and extract air
  static double? getTempDelta(double? supplyTemp, double? extractTemp) {
    if (supplyTemp == null || extractTemp == null) return null;
    return (supplyTemp - extractTemp).abs();
  }

  /// Calculates the heat recovery efficiency as a percentage
  ///
  /// Efficiency = (Recovered Temperature / Total Temperature Difference) × 100
  /// where:
  /// - Recovered Temperature = |Supply - Outdoor|
  /// - Total Temperature Difference = |Extract - Outdoor|
  static double? getEfficiency(
    double? supplyTemp,
    double? extractTemp,
    double? outdoorTemp,
  ) {
    if (supplyTemp == null || extractTemp == null || outdoorTemp == null) {
      return null;
    }

    if (outdoorTemp == supplyTemp) return 100.0;

    final tempDiff = (extractTemp - outdoorTemp).abs();
    if (tempDiff == 0) return 0.0;

    final recovered = (supplyTemp - outdoorTemp).abs();
    return (recovered / tempDiff * 100).clamp(0.0, 100.0);
  }
}