/// Watch Device Full State Use Case
///
/// Подписка на real-time обновления полного состояния устройства
library;

import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для WatchDeviceFullState
class WatchDeviceFullStateParams {

  const WatchDeviceFullStateParams({required this.deviceId});
  final String deviceId;
}

/// Use Case для подписки на real-time обновления DeviceFullState
class WatchDeviceFullState
    extends StreamUseCaseWithParams<DeviceFullState, WatchDeviceFullStateParams> {

  WatchDeviceFullState(this._repository);
  final ClimateRepository _repository;

  @override
  Stream<DeviceFullState> call(WatchDeviceFullStateParams params) =>
      _repository.watchDeviceFullState(params.deviceId);
}
