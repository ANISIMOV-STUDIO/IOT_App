/// Use Case: Подписка на изменения климата
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для подписки на климат устройства
class WatchClimateParams {
  final String deviceId;

  const WatchClimateParams({required this.deviceId});
}

/// Подписаться на обновления состояния климата
class WatchClimate extends StreamUseCaseWithParams<ClimateState, WatchClimateParams> {
  final ClimateRepository _repository;

  WatchClimate(this._repository);

  @override
  Stream<ClimateState> call(WatchClimateParams params) {
    return _repository.watchDeviceClimate(params.deviceId);
  }
}
