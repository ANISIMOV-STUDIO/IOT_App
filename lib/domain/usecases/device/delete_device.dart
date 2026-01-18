/// Use Case: Удалить устройство
library;

import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для удаления устройства
class DeleteDeviceParams {

  const DeleteDeviceParams({required this.deviceId});
  final String deviceId;
}

/// Удалить HVAC устройство из аккаунта
class DeleteDevice extends UseCaseWithParams<void, DeleteDeviceParams> {

  DeleteDevice(this._repository);
  final ClimateRepository _repository;

  @override
  Future<void> call(DeleteDeviceParams params) async {
    await _repository.deleteDevice(params.deviceId);
  }
}
