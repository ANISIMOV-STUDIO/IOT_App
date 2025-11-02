/// Sync Settings To All Use Case
///
/// Synchronizes settings from one unit to all other units
library;

import '../repositories/hvac_repository.dart';

class SyncSettingsToAll {
  final HvacRepository repository;

  SyncSettingsToAll(this.repository);

  /// Sync settings from source unit to all other units
  Future<void> call(String sourceUnitId) async {
    final units = await repository.getAllUnits().first;
    final sourceUnit = units.firstWhere((u) => u.id == sourceUnitId);

    for (final unit in units) {
      if (unit.id != sourceUnitId && unit.isVentilation) {
        // Copy ventilation settings from source
        final updatedUnit = unit.copyWith(
          ventMode: sourceUnit.ventMode,
          supplyFanSpeed: sourceUnit.supplyFanSpeed,
          exhaustFanSpeed: sourceUnit.exhaustFanSpeed,
          supplyAirTemp: sourceUnit.supplyAirTemp,
        );

        await repository.updateUnitEntity(updatedUnit);
      }
    }
  }
}
