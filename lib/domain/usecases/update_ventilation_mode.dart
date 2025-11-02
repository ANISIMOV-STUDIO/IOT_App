/// Update Ventilation Mode Use Case
///
/// Updates the operating mode of a ventilation unit
library;

import '../entities/ventilation_mode.dart';
import '../repositories/hvac_repository.dart';

class UpdateVentilationMode {
  final HvacRepository repository;

  UpdateVentilationMode(this.repository);

  Future<void> call(String unitId, VentilationMode mode) async {
    // Get current unit
    final unit = await repository.getUnitById(unitId).first;

    // Get preset for the selected mode
    final preset = unit.modePresets?[mode];

    if (preset != null) {
      // Update unit with new mode and preset values
      final updatedUnit = unit.copyWith(
        ventMode: mode,
        supplyFanSpeed: preset.supplyFanSpeed,
        exhaustFanSpeed: preset.exhaustFanSpeed,
        heatingTemp: preset.heatingTemp,
        coolingTemp: preset.coolingTemp,
      );

      await repository.updateUnitEntity(updatedUnit);
    } else {
      // Just update mode without changing other parameters
      final updatedUnit = unit.copyWith(ventMode: mode);
      await repository.updateUnitEntity(updatedUnit);
    }
  }
}
