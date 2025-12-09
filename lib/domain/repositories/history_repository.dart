import '../entities/temperature_reading.dart';

abstract class HistoryRepository {
  /// Get temperature history for a specific device
  Future<List<TemperatureReading>> getTemperatureHistory(
    String deviceId, {
    required DateTime start,
    required DateTime end,
  });

  /// Get energy consumption history (kWh)
  Future<List<double>> getEnergyConsumption(
    String deviceId, {
    required DateTime start,
    required DateTime end,
  });
}
