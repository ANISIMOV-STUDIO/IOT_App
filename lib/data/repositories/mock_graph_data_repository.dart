/// Mock Graph Data Repository
library;

import 'dart:async';
import 'dart:math';

import 'package:hvac_control/data/mock/mock_data.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/domain/repositories/graph_data_repository.dart';

class MockGraphDataRepository implements GraphDataRepository {
  final _controller = StreamController<List<GraphDataPoint>>.broadcast();
  final _random = Random();

  @override
  Future<List<GraphDataPoint>> getGraphData({
    required String deviceId,
    required GraphMetric metric,
    required DateTime from,
    required DateTime to,
  }) async {
    await Future<void>.delayed(MockData.normalDelay);
    return _generateGraphData(deviceId, metric);
  }

  List<GraphDataPoint> _generateGraphData(String deviceId, GraphMetric metric) =>
    MockData.graphDataTemplate.map((t) {
      final baseValue = switch (metric) {
        GraphMetric.temperature => (t['baseTemp'] as num).toDouble(),
        GraphMetric.humidity => (t['baseHumidity'] as num).toDouble(),
        GraphMetric.airflow => (t['baseAirflow'] as num).toDouble(),
      };

      // Add random variation for realism (-1 to +1 for temp/humidity, -20 to +20 for airflow)
      final variance = metric == GraphMetric.airflow
          ? (_random.nextDouble() * 40 - 20)
          : (_random.nextDouble() * 2 - 1);

      return GraphDataPoint(
        label: t['label'] as String,
        value: baseValue + variance,
      );
    }).toList();

  @override
  Stream<List<GraphDataPoint>> watchGraphData({
    required String deviceId,
    required GraphMetric metric,
  }) {
    Future.microtask(() async {
      final data = await getGraphData(
        deviceId: deviceId,
        metric: metric,
        from: DateTime.now().subtract(const Duration(days: 7)),
        to: DateTime.now(),
      );
      _controller.add(data);
    });
    return _controller.stream;
  }

  @override
  Future<List<GraphMetric>> getAvailableMetrics(String deviceId) async {
    await Future<void>.delayed(MockData.fastDelay);
    // All metrics are available for all devices
    return GraphMetric.values;
  }

  void dispose() {
    _controller.close();
  }
}
