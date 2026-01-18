/// Use Case: Получить историю аварий устройства
library;

import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для получения истории аварий
class GetAlarmHistoryParams {

  const GetAlarmHistoryParams({
    required this.deviceId,
    this.limit = 100,
  });
  final String deviceId;
  final int limit;
}

/// Получить историю аварий устройства
class GetAlarmHistory
    extends UseCaseWithParams<List<AlarmHistory>, GetAlarmHistoryParams> {

  GetAlarmHistory(this._repository);
  final ClimateRepository _repository;

  @override
  Future<List<AlarmHistory>> call(GetAlarmHistoryParams params) async => _repository.getAlarmHistory(params.deviceId, limit: params.limit);
}
