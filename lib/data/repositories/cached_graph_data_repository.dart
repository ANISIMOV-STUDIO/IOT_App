/// Кеширующая обёртка для GraphDataRepository
///
/// Данные графиков — только для чтения, кешируются по устройству и метрике.
library;

import '../../core/error/offline_exception.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/graph_data.dart';
import '../../domain/repositories/graph_data_repository.dart';

/// Кеширующий декоратор для GraphDataRepository
class CachedGraphDataRepository implements GraphDataRepository {
  final GraphDataRepository _inner;
  final CacheService _cacheService;
  final ConnectivityService _connectivity;

  CachedGraphDataRepository({
    required GraphDataRepository inner,
    required CacheService cacheService,
    required ConnectivityService connectivity,
  })  : _inner = inner,
        _cacheService = cacheService,
        _connectivity = connectivity;

  @override
  Future<List<GraphDataPoint>> getGraphData({
    required String deviceId,
    required GraphMetric metric,
    required DateTime from,
    required DateTime to,
  }) async {
    if (_connectivity.isOnline) {
      try {
        final data = await _inner.getGraphData(
          deviceId: deviceId,
          metric: metric,
          from: from,
          to: to,
        );
        // Кешируем последние данные
        await _cacheService.cacheGraphData(deviceId, metric, data);
        return data;
      } catch (e) {
        final cached = _cacheService.getCachedGraphData(deviceId, metric);
        if (cached != null) return cached;
        rethrow;
      }
    }

    // Offline — возвращаем последние закешированные данные
    final cached = _cacheService.getCachedGraphData(deviceId, metric);
    if (cached != null) return cached;

    throw OfflineException(
      'Нет сохранённых данных графика для $deviceId',
      operation: 'getGraphData',
    );
  }

  @override
  Stream<List<GraphDataPoint>> watchGraphData({
    required String deviceId,
    required GraphMetric metric,
  }) {
    return _inner.watchGraphData(deviceId: deviceId, metric: metric);
  }

  @override
  Future<List<GraphMetric>> getAvailableMetrics(String deviceId) async {
    if (_connectivity.isOnline) {
      return _inner.getAvailableMetrics(deviceId);
    }

    // Offline — возвращаем стандартный набор метрик
    return GraphMetric.values;
  }
}
