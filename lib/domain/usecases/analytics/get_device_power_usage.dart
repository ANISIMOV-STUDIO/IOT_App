/// Use Case: Получить потребление энергии по устройствам
library;

import '../../entities/energy_stats.dart';
import '../../repositories/energy_repository.dart';
import '../usecase.dart';

/// Получить потребление энергии по устройствам
class GetDevicePowerUsage extends UseCase<List<DeviceEnergyUsage>> {
  final EnergyRepository _repository;

  GetDevicePowerUsage(this._repository);

  @override
  Future<List<DeviceEnergyUsage>> call() async {
    return _repository.getDevicePowerUsage();
  }
}
