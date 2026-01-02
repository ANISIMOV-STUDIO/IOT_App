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
    return _repository.registerDevice(params.macAddress, params.name);
  }
}
