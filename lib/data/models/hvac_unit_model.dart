/// HVAC Unit Model
///
/// Data model for HVAC Unit with JSON serialization
library;

import 'dart:convert';
import '../../domain/entities/hvac_unit.dart';

class HvacUnitModel extends HvacUnit {
  const HvacUnitModel({
    required super.id,
    required super.name,
    required super.power,
    required super.currentTemp,
    required super.targetTemp,
    required super.mode,
    required super.fanSpeed,
    required super.timestamp,
    super.macAddress,
  });

  /// Create from JSON
  factory HvacUnitModel.fromJson(Map<String, dynamic> json) {
    return HvacUnitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      power: json['power'] as bool,
      currentTemp: (json['currentTemp'] as num).toDouble(),
      targetTemp: (json['targetTemp'] as num).toDouble(),
      mode: json['mode'] as String,
      fanSpeed: json['fanSpeed'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      macAddress: json['macAddress'] as String?,
    );
  }

  /// Create from JSON string
  factory HvacUnitModel.fromJsonString(String jsonString) {
    return HvacUnitModel.fromJson(json.decode(jsonString));
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'power': power,
      'currentTemp': currentTemp,
      'targetTemp': targetTemp,
      'mode': mode,
      'fanSpeed': fanSpeed,
      'timestamp': timestamp.toIso8601String(),
      if (macAddress != null) 'macAddress': macAddress,
    };
  }

  /// Convert to JSON string
  String toJsonString() {
    return json.encode(toJson());
  }

  /// Create from Entity
  factory HvacUnitModel.fromEntity(HvacUnit entity) {
    return HvacUnitModel(
      id: entity.id,
      name: entity.name,
      power: entity.power,
      currentTemp: entity.currentTemp,
      targetTemp: entity.targetTemp,
      mode: entity.mode,
      fanSpeed: entity.fanSpeed,
      timestamp: entity.timestamp,
      macAddress: entity.macAddress,
    );
  }

  /// Convert to Entity
  HvacUnit toEntity() {
    return HvacUnit(
      id: id,
      name: name,
      power: power,
      currentTemp: currentTemp,
      targetTemp: targetTemp,
      mode: mode,
      fanSpeed: fanSpeed,
      timestamp: timestamp,
      macAddress: macAddress,
    );
  }
}
