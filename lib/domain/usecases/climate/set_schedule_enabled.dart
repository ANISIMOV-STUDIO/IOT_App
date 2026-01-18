/// Use Case: Включить/выключить расписание устройства
library;

import 'package:hvac_control/domain/repositories/schedule_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для управления расписанием
class SetScheduleEnabledParams {

  const SetScheduleEnabledParams({
    required this.deviceId,
    required this.enabled,
  });
  final String deviceId;
  final bool enabled;
}

/// Включить или выключить расписание HVAC устройства
class SetScheduleEnabled extends UseCaseWithParams<void, SetScheduleEnabledParams> {

  SetScheduleEnabled(this._repository);
  final ScheduleRepository _repository;

  @override
  Future<void> call(SetScheduleEnabledParams params) async => _repository.setScheduleEnabled(params.deviceId, enabled: params.enabled);
}
