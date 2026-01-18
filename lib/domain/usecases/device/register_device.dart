/// Use Case: Зарегистрировать новое устройство
library;

import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для регистрации устройства
class RegisterDeviceParams {

  const RegisterDeviceParams({
    required this.macAddress,
    required this.name,
  });
  final String macAddress;
  final String name;
}

/// Зарегистрировать новое HVAC устройство по MAC-адресу
class RegisterDevice extends UseCaseWithParams<HvacDevice, RegisterDeviceParams> {

  RegisterDevice(this._repository);
  final ClimateRepository _repository;

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
