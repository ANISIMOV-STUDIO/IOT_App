/// Use Case: Получить полное состояние устройства
library;

import '../../entities/device_full_state.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для получения полного состояния
class GetDeviceFullStateParams {
  final String deviceId;

  const GetDeviceFullStateParams({required this.deviceId});
}

/// Получить полное состояние устройства (включая аварии, настройки режимов)
class GetDeviceFullState extends UseCaseWithParams<DeviceFullState, GetDeviceFullStateParams> {
  final ClimateRepository _repository;

  GetDeviceFullState(this._repository);

  @override
  Future<DeviceFullState> call(GetDeviceFullStateParams params) async {
    return _repository.getDeviceFullState(params.deviceId);
  }
}
