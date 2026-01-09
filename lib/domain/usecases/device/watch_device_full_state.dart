/// Watch Device Full State Use Case
///
/// Подписка на real-time обновления полного состояния устройства
library;

import '../../entities/device_full_state.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для WatchDeviceFullState
class WatchDeviceFullStateParams {
  final String deviceId;

  const WatchDeviceFullStateParams({required this.deviceId});
}

/// Use Case для подписки на real-time обновления DeviceFullState
class WatchDeviceFullState
    extends StreamUseCaseWithParams<DeviceFullState, WatchDeviceFullStateParams> {
  final ClimateRepository _repository;

  WatchDeviceFullState(this._repository);

  @override
  Stream<DeviceFullState> call(WatchDeviceFullStateParams params) {
    return _repository.watchDeviceFullState(params.deviceId);
  }
}

