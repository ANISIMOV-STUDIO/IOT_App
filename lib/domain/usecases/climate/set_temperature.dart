/// Use Case: Установить целевую температуру нагрева
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для установки температуры
class SetTemperatureParams {

  const SetTemperatureParams({
    required this.temperature,
    this.deviceId,
  });
  final double temperature;
  final String? deviceId;
}

/// Установить температуру нагрева для устройства
class SetTemperature extends UseCaseWithParams<ClimateState, SetTemperatureParams> {

  SetTemperature(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call(SetTemperatureParams params) async => _repository.setHeatingTemperature(
      params.temperature.toInt(),
      deviceId: params.deviceId,
    );
}
