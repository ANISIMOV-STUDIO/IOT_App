/// Use Case: Получить статистику энергопотребления за сегодня
library;

import '../../entities/energy_stats.dart';
import '../../repositories/energy_repository.dart';
import '../usecase.dart';

/// Получить статистику энергопотребления за сегодня
class GetTodayStats extends UseCase<EnergyStats> {
  final EnergyRepository _repository;

  GetTodayStats(this._repository);

  @override
  Future<EnergyStats> call() async {
    return _repository.getTodayStats();
  }
}
