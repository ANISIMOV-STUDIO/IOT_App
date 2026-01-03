/// Use Case: Подписка на обновления данных графика
library;

import '../../entities/graph_data.dart';
import '../../repositories/graph_data_repository.dart';
import '../usecase.dart';

/// Параметры для подписки на данные графика
class WatchGraphDataParams {
  final String deviceId;
  final GraphMetric metric;

  const WatchGraphDataParams({
    required this.deviceId,
    required this.metric,
  });
}

/// Подписаться на обновления данных графика
class WatchGraphData extends StreamUseCaseWithParams<List<GraphDataPoint>,
    WatchGraphDataParams> {
  final GraphDataRepository _repository;

  WatchGraphData(this._repository);

  @override
  Stream<List<GraphDataPoint>> call(WatchGraphDataParams params) {
    return _repository.watchGraphData(
      deviceId: params.deviceId,
      metric: params.metric,
    );
  }
}
