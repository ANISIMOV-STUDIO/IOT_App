/// Use Case: Подписка на обновления статистики энергопотребления
library;

import '../../entities/energy_stats.dart';
import '../../repositories/energy_repository.dart';
import '../usecase.dart';

/// Подписаться на обновления статистики энергопотребления
class WatchEnergyStats extends StreamUseCase<EnergyStats> {
  final EnergyRepository _repository;

  WatchEnergyStats(this._repository);

  @override
  Stream<EnergyStats> call() {
    return _repository.watchStats();
  }
}
