/// Use Case: Установить время на устройстве
library;

import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для установки времени на устройстве
class SetDeviceTimeParams {
  final String deviceId;
  final DateTime time;

  const SetDeviceTimeParams({
    required this.deviceId,
    required this.time,
  });
}

/// Установить время на HVAC устройстве
class SetDeviceTime extends UseCaseWithParams<void, SetDeviceTimeParams> {
  final ClimateRepository _repository;

  SetDeviceTime(this._repository);

  @override
  Future<void> call(SetDeviceTimeParams params) async {
    // Валидация параметров
    if (params.deviceId.trim().isEmpty) {
      throw ArgumentError('ID устройства не может быть пустым');
    }

    await _repository.setDeviceTime(params.time, deviceId: params.deviceId);
  }
}
