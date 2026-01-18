/// Use Case: Подписка на текущий климат
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Подписаться на обновления климата выбранного устройства
class WatchCurrentClimate extends StreamUseCase<ClimateState> {

  WatchCurrentClimate(this._repository);
  final ClimateRepository _repository;

  @override
  Stream<ClimateState> call() => _repository.watchClimate();
}
