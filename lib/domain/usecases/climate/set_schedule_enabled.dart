/// Use Case: Включить/выключить расписание устройства
library;

import '../../repositories/schedule_repository.dart';
import '../usecase.dart';

/// Параметры для управления расписанием
class SetScheduleEnabledParams {
  final String deviceId;
  final bool enabled;

  const SetScheduleEnabledParams({
    required this.deviceId,
    required this.enabled,
  });
}

/// Включить или выключить расписание HVAC устройства
class SetScheduleEnabled extends UseCaseWithParams<void, SetScheduleEnabledParams> {
  final ScheduleRepository _repository;

  SetScheduleEnabled(this._repository);

  @override
  Future<void> call(SetScheduleEnabledParams params) async {
    return _repository.setScheduleEnabled(params.deviceId, params.enabled);
  }
}
