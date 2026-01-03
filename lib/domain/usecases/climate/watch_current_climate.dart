/// Use Case: Подписка на текущий климат
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Подписаться на обновления климата выбранного устройства
class WatchCurrentClimate extends StreamUseCase<ClimateState> {
  final ClimateRepository _repository;

  WatchCurrentClimate(this._repository);

  @override
  Stream<ClimateState> call() {
    return _repository.watchClimate();
  }
}
