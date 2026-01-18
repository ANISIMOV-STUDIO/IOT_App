/// Use Case: Установить целевую температуру охлаждения
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для установки температуры охлаждения
class SetCoolingTemperatureParams {

  const SetCoolingTemperatureParams({
    required this.temperature,
    this.deviceId,
  });
  final int temperature;
  final String? deviceId;
}

/// Установить температуру охлаждения для устройства
class SetCoolingTemperature extends UseCaseWithParams<ClimateState, SetCoolingTemperatureParams> {

  SetCoolingTemperature(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call(SetCoolingTemperatureParams params) async => _repository.setCoolingTemperature(
      params.temperature,
      deviceId: params.deviceId,
    );
}
