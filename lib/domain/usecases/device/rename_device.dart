/// Use Case: Переименовать устройство
library;

import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для переименования устройства
class RenameDeviceParams {

  const RenameDeviceParams({
    required this.deviceId,
    required this.newName,
  });
  final String deviceId;
  final String newName;
}

/// Переименовать HVAC устройство
class RenameDevice extends UseCaseWithParams<void, RenameDeviceParams> {

  RenameDevice(this._repository);
  final ClimateRepository _repository;

  @override
  Future<void> call(RenameDeviceParams params) async {
    // Валидация параметров
    if (params.deviceId.trim().isEmpty) {
      throw ArgumentError('ID устройства не может быть пустым');
    }
    if (params.newName.trim().isEmpty) {
      throw ArgumentError('Новое имя не может быть пустым');
    }

    await _repository.renameDevice(params.deviceId, params.newName.trim());
  }
}
