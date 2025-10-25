/// Get All Units UseCase
///
/// Business logic for retrieving all HVAC units
library;

import '../entities/hvac_unit.dart';
import '../repositories/hvac_repository.dart';

class GetAllUnits {
  final HvacRepository repository;

  GetAllUnits(this.repository);

  /// Execute the use case
  Stream<List<HvacUnit>> call() {
    return repository.getAllUnits();
  }
}
