/// Репозиторий климат-контроля
library;

import '../entities/climate.dart';

abstract class ClimateRepository {
  /// Получить текущее состояние климата
  Future<ClimateState> getCurrentState();

  /// Установить целевую температуру
  Future<ClimateState> setTargetTemperature(double temperature);

  /// Установить влажность
  Future<ClimateState> setHumidity(double humidity);

  /// Установить режим
  Future<ClimateState> setMode(ClimateMode mode);

  /// Стрим обновлений климата
  Stream<ClimateState> watchClimate();
}
