/// Use Case: Получить данные для графика
library;

import '../../entities/graph_data.dart';
import '../../repositories/graph_data_repository.dart';
import '../usecase.dart';

/// Параметры для получения данных графика
class GetGraphDataParams {
  final String deviceId;
  final GraphMetric metric;
  final DateTime from;
  final DateTime to;

  const GetGraphDataParams({
    required this.deviceId,
    required this.metric,
    required this.from,
    required this.to,
  });
}

/// Получить данные для графика
class GetGraphData
    extends UseCaseWithParams<List<GraphDataPoint>, GetGraphDataParams> {
  final GraphDataRepository _repository;

  GetGraphData(this._repository);

  @override
  Future<List<GraphDataPoint>> call(GetGraphDataParams params) async {
    return _repository.getGraphData(
      deviceId: params.deviceId,
      metric: params.metric,
      from: params.from,
      to: params.to,
    );
  }
}
