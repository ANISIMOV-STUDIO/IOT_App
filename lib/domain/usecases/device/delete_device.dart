/// Use Case: Удалить устройство
library;

import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для удаления устройства
class DeleteDeviceParams {
  final String deviceId;

  const DeleteDeviceParams({required this.deviceId});
}

/// Удалить HVAC устройство из аккаунта
class DeleteDevice extends UseCaseWithParams<void, DeleteDeviceParams> {
  final ClimateRepository _repository;

  DeleteDevice(this._repository);

  @override
  Future<void> call(DeleteDeviceParams params) async {
    await _repository.deleteDevice(params.deviceId);
  }
}
