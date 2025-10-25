/// Get Unit By ID UseCase
///
/// Business logic for retrieving a single HVAC unit
library;

import '../entities/hvac_unit.dart';
import '../repositories/hvac_repository.dart';

class GetUnitById {
  final HvacRepository repository;

  GetUnitById(this.repository);

  /// Execute the use case
  Stream<HvacUnit> call(String unitId) {
    return repository.getUnitById(unitId);
  }
}
