/// Use Case: Установить время на устройстве
library;

import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для установки времени на устройстве
class SetDeviceTimeParams {

  const SetDeviceTimeParams({
    required this.deviceId,
    required this.time,
  });
  final String deviceId;
  final DateTime time;
}

/// Установить время на HVAC устройстве
class SetDeviceTime extends UseCaseWithParams<void, SetDeviceTimeParams> {

  SetDeviceTime(this._repository);
  final ClimateRepository _repository;

  @override
  Future<void> call(SetDeviceTimeParams params) async {
    // Валидация параметров
    if (params.deviceId.trim().isEmpty) {
      throw ArgumentError('ID устройства не может быть пустым');
    }

    await _repository.setDeviceTime(params.time, deviceId: params.deviceId);
  }
}
