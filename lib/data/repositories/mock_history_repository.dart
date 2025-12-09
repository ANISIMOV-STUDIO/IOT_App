import 'dart:math';
import '../../domain/repositories/history_repository.dart';
import '../../domain/entities/temperature_reading.dart';

class MockHistoryRepository implements HistoryRepository {
  @override
  Future<List<TemperatureReading>> getTemperatureHistory(
    String deviceId, {
    required DateTime start,
    required DateTime end,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final List<TemperatureReading> readings = [];
    final duration = end.difference(start);
    final hours = duration.inHours;
    
    // Generate data points every hour
    // Use sine wave to simulate day/night cycle
    final random = Random();
    
    for (int i = 0; i <= hours; i++) {
      final time = start.add(Duration(hours: i));
      
      // Base temperature curve (coldest at 4am, hottest at 4pm)
      final hourOffset = (time.hour - 4) / 24.0 * 2 * pi;
      final baseTemp = 20.0 + 5 * sin(hourOffset - pi / 2);
      
      // Add some random noise
      final noise = (random.nextDouble() - 0.5) * 2;
      
      readings.add(TemperatureReading(
        timestamp: time,
        temperature: baseTemp + noise,
        humidity: 40 + 10 * random.nextDouble(),
      ));
    }
    
    return readings;
  }

  @override
  Future<List<double>> getEnergyConsumption(
    String deviceId, {
    required DateTime start,
    required DateTime end,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate daily consumption values
    final days = end.difference(start).inDays + 1;
    final List<double> consumption = [];
    final random = Random();
    
    for (int i = 0; i < days; i++) {
      // 5-15 kWh per day
      consumption.add(5.0 + 10 * random.nextDouble());
    }
    
    return consumption;
  }
}
