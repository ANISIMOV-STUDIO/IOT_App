/// Temperature Reading Model
///
/// Data model for Temperature Reading with JSON serialization
library;

import 'dart:convert';
import '../../domain/entities/temperature_reading.dart';

class TemperatureReadingModel extends TemperatureReading {
  const TemperatureReadingModel({
    required super.timestamp,
    required super.temperature,
  });

  /// Create from JSON
  factory TemperatureReadingModel.fromJson(Map<String, dynamic> json) {
    return TemperatureReadingModel(
      timestamp: DateTime.parse(json['timestamp'] as String),
      temperature: (json['temperature'] as num).toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
    };
  }

  /// Create from Entity
  factory TemperatureReadingModel.fromEntity(TemperatureReading entity) {
    return TemperatureReadingModel(
      timestamp: entity.timestamp,
      temperature: entity.temperature,
    );
  }

  /// Convert to Entity
  TemperatureReading toEntity() {
    return TemperatureReading(
      timestamp: timestamp,
      temperature: temperature,
    );
  }
}
