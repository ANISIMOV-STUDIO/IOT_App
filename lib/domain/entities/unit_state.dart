/// Unit State Entity - Represents HVAC unit state
library;

import 'package:equatable/equatable.dart';

/// Immutable HVAC unit state
class UnitState extends Equatable {
  final String id;
  final String name;
  final bool power;
  final int temp;
  final int supplyFan;
  final int exhaustFan;
  final String mode;
  final int humidity;
  final int outsideTemp;
  final int filterPercent;
  final int airflowRate;

  const UnitState({
    required this.id,
    required this.name,
    required this.power,
    required this.temp,
    required this.supplyFan,
    required this.exhaustFan,
    required this.mode,
    required this.humidity,
    required this.outsideTemp,
    required this.filterPercent,
    required this.airflowRate,
  });

  factory UnitState.fromJson(Map<String, dynamic> json) {
    return UnitState(
      id: json['id'] as String,
      name: json['name'] as String,
      power: json['power'] as bool,
      temp: json['temp'] as int,
      supplyFan: json['supplyFan'] as int,
      exhaustFan: json['exhaustFan'] as int,
      mode: json['mode'] as String,
      humidity: json['humidity'] as int,
      outsideTemp: json['outsideTemp'] as int,
      filterPercent: json['filterPercent'] as int,
      airflowRate: json['airflowRate'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'power': power,
      'temp': temp,
      'supplyFan': supplyFan,
      'exhaustFan': exhaustFan,
      'mode': mode,
      'humidity': humidity,
      'outsideTemp': outsideTemp,
      'filterPercent': filterPercent,
      'airflowRate': airflowRate,
    };
  }

  UnitState copyWith({
    String? id,
    String? name,
    bool? power,
    int? temp,
    int? supplyFan,
    int? exhaustFan,
    String? mode,
    int? humidity,
    int? outsideTemp,
    int? filterPercent,
    int? airflowRate,
  }) {
    return UnitState(
      id: id ?? this.id,
      name: name ?? this.name,
      power: power ?? this.power,
      temp: temp ?? this.temp,
      supplyFan: supplyFan ?? this.supplyFan,
      exhaustFan: exhaustFan ?? this.exhaustFan,
      mode: mode ?? this.mode,
      humidity: humidity ?? this.humidity,
      outsideTemp: outsideTemp ?? this.outsideTemp,
      filterPercent: filterPercent ?? this.filterPercent,
      airflowRate: airflowRate ?? this.airflowRate,
    );
  }

  /// Creates a default new unit
  factory UnitState.create({required String name}) {
    return UnitState(
      id: 'unit_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      power: false,
      temp: 22,
      supplyFan: 50,
      exhaustFan: 50,
      mode: 'auto',
      humidity: 45,
      outsideTemp: 18,
      filterPercent: 100,
      airflowRate: 420,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        power,
        temp,
        supplyFan,
        exhaustFan,
        mode,
        humidity,
        outsideTemp,
        filterPercent,
        airflowRate,
      ];
}
