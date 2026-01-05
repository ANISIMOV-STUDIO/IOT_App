/// UnitState Model (DTO) для Data Layer
///
/// Отвечает за сериализацию/десериализацию UnitState.
/// Domain Entity UnitState не знает про JSON.
library;

import '../../domain/entities/unit_state.dart';

/// DTO для состояния юнита
class UnitStateModel {
  final String id;
  final String name;
  final bool power;
  final int temp;
  final int heatingTemp;
  final int coolingTemp;
  final int supplyFan;
  final int exhaustFan;
  final String mode;
  final int humidity;
  final int outsideTemp;
  final int filterPercent;
  final int airflowRate;

  const UnitStateModel({
    required this.id,
    required this.name,
    required this.power,
    required this.temp,
    required this.heatingTemp,
    required this.coolingTemp,
    required this.supplyFan,
    required this.exhaustFan,
    required this.mode,
    required this.humidity,
    required this.outsideTemp,
    required this.filterPercent,
    required this.airflowRate,
  });

  /// Десериализация из JSON
  factory UnitStateModel.fromJson(Map<String, dynamic> json) {
    return UnitStateModel(
      id: json['id'] as String? ?? 'unknown',
      name: json['name'] as String? ?? 'Unit',
      power: json['power'] as bool? ?? false,
      temp: json['temp'] as int? ?? 22,
      heatingTemp: json['heatingTemperature'] as int? ?? 21,
      coolingTemp: json['coolingTemperature'] as int? ?? 24,
      supplyFan: json['supplyFan'] as int? ?? 50,
      exhaustFan: json['exhaustFan'] as int? ?? 50,
      mode: json['mode'] as String? ?? 'auto',
      humidity: json['humidity'] as int? ?? 45,
      outsideTemp: json['outsideTemp'] as int? ?? 18,
      filterPercent: json['filterPercent'] as int? ?? 85,
      airflowRate: json['airflowRate'] as int? ?? 250,
    );
  }

  /// Сериализация в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'power': power,
      'temp': temp,
      'heatingTemperature': heatingTemp,
      'coolingTemperature': coolingTemp,
      'supplyFan': supplyFan,
      'exhaustFan': exhaustFan,
      'mode': mode,
      'humidity': humidity,
      'outsideTemp': outsideTemp,
      'filterPercent': filterPercent,
      'airflowRate': airflowRate,
    };
  }

  /// Преобразование в Domain Entity
  UnitState toEntity() {
    return UnitState(
      id: id,
      name: name,
      power: power,
      temp: temp,
      heatingTemp: heatingTemp,
      coolingTemp: coolingTemp,
      supplyFan: supplyFan,
      exhaustFan: exhaustFan,
      mode: mode,
      humidity: humidity,
      outsideTemp: outsideTemp,
      filterPercent: filterPercent,
      airflowRate: airflowRate,
    );
  }

  /// Создание из Domain Entity
  factory UnitStateModel.fromEntity(UnitState state) {
    return UnitStateModel(
      id: state.id,
      name: state.name,
      power: state.power,
      temp: state.temp,
      heatingTemp: state.heatingTemp,
      coolingTemp: state.coolingTemp,
      supplyFan: state.supplyFan,
      exhaustFan: state.exhaustFan,
      mode: state.mode,
      humidity: state.humidity,
      outsideTemp: state.outsideTemp,
      filterPercent: state.filterPercent,
      airflowRate: state.airflowRate,
    );
  }
}
