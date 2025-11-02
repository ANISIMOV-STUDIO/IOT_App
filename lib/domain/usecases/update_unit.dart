/// Update Unit UseCase
///
/// Business logic for updating HVAC unit settings
library;

import '../repositories/hvac_repository.dart';

@Deprecated('Use UpdateUnitEntity instead')
class UpdateUnit {
  final HvacRepository repository;

  UpdateUnit(this.repository);

  /// Execute the use case
  @Deprecated('Use UpdateUnitEntity instead')
  Future<void> call({
    required String unitId,
    bool? power,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
  }) {
    // ignore: deprecated_member_use_from_same_package
    return repository.updateUnit(
      unitId: unitId,
      power: power,
      targetTemp: targetTemp,
      mode: mode,
      fanSpeed: fanSpeed,
    );
  }
}
