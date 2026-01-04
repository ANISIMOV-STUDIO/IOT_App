/// Real implementation of GraphDataRepository
library;

import 'dart:async';
import '../../domain/entities/graph_data.dart';
import '../../domain/repositories/graph_data_repository.dart';
import '../api/platform/api_client.dart';
import '../api/http/clients/analytics_http_client.dart';

class RealGraphDataRepository implements GraphDataRepository {
  final ApiClient _apiClient;
  late final AnalyticsHttpClient _httpClient;

  final _graphDataController = StreamController<List<GraphDataPoint>>.broadcast();

  RealGraphDataRepository(this._apiClient) {
    _httpClient = AnalyticsHttpClient(_apiClient);
  }

  @override
  Future<List<GraphDataPoint>> getGraphData({
    required String deviceId,
    required GraphMetric metric,
    required DateTime from,
    required DateTime to,
  }) async {
    final metricString = _metricToString(metric);
    final jsonData = await _httpClient.getGraphData(deviceId, metricString, from, to);

    // Parse data points
    final dataPoints = <GraphDataPoint>[];
    if (jsonData.containsKey('dataPoints') && jsonData['dataPoints'] is List) {
      for (final point in jsonData['dataPoints'] as List) {
        if (point is Map<String, dynamic>) {
          final rawLabel = point['label'] as String? ?? '';
          final label = _formatLabel(rawLabel);
          dataPoints.add(GraphDataPoint(
            label: label,
            value: (point['value'] as num?)?.toDouble() ?? 0.0,
          ));
        }
      }
    }

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
    getGraphData(
      deviceId: deviceId,
      metric: metric,
      from: from,
      to: now,
    ).then(_graphDataController.add);
    return _graphDataController.stream;
  }

  @override
  Future<List<GraphMetric>> getAvailableMetrics(String deviceId) async {
    // Return all metrics for now
    return [
      GraphMetric.temperature,
      GraphMetric.humidity,
      GraphMetric.airflow,
    ];
  }

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

  /// Format ISO timestamp to short label (HH:mm)
  String _formatLabel(String rawLabel) {
    if (rawLabel.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(rawLabel);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      // Not a timestamp, return as-is
      return rawLabel;
    }
  }

  void dispose() {
    _graphDataController.close();
  }
}
