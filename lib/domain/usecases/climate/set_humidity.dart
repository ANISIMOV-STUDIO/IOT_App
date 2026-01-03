/// Use Case: Установить влажность
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для установки влажности
class SetHumidityParams {
  final double humidity;
  final String? deviceId;

  const SetHumidityParams({
    required this.humidity,
    this.deviceId,
  });
}

/// Установить целевую влажность
class SetHumidity extends UseCaseWithParams<ClimateState, SetHumidityParams> {
  final ClimateRepository _repository;

  SetHumidity(this._repository);

  @override
  Future<ClimateState> call(SetHumidityParams params) async {
    return _repository.setHumidity(params.humidity, deviceId: params.deviceId);
  }
}
