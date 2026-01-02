/// Use Case: Получить состояние устройства
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для получения состояния устройства
class GetDeviceStateParams {
  final String deviceId;

  const GetDeviceStateParams({required this.deviceId});
}

/// Получить текущее состояние климата устройства
class GetDeviceState extends UseCaseWithParams<ClimateState, GetDeviceStateParams> {
  final ClimateRepository _repository;

  GetDeviceState(this._repository);

  @override
  Future<ClimateState> call(GetDeviceStateParams params) async {
    return _repository.getDeviceState(params.deviceId);
  }
}
