/// Репозиторий климат-контроля
library;

import '../entities/climate.dart';

abstract class ClimateRepository {
  /// Получить текущее состояние климата
  Future<ClimateState> getCurrentState();

  /// Включить/выключить устройство
  Future<ClimateState> setPower(bool isOn);

  /// Установить целевую температуру
  Future<ClimateState> setTargetTemperature(double temperature);

  /// Установить целевую влажность
  Future<ClimateState> setHumidity(double humidity);

  /// Установить режим климата
  Future<ClimateState> setMode(ClimateMode mode);

  /// Установить приточную вентиляцию (0-100%)
  Future<ClimateState> setSupplyAirflow(double value);

  /// Установить вытяжную вентиляцию (0-100%)
  Future<ClimateState> setExhaustAirflow(double value);

  /// Установить пресет (auto, night, turbo, eco, away)
  Future<ClimateState> setPreset(String preset);

  /// Стрим обновлений климата
  Stream<ClimateState> watchClimate();
}
