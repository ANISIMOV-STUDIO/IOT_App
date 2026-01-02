/// Use Case: Установить целевую температуру
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для установки температуры
class SetTemperatureParams {
  final double temperature;
  final String? deviceId;

  const SetTemperatureParams({
    required this.temperature,
    this.deviceId,
  });
}

/// Установить целевую температуру для устройства
class SetTemperature extends UseCaseWithParams<ClimateState, SetTemperatureParams> {
  final ClimateRepository _repository;

  SetTemperature(this._repository);

  @override
  Future<ClimateState> call(SetTemperatureParams params) async {
    return _repository.setTargetTemperature(
      params.temperature,
      deviceId: params.deviceId,
    );
  }
}
