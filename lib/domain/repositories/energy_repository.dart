/// Репозиторий статистики энергопотребления
library;

import 'package:hvac_control/domain/entities/energy_stats.dart';

abstract class EnergyRepository {
  /// Получить статистику за сегодня
  Future<EnergyStats> getTodayStats();

  /// Получить статистику за период
  Future<EnergyStats> getStats(DateTime from, DateTime to);

  /// Получить потребление по устройствам
  Future<List<DeviceEnergyUsage>> getDevicePowerUsage();

  /// Стрим обновлений статистики
  Stream<EnergyStats> watchStats();
}
