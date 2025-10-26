/// HVAC Unit Entity
///
/// Core business object representing a single HVAC unit
library;

import 'package:equatable/equatable.dart';

class HvacUnit extends Equatable {
  final String id;
  final String name;
  final bool power;
  final double currentTemp;
  final double targetTemp;
  final String mode; // cooling, heating, fan, auto
  final String fanSpeed; // low, medium, high, auto
  final DateTime timestamp;
  final String? macAddress; // MAC address of the device

  const HvacUnit({
    required this.id,
    required this.name,
    required this.power,
    required this.currentTemp,
    required this.targetTemp,
    required this.mode,
    required this.fanSpeed,
    required this.timestamp,
    this.macAddress,
  });

  /// Create a copy with updated fields
  HvacUnit copyWith({
    String? id,
    String? name,
    bool? power,
    double? currentTemp,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
    DateTime? timestamp,
    String? macAddress,
  }) {
    return HvacUnit(
      id: id ?? this.id,
      name: name ?? this.name,
      power: power ?? this.power,
      currentTemp: currentTemp ?? this.currentTemp,
      targetTemp: targetTemp ?? this.targetTemp,
      mode: mode ?? this.mode,
      fanSpeed: fanSpeed ?? this.fanSpeed,
      timestamp: timestamp ?? this.timestamp,
      macAddress: macAddress ?? this.macAddress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        power,
        currentTemp,
        targetTemp,
        mode,
        fanSpeed,
        timestamp,
        macAddress,
      ];

  @override
  String toString() {
    return 'HvacUnit(id: $id, name: $name, power: $power, currentTemp: $currentTemp°C, targetTemp: $targetTemp°C, mode: $mode, fanSpeed: $fanSpeed)';
  }
}
