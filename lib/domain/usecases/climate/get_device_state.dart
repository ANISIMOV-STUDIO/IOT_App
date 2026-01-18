/// Use Case: Получить состояние устройства
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для получения состояния устройства
class GetDeviceStateParams {

  const GetDeviceStateParams({required this.deviceId});
  final String deviceId;
}

/// Получить текущее состояние климата устройства
class GetDeviceState extends UseCaseWithParams<ClimateState, GetDeviceStateParams> {

  GetDeviceState(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call(GetDeviceStateParams params) async =>
      _repository.getDeviceState(params.deviceId);
}
