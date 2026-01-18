/// Graph Data Repository - Interface for graph/chart data operations
library;

import 'package:hvac_control/domain/entities/graph_data.dart';

/// Interface for graph data access
abstract class GraphDataRepository {
  /// Get historical data points for a device and metric
  Future<List<GraphDataPoint>> getGraphData({
    required String deviceId,
    required GraphMetric metric,
    required DateTime from,
    required DateTime to,
  });

  /// Watch for real-time graph data updates
  Stream<List<GraphDataPoint>> watchGraphData({
    required String deviceId,
    required GraphMetric metric,
  });

  /// Get available metrics for a device
  Future<List<GraphMetric>> getAvailableMetrics(String deviceId);
}
