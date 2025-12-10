/// Temperature Reading Model
///
/// Data model for Temperature Reading with JSON serialization
library;

import '../../domain/entities/temperature_reading.dart';

class TemperatureReadingModel extends TemperatureReading {
  const TemperatureReadingModel({
    required super.timestamp,
    required super.temperature,
    required super.humidity,
  });

  /// Create from JSON
  factory TemperatureReadingModel.fromJson(Map<String, dynamic> json) {
    return TemperatureReadingModel(
      timestamp: DateTime.parse(json['timestamp'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
    };
  }

  /// Create from Entity
  factory TemperatureReadingModel.fromEntity(TemperatureReading entity) {
    return TemperatureReadingModel(
      timestamp: entity.timestamp,
      temperature: entity.temperature,
      humidity: entity.humidity,
    );
  }

  /// Convert to Entity
  TemperatureReading toEntity() {
    return TemperatureReading(
      timestamp: timestamp,
      temperature: temperature,
      humidity: humidity,
    );
  }

  TemperatureReadingModel copyWith({
    DateTime? timestamp,
    double? temperature,
    double? humidity,
  }) {
    return TemperatureReadingModel(
      timestamp: timestamp ?? this.timestamp,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
    );
  }
}
