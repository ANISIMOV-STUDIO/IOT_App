/// Update Unit UseCase
///
/// Business logic for updating HVAC unit settings
library;

import '../repositories/hvac_repository.dart';

class UpdateUnit {
  final HvacRepository repository;

  UpdateUnit(this.repository);

  /// Execute the use case
  Future<void> call({
    required String unitId,
    bool? power,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
  }) {
    return repository.updateUnit(
      unitId: unitId,
      power: power,
      targetTemp: targetTemp,
      mode: mode,
      fanSpeed: fanSpeed,
    );
  }
}
