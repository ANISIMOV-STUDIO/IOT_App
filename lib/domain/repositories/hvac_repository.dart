/// HVAC Repository Interface
///
/// Abstract repository defining the contract for HVAC data operations
library;

import '../entities/hvac_unit.dart';
import '../entities/temperature_reading.dart';

abstract class HvacRepository {
  /// Get all HVAC units
  Stream<List<HvacUnit>> getAllUnits();

  /// Get a single HVAC unit by ID
  Stream<HvacUnit> getUnitById(String id);

  /// Get temperature history for a unit
  Future<List<TemperatureReading>> getTemperatureHistory(String unitId, {int hours = 24});

  /// Update HVAC unit settings (deprecated - use updateUnitEntity)
  @Deprecated('Use updateUnitEntity instead')
  Future<void> updateUnit({
    required String unitId,
    bool? power,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
  });

  /// Update HVAC unit with full entity
  Future<void> updateUnitEntity(HvacUnit unit);

  /// Connect to MQTT broker
  Future<void> connect();

  /// Disconnect from MQTT broker
  Future<void> disconnect();

  /// Check connection status
  bool isConnected();
}
