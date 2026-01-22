/// Unit State Entity - Представляет состояние HVAC юнита
///
/// Чистая доменная сущность без зависимостей от сериализации.
/// Сериализация выполняется в Data Layer через UnitStateModel.
library;

import 'package:equatable/equatable.dart';

/// Неизменяемое состояние HVAC юнита
class UnitState extends Equatable {        // Текущее время устройства

  const UnitState({
    required this.id,
    required this.name,
    required this.power,
    required this.temp,
    required this.mode,
    required this.humidity,
    required this.outsideTemp,
    required this.filterPercent,
    this.macAddress = '',
    this.heatingTemp,
    this.coolingTemp,
    this.supplyFan,
    this.exhaustFan,
    this.indoorTemp = 22.0,
    this.supplyTemp = 20.0,
    this.supplyTempAfterRecup = 18.0,
    this.co2Level = 450,
    this.recuperatorEfficiency = 85,
    this.freeCooling = false,
    this.heaterPower = 0,
    this.coolerStatus = 'Н/Д',
    this.ductPressure = 120,
    this.isOnline = true,
    this.quickSensors = const ['outside_temp', 'indoor_temp', 'humidity'],
    this.deviceTime,
    this.updatedAt,
  });
  final String id;
  final String name;
  final String macAddress;
  final bool power;
  final int temp;
  final int? heatingTemp;
  final int? coolingTemp;
  final int? supplyFan;
  final int? exhaustFan;
  final String mode;
  final int humidity;
  final double outsideTemp;
  final int filterPercent;

  // Новые датчики
  final double indoorTemp;              // Температура воздуха в помещении
  final double supplyTemp;              // Температура приточного воздуха
  final double supplyTempAfterRecup;    // Температура приточного воздуха после рекуператора
  final int co2Level;                // Концентрация CO2 (ppm)
  final int recuperatorEfficiency;   // Температурная эффективность рекуператора (%)
  final bool freeCooling;            // Свободное охлаждение рекуператора (Вкл/Выкл)
  final int heaterPower;             // Мощность работы нагревателя (%)
  final String coolerStatus;            // Статус охладителя
  final int ductPressure;            // Давление в воздуховоде (Па)
  final bool isOnline;                // Устройство онлайн
  final List<String> quickSensors;   // Быстрые показатели на главном экране
  final DateTime? deviceTime;        // Текущее время устройства
  final DateTime? updatedAt;         // Время последней синхронизации

  UnitState copyWith({
    String? id,
    String? name,
    String? macAddress,
    bool? power,
    int? temp,
    int? heatingTemp,
    int? coolingTemp,
    int? supplyFan,
    int? exhaustFan,
    String? mode,
    int? humidity,
    double? outsideTemp,
    int? filterPercent,
    double? indoorTemp,
    double? supplyTemp,
    double? supplyTempAfterRecup,
    int? co2Level,
    int? recuperatorEfficiency,
    bool? freeCooling,
    int? heaterPower,
    String? coolerStatus,
    int? ductPressure,
    bool? isOnline,
    List<String>? quickSensors,
    DateTime? deviceTime,
    DateTime? updatedAt,
  }) => UnitState(
      id: id ?? this.id,
      name: name ?? this.name,
      macAddress: macAddress ?? this.macAddress,
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
      indoorTemp: indoorTemp ?? this.indoorTemp,
      supplyTemp: supplyTemp ?? this.supplyTemp,
      supplyTempAfterRecup: supplyTempAfterRecup ?? this.supplyTempAfterRecup,
      co2Level: co2Level ?? this.co2Level,
      recuperatorEfficiency: recuperatorEfficiency ?? this.recuperatorEfficiency,
      freeCooling: freeCooling ?? this.freeCooling,
      heaterPower: heaterPower ?? this.heaterPower,
      coolerStatus: coolerStatus ?? this.coolerStatus,
      ductPressure: ductPressure ?? this.ductPressure,
      isOnline: isOnline ?? this.isOnline,
      quickSensors: quickSensors ?? this.quickSensors,
      deviceTime: deviceTime ?? this.deviceTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );

  @override
  List<Object?> get props => [
        id,
        name,
        macAddress,
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
        indoorTemp,
        supplyTemp,
        supplyTempAfterRecup,
        co2Level,
        recuperatorEfficiency,
        freeCooling,
        heaterPower,
        coolerStatus,
        ductPressure,
        isOnline,
        quickSensors,
        deviceTime,
        updatedAt,
      ];
}
