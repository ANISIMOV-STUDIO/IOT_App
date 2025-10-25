/// Temperature Reading Entity
///
/// Represents a single temperature reading for chart display
library;

import 'package:equatable/equatable.dart';

class TemperatureReading extends Equatable {
  final DateTime timestamp;
  final double temperature;

  const TemperatureReading({
    required this.timestamp,
    required this.temperature,
  });

  @override
  List<Object?> get props => [timestamp, temperature];

  @override
  String toString() {
    return 'TemperatureReading(timestamp: $timestamp, temperature: $temperature°C)';
  }
}
