/// Use Case: Получить потребление энергии по устройствам
library;

import 'package:hvac_control/domain/entities/energy_stats.dart';
import 'package:hvac_control/domain/repositories/energy_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Получить потребление энергии по устройствам
class GetDevicePowerUsage extends UseCase<List<DeviceEnergyUsage>> {

  GetDevicePowerUsage(this._repository);
  final EnergyRepository _repository;

  @override
  Future<List<DeviceEnergyUsage>> call() async => _repository.getDevicePowerUsage();
}
