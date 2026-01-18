/// Use Case: Получить список всех HVAC устройств
library;

import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Получить все HVAC устройства пользователя
class GetAllHvacDevices extends UseCase<List<HvacDevice>> {

  GetAllHvacDevices(this._repository);
  final ClimateRepository _repository;

  @override
  Future<List<HvacDevice>> call() async => _repository.getAllHvacDevices();
}
