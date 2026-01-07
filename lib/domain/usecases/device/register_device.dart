/// Use Case: Зарегистрировать новое устройство
library;

import '../../entities/hvac_device.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для регистрации устройства
class RegisterDeviceParams {
  final String macAddress;
  final String name;

  const RegisterDeviceParams({
    required this.macAddress,
    required this.name,
  });
}

/// Зарегистрировать новое HVAC устройство по MAC-адресу
class RegisterDevice extends UseCaseWithParams<HvacDevice, RegisterDeviceParams> {
  final ClimateRepository _repository;

  RegisterDevice(this._repository);

  @override
  Future<HvacDevice> call(RegisterDeviceParams params) async {
    // Валидация параметров
    if (params.macAddress.trim().isEmpty) {
      throw ArgumentError('MAC-адрес не может быть пустым');
    }
    if (params.name.trim().isEmpty) {
      throw ArgumentError('Имя устройства не может быть пустым');
    }

    return _repository.registerDevice(params.macAddress.trim(), params.name.trim());
  }
}
