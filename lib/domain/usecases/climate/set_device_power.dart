/// Use Case: Включить/выключить устройство
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для управления питанием
class SetDevicePowerParams {
  final bool isOn;
  final String? deviceId;

  const SetDevicePowerParams({
    required this.isOn,
    this.deviceId,
  });
}

/// Включить или выключить HVAC устройство
class SetDevicePower extends UseCaseWithParams<ClimateState, SetDevicePowerParams> {
  final ClimateRepository _repository;

  SetDevicePower(this._repository);

  @override
  Future<ClimateState> call(SetDevicePowerParams params) async {
    return _repository.setPower(params.isOn, deviceId: params.deviceId);
  }
}
