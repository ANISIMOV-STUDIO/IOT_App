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
