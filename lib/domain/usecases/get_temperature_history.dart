/// Get Temperature History UseCase
///
/// Business logic for retrieving temperature history for charts
library;

import '../entities/temperature_reading.dart';
import '../repositories/hvac_repository.dart';

class GetTemperatureHistory {
  final HvacRepository repository;

  GetTemperatureHistory(this.repository);

  /// Execute the use case
  ///
  /// [unitId] - The HVAC unit ID
  /// [hours] - Number of hours to retrieve (default 24)
  Future<List<TemperatureReading>> call(String unitId, {int hours = 24}) {
    return repository.getTemperatureHistory(unitId, hours: hours);
  }
}
