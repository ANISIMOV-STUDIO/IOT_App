/// Apply Preset Use Case
///
/// Applies a mode preset to a ventilation unit
library;

import '../entities/mode_preset.dart';
import '../repositories/hvac_repository.dart';

class ApplyPreset {
  final HvacRepository repository;

  ApplyPreset(this.repository);

  /// Apply a preset to a unit
  Future<void> call(String unitId, ModePreset preset) async {
    // Get current unit
    final units = await repository.getAllUnits().first;
    final unit = units.firstWhere((u) => u.id == unitId);

    // Update unit with preset values
    final updatedUnit = unit.copyWith(
      ventMode: preset.mode,
      supplyFanSpeed: preset.supplyFanSpeed,
      exhaustFanSpeed: preset.exhaustFanSpeed,
      supplyAirTemp: preset.heatingTemp,
      // Can add more fields as needed
    );

    // Save to repository
    await repository.updateUnitEntity(updatedUnit);
  }
}
