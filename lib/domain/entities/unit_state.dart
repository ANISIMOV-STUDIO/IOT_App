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
    required this.mode,
    this.temp,
    this.humidity,
    this.outsideTemp,
    this.filterPercent,
    this.macAddress = '',
    this.heatingTemp,
    this.coolingTemp,
    this.supplyFan,
    this.exhaustFan,
    this.indoorTemp,
    this.supplyTemp,
    this.recuperatorTemperature,
    this.coIndicator,
    this.recuperatorEfficiency,
    this.freeCooling = false,
    this.heaterPower,
    this.coolerStatus,
    this.ductPressure,
    this.actualSupplyFan,
    this.actualExhaustFan,
    this.temperatureSetpoint,
    this.isOnline = true,
    this.quickSensors = const ['outside_temp', 'indoor_temp', 'humidity'],
    this.deviceTime,
    this.updatedAt,
  });
  final String id;
  final String name;
  final String macAddress;
  final bool power;
  final int? temp;                        // Текущая температура
  final int? heatingTemp;
  final int? coolingTemp;
  final int? supplyFan;
  final int? exhaustFan;
  final String mode;
  final int? humidity;                    // Влажность (%)
  final double? outsideTemp;              // Уличная температура
  final int? filterPercent;               // Состояние фильтра (%)

  // Новые датчики (nullable — показываем "—" если нет данных)
  final double? indoorTemp;              // Температура воздуха в помещении
  final double? supplyTemp;              // Температура приточного воздуха
  final double? recuperatorTemperature;  // Температура после рекуператора
  final int? coIndicator;                   // Индикатор угарного газа CO
  final int? recuperatorEfficiency;      // Эффективность рекуператора (%)
  final bool freeCooling;                // Свободное охлаждение (Вкл/Выкл)
  final int? heaterPower;                // Мощность нагревателя (%)
  final String? coolerStatus;            // Статус охладителя
  final int? ductPressure;               // Давление в воздуховоде (Па)
  final int? actualSupplyFan;            // Фактические обороты приточного (0-100%)
  final int? actualExhaustFan;           // Фактические обороты вытяжного (0-100%)
  final double? temperatureSetpoint;     // Уставка температуры с пульта
  final bool isOnline;                   // Устройство онлайн
  final List<String> quickSensors;       // Быстрые показатели на главном экране
  final DateTime? deviceTime;            // Текущее время устройства
  final DateTime? updatedAt;             // Время последней синхронизации

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
    double? recuperatorTemperature,
    int? coIndicator,
    int? recuperatorEfficiency,
    bool? freeCooling,
    int? heaterPower,
    String? coolerStatus,
    int? ductPressure,
    int? actualSupplyFan,
    int? actualExhaustFan,
    double? temperatureSetpoint,
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
      recuperatorTemperature: recuperatorTemperature ?? this.recuperatorTemperature,
      coIndicator: coIndicator ?? this.coIndicator,
      recuperatorEfficiency: recuperatorEfficiency ?? this.recuperatorEfficiency,
      freeCooling: freeCooling ?? this.freeCooling,
      heaterPower: heaterPower ?? this.heaterPower,
      coolerStatus: coolerStatus ?? this.coolerStatus,
      ductPressure: ductPressure ?? this.ductPressure,
      actualSupplyFan: actualSupplyFan ?? this.actualSupplyFan,
      actualExhaustFan: actualExhaustFan ?? this.actualExhaustFan,
      temperatureSetpoint: temperatureSetpoint ?? this.temperatureSetpoint,
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
        recuperatorTemperature,
        coIndicator,
        recuperatorEfficiency,
        freeCooling,
        heaterPower,
        coolerStatus,
        ductPressure,
        actualSupplyFan,
        actualExhaustFan,
        temperatureSetpoint,
        isOnline,
        quickSensors,
        deviceTime,
        updatedAt,
      ];
}
