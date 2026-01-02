/// Use Case: Переименовать устройство
library;

import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для переименования устройства
class RenameDeviceParams {
  final String deviceId;
  final String newName;

  const RenameDeviceParams({
    required this.deviceId,
    required this.newName,
  });
}

/// Переименовать HVAC устройство
class RenameDevice extends UseCaseWithParams<void, RenameDeviceParams> {
  final ClimateRepository _repository;

  RenameDevice(this._repository);

  @override
  Future<void> call(RenameDeviceParams params) async {
    await _repository.renameDevice(params.deviceId, params.newName);
  }
}
