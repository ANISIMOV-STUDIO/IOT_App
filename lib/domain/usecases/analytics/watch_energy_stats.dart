/// Use Case: Подписка на обновления статистики энергопотребления
library;

import 'package:hvac_control/domain/entities/energy_stats.dart';
import 'package:hvac_control/domain/repositories/energy_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Подписаться на обновления статистики энергопотребления
class WatchEnergyStats extends StreamUseCase<EnergyStats> {

  WatchEnergyStats(this._repository);
  final EnergyRepository _repository;

  @override
  Stream<EnergyStats> call() => _repository.watchStats();
}
