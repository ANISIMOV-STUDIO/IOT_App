/// Use Case: Подписка на обновления данных графика
library;

import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/domain/repositories/graph_data_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для подписки на данные графика
class WatchGraphDataParams {

  const WatchGraphDataParams({
    required this.deviceId,
    required this.metric,
  });
  final String deviceId;
  final GraphMetric metric;
}

/// Подписаться на обновления данных графика
class WatchGraphData extends StreamUseCaseWithParams<List<GraphDataPoint>,
    WatchGraphDataParams> {

  WatchGraphData(this._repository);
  final GraphDataRepository _repository;

  @override
  Stream<List<GraphDataPoint>> call(WatchGraphDataParams params) => _repository.watchGraphData(
      deviceId: params.deviceId,
      metric: params.metric,
    );
}
