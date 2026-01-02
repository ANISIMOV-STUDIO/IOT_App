/// Unit State Entity - Представляет состояние HVAC юнита
///
/// Чистая доменная сущность без зависимостей от сериализации.
/// Сериализация выполняется в Data Layer через UnitStateModel.
library;

import 'package:equatable/equatable.dart';

/// Неизменяемое состояние HVAC юнита
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
