/// Use Case: Подписка на список устройств
library;

import '../../entities/hvac_device.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Подписаться на обновления списка HVAC устройств
class WatchHvacDevices extends StreamUseCase<List<HvacDevice>> {
  final ClimateRepository _repository;

  WatchHvacDevices(this._repository);

  @override
  Stream<List<HvacDevice>> call() {
    return _repository.watchHvacDevices();
  }
}
