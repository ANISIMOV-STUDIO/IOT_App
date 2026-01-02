/// Use Case: Получить список всех HVAC устройств
library;

import '../../entities/hvac_device.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Получить все HVAC устройства пользователя
class GetAllHvacDevices extends UseCase<List<HvacDevice>> {
  final ClimateRepository _repository;

  GetAllHvacDevices(this._repository);

  @override
  Future<List<HvacDevice>> call() async {
    return _repository.getAllHvacDevices();
  }
}
