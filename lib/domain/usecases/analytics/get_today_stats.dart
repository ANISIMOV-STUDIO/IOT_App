/// Use Case: Получить статистику энергопотребления за сегодня
library;

import 'package:hvac_control/domain/entities/energy_stats.dart';
import 'package:hvac_control/domain/repositories/energy_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Получить статистику энергопотребления за сегодня
class GetTodayStats extends UseCase<EnergyStats> {

  GetTodayStats(this._repository);
  final EnergyRepository _repository;

  @override
  Future<EnergyStats> call() async => _repository.getTodayStats();
}
