/// Use Case: Получить историю аварий устройства
library;

import '../../entities/alarm_info.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для получения истории аварий
class GetAlarmHistoryParams {
  final String deviceId;
  final int limit;

  const GetAlarmHistoryParams({
    required this.deviceId,
    this.limit = 100,
  });
}

/// Получить историю аварий устройства
class GetAlarmHistory
    extends UseCaseWithParams<List<AlarmHistory>, GetAlarmHistoryParams> {
  final ClimateRepository _repository;

  GetAlarmHistory(this._repository);

  @override
  Future<List<AlarmHistory>> call(GetAlarmHistoryParams params) async {
    return _repository.getAlarmHistory(params.deviceId, limit: params.limit);
  }
}
