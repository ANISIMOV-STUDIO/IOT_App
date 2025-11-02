/// Update Fan Speeds Use Case
///
/// Updates supply and exhaust fan speeds for ventilation unit
library;

import '../repositories/hvac_repository.dart';

class UpdateFanSpeeds {
  final HvacRepository repository;

  UpdateFanSpeeds(this.repository);

  Future<void> call({
    required String unitId,
    int? supplyFanSpeed,
    int? exhaustFanSpeed,
  }) async {
    // Get current unit
    final unit = await repository.getUnitById(unitId).first;

    // Validate fan speeds (0-100%)
    final validSupplySpeed = supplyFanSpeed != null
        ? supplyFanSpeed.clamp(0, 100)
        : unit.supplyFanSpeed;
    final validExhaustSpeed = exhaustFanSpeed != null
        ? exhaustFanSpeed.clamp(0, 100)
        : unit.exhaustFanSpeed;

    // Update unit
    final updatedUnit = unit.copyWith(
      supplyFanSpeed: validSupplySpeed,
      exhaustFanSpeed: validExhaustSpeed,
    );

    await repository.updateUnitEntity(updatedUnit);
  }
}
