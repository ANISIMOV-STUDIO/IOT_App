/// Analytics Data Provider
///
/// Provides mock data for analytics screen
/// Extracted from analytics_screen.dart to respect 300-line limit
library;

import '../../domain/entities/temperature_reading.dart';

class AnalyticsDataProvider {
  /// Generate mock temperature data for the last 24 hours
  static List<TemperatureReading> generateTemperatureData() {
    final now = DateTime.now();
    return List.generate(24, (index) {
      return TemperatureReading(
        timestamp: now.subtract(Duration(hours: 23 - index)),
        temperature: 20.0 + (index % 5) * 0.8 + (index % 3) * 0.3,
      );
    });
  }

  /// Generate mock humidity data for the last 24 hours
  static List<TemperatureReading> generateHumidityData() {
    final now = DateTime.now();
    return List.generate(24, (index) {
      return TemperatureReading(
        timestamp: now.subtract(Duration(hours: 23 - index)),
        temperature: 45.0 + (index % 7) * 2.5,
      );
    });
  }

  /// Check if data is available
  static bool hasData(List<TemperatureReading> data) {
    return data.isNotEmpty;
  }
}