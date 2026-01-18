/// Use Case: Подписка на список устройств
library;

import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Подписаться на обновления списка HVAC устройств
class WatchHvacDevices extends StreamUseCase<List<HvacDevice>> {

  WatchHvacDevices(this._repository);
  final ClimateRepository _repository;

  @override
  Stream<List<HvacDevice>> call() => _repository.watchHvacDevices();
}
