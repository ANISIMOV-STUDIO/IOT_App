/// Реальная реализация GraphDataRepository
///
/// Использует AnalyticsDataSource для получения данных графиков.
/// DataSource выбирается автоматически в зависимости от платформы:
/// - Web: HTTP
/// - Mobile/Desktop: gRPC
library;

import 'dart:async';

import 'package:hvac_control/data/datasources/analytics/analytics_data_source.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/domain/repositories/graph_data_repository.dart';

class RealGraphDataRepository implements GraphDataRepository {

  RealGraphDataRepository(this._dataSource);
  final AnalyticsDataSource _dataSource;
  final _graphDataController = StreamController<List<GraphDataPoint>>.broadcast();

  @override
  Future<List<GraphDataPoint>> getGraphData({
    required String deviceId,
    required GraphMetric metric,
    required DateTime from,
    required DateTime to,
  }) async {
    final metricString = _metricToString(metric);
    final dataPoints = await _dataSource.getGraphData(
      deviceId: deviceId,
      metric: metricString,
      from: from,
      to: to,
    );

    _graphDataController.add(dataPoints);
    return dataPoints;
  }

  @override
  Stream<List<GraphDataPoint>> watchGraphData({
    required String deviceId,
    required GraphMetric metric,
  }) {
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 7));
    // getGraphData уже добавляет данные в контроллер (line 35)
    // Здесь только обрабатываем ошибки
    getGraphData(
      deviceId: deviceId,
      metric: metric,
      from: from,
      to: now,
    ).catchError((Object error) {
      _graphDataController.addError(error);
      return <GraphDataPoint>[]; // Возвращаем пустой список для типизации
    });
    return _graphDataController.stream;
  }

  @override
  Future<List<GraphMetric>> getAvailableMetrics(String deviceId) async => [
      GraphMetric.temperature,
      GraphMetric.humidity,
      GraphMetric.airflow,
    ];

  String _metricToString(GraphMetric metric) {
    switch (metric) {
      case GraphMetric.temperature:
        return 'temperature';
      case GraphMetric.humidity:
        return 'humidity';
      case GraphMetric.airflow:
        return 'airflow';
    }
  }

  void dispose() {
    _graphDataController.close();
  }
}
