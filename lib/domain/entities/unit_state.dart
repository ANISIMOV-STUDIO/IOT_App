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
  final int heatingTemp;
  final int coolingTemp;
  final int supplyFan;
  final int exhaustFan;
  final String mode;
  final int humidity;
  final int outsideTemp;
  final int filterPercent;
  final int airflowRate;

  // Новые датчики
  final int indoorTemp;              // Температура воздуха в помещении
  final int supplyTemp;              // Температура приточного воздуха
  final int supplyTempAfterRecup;    // Температура приточного воздуха после рекуператора
  final int co2Level;                // Концентрация CO2 (ppm)
  final int recuperatorEfficiency;   // Температурная эффективность рекуператора (%)
  final int freeCooling;             // Свободное охлаждение рекуператора (м³/ч)
  final int heaterPerformance;       // Производительность электрического нагревателя (%)
  final int coolerStatus;            // Статус охладителя (%)
  final int ductPressure;            // Давление в воздуховоде (Па)

  const UnitState({
    required this.id,
    required this.name,
    required this.power,
    required this.temp,
    this.heatingTemp = 21,
    this.coolingTemp = 24,
    required this.supplyFan,
    required this.exhaustFan,
    required this.mode,
    required this.humidity,
    required this.outsideTemp,
    required this.filterPercent,
    required this.airflowRate,
    this.indoorTemp = 22,
    this.supplyTemp = 20,
    this.supplyTempAfterRecup = 18,
    this.co2Level = 450,
    this.recuperatorEfficiency = 85,
    this.freeCooling = 0,
    this.heaterPerformance = 0,
    this.coolerStatus = 0,
    this.ductPressure = 120,
  });

  UnitState copyWith({
    String? id,
    String? name,
    bool? power,
    int? temp,
    int? heatingTemp,
    int? coolingTemp,
    int? supplyFan,
    int? exhaustFan,
    String? mode,
    int? humidity,
    int? outsideTemp,
    int? filterPercent,
    int? airflowRate,
    int? indoorTemp,
    int? supplyTemp,
    int? supplyTempAfterRecup,
    int? co2Level,
    int? recuperatorEfficiency,
    int? freeCooling,
    int? heaterPerformance,
    int? coolerStatus,
    int? ductPressure,
  }) {
    return UnitState(
      id: id ?? this.id,
      name: name ?? this.name,
      power: power ?? this.power,
      temp: temp ?? this.temp,
      heatingTemp: heatingTemp ?? this.heatingTemp,
      coolingTemp: coolingTemp ?? this.coolingTemp,
      supplyFan: supplyFan ?? this.supplyFan,
      exhaustFan: exhaustFan ?? this.exhaustFan,
      mode: mode ?? this.mode,
      humidity: humidity ?? this.humidity,
      outsideTemp: outsideTemp ?? this.outsideTemp,
      filterPercent: filterPercent ?? this.filterPercent,
      airflowRate: airflowRate ?? this.airflowRate,
      indoorTemp: indoorTemp ?? this.indoorTemp,
      supplyTemp: supplyTemp ?? this.supplyTemp,
      supplyTempAfterRecup: supplyTempAfterRecup ?? this.supplyTempAfterRecup,
      co2Level: co2Level ?? this.co2Level,
      recuperatorEfficiency: recuperatorEfficiency ?? this.recuperatorEfficiency,
      freeCooling: freeCooling ?? this.freeCooling,
      heaterPerformance: heaterPerformance ?? this.heaterPerformance,
      coolerStatus: coolerStatus ?? this.coolerStatus,
      ductPressure: ductPressure ?? this.ductPressure,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        power,
        temp,
        heatingTemp,
        coolingTemp,
        supplyFan,
        exhaustFan,
        mode,
        humidity,
        outsideTemp,
        filterPercent,
        airflowRate,
        indoorTemp,
        supplyTemp,
        supplyTempAfterRecup,
        co2Level,
        recuperatorEfficiency,
        freeCooling,
        heaterPerformance,
        coolerStatus,
        ductPressure,
      ];
}
