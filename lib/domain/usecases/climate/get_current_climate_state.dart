/// Use Case: Получить текущее состояние климата
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Получить состояние климата выбранного устройства
class GetCurrentClimateState extends UseCase<ClimateState> {
  final ClimateRepository _repository;

  GetCurrentClimateState(this._repository);

  @override
  Future<ClimateState> call() async {
    return _repository.getCurrentState();
  }
}
