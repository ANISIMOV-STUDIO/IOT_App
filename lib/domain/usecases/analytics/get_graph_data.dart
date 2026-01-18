/// Use Case: Получить данные для графика
library;

import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/domain/repositories/graph_data_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для получения данных графика
class GetGraphDataParams {

  const GetGraphDataParams({
    required this.deviceId,
    required this.metric,
    required this.from,
    required this.to,
  });
  final String deviceId;
  final GraphMetric metric;
  final DateTime from;
  final DateTime to;
}

/// Получить данные для графика
class GetGraphData
    extends UseCaseWithParams<List<GraphDataPoint>, GetGraphDataParams> {

  GetGraphData(this._repository);
  final GraphDataRepository _repository;

  @override
  Future<List<GraphDataPoint>> call(GetGraphDataParams params) async =>
      _repository.getGraphData(
        deviceId: params.deviceId,
        metric: params.metric,
        from: params.from,
        to: params.to,
      );
}
