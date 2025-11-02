/// Apply Schedule To All Use Case
///
/// Applies schedule from one unit to all other units
library;

import '../repositories/hvac_repository.dart';

class ApplyScheduleToAll {
  final HvacRepository repository;

  ApplyScheduleToAll(this.repository);

  /// Apply schedule from source unit to all other units
  Future<void> call(String sourceUnitId) async {
    final units = await repository.getAllUnits().first;
    final sourceUnit = units.firstWhere((u) => u.id == sourceUnitId);

    if (sourceUnit.schedule == null) {
      throw Exception('Source unit has no schedule');
    }

    for (final unit in units) {
      if (unit.id != sourceUnitId && unit.isVentilation) {
        final updatedUnit = unit.copyWith(
          schedule: sourceUnit.schedule,
        );

        await repository.updateUnitEntity(updatedUnit);
      }
    }
  }
}
