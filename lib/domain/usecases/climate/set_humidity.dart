/// Use Case: Установить влажность
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для установки влажности
class SetHumidityParams {

  const SetHumidityParams({
    required this.humidity,
    this.deviceId,
  });
  final double humidity;
  final String? deviceId;
}

/// Установить целевую влажность
class SetHumidity extends UseCaseWithParams<ClimateState, SetHumidityParams> {

  SetHumidity(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call(SetHumidityParams params) async {
    // Валидация диапазона влажности
    if (params.humidity < 0 || params.humidity > 100) {
      throw ArgumentError('Влажность должна быть от 0 до 100%');
    }

    return _repository.setHumidity(params.humidity, deviceId: params.deviceId);
  }
}
