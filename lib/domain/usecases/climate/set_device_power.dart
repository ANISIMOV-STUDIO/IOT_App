/// Use Case: Включить/выключить устройство
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для управления питанием
class SetDevicePowerParams {

  const SetDevicePowerParams({
    required this.isOn,
    this.deviceId,
  });
  final bool isOn;
  final String? deviceId;
}

/// Включить или выключить HVAC устройство
class SetDevicePower extends UseCaseWithParams<ClimateState, SetDevicePowerParams> {

  SetDevicePower(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call(SetDevicePowerParams params) async => _repository.setPower(isOn: params.isOn, deviceId: params.deviceId);
}
