/// Use Case: Получить полное состояние устройства
library;

import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для получения полного состояния
class GetDeviceFullStateParams {

  const GetDeviceFullStateParams({required this.deviceId});
  final String deviceId;
}

/// Получить полное состояние устройства (включая аварии, настройки режимов)
class GetDeviceFullState extends UseCaseWithParams<DeviceFullState, GetDeviceFullStateParams> {

  GetDeviceFullState(this._repository);
  final ClimateRepository _repository;

  @override
  Future<DeviceFullState> call(GetDeviceFullStateParams params) async => _repository.getDeviceFullState(params.deviceId);
}
