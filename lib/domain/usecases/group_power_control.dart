/// Group Power Control Use Case
///
/// Controls power for multiple units at once
library;

import '../repositories/hvac_repository.dart';

class GroupPowerControl {
  final HvacRepository repository;

  GroupPowerControl(this.repository);

  /// Turn on all units
  Future<void> powerOnAll() async {
    final units = await repository.getAllUnits().first;

    for (final unit in units) {
      if (!unit.power) {
        final updatedUnit = unit.copyWith(power: true);
        await repository.updateUnitEntity(updatedUnit);
      }
    }
  }

  /// Turn off all units
  Future<void> powerOffAll() async {
    final units = await repository.getAllUnits().first;

    for (final unit in units) {
      if (unit.power) {
        final updatedUnit = unit.copyWith(power: false);
        await repository.updateUnitEntity(updatedUnit);
      }
    }
  }

  /// Toggle power for specific units
  Future<void> toggleUnits(List<String> unitIds, bool powerState) async {
    final units = await repository.getAllUnits().first;

    for (final unit in units) {
      if (unitIds.contains(unit.id)) {
        final updatedUnit = unit.copyWith(power: powerState);
        await repository.updateUnitEntity(updatedUnit);
      }
    }
  }
}
