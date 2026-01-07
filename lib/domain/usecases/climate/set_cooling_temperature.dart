/// Use Case: Установить целевую температуру охлаждения
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для установки температуры охлаждения
class SetCoolingTemperatureParams {
  final int temperature;
  final String? deviceId;

  const SetCoolingTemperatureParams({
    required this.temperature,
    this.deviceId,
  });
}

/// Установить температуру охлаждения для устройства
class SetCoolingTemperature extends UseCaseWithParams<ClimateState, SetCoolingTemperatureParams> {
  final ClimateRepository _repository;

  SetCoolingTemperature(this._repository);

  @override
  Future<ClimateState> call(SetCoolingTemperatureParams params) async {
    return _repository.setCoolingTemperature(
      params.temperature,
      deviceId: params.deviceId,
    );
  }
}
