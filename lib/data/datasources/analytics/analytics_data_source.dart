/// Абстрактный интерфейс для операций с аналитикой
///
/// Strategy Pattern: позволяет переключаться между HTTP (web) и gRPC (mobile/desktop)
/// реализациями без изменения логики репозитория.
library;

import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/domain/entities/sensor_history.dart';

/// DTO для статистики энергопотребления
class EnergyStatsDto {

  const EnergyStatsDto({
    required this.todayKwh,
    required this.weekKwh,
    required this.monthKwh,
    required this.currentPowerW,
  });
  final double todayKwh;
  final double weekKwh;
  final double monthKwh;
  final double currentPowerW;
}

/// DTO для записи истории энергопотребления
class EnergyHistoryEntryDto {

  const EnergyHistoryEntryDto({
    required this.timestamp,
    required this.kwh,
  });
  final DateTime timestamp;
  final double kwh;
}

/// Абстрактный источник данных для аналитики
///
/// Реализации:
/// - [AnalyticsHttpDataSource] для Web платформы
/// - [AnalyticsGrpcDataSource] для Mobile/Desktop платформ
abstract class AnalyticsDataSource {
  /// Получить точки данных графика для конкретной метрики
  Future<List<GraphDataPoint>> getGraphData({
    required String deviceId,
    required String metric,
    required DateTime from,
    required DateTime to,
  });

  /// Получить статистику энергопотребления устройства
  Future<EnergyStatsDto> getEnergyStats(String deviceId);

  /// Получить историю потребления энергии
  Future<List<EnergyHistoryEntryDto>> getEnergyHistory({
    required String deviceId,
    required DateTime from,
    required DateTime to,
    required String period,
  });

  /// Получить историю сенсоров (температура, влажность и т.д.)
  Future<List<SensorHistory>> getSensorHistory({
    required String deviceId,
    DateTime? from,
    DateTime? to,
    int limit = 1000,
  });
}
