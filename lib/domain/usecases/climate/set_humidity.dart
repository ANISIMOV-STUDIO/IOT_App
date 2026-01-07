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
    // Валидация диапазона влажности
    if (params.humidity < 0 || params.humidity > 100) {
      throw ArgumentError('Влажность должна быть от 0 до 100%');
    }

    return _repository.setHumidity(params.humidity, deviceId: params.deviceId);
  }
}
