/// Use Case: Получить текущее состояние климата
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Получить состояние климата выбранного устройства
class GetCurrentClimateState extends UseCase<ClimateState> {

  GetCurrentClimateState(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call() async => _repository.getCurrentState();
}
