/// HVAC Repository Implementation (MQTT)
///
/// Real implementation using MQTT for Phase 5
library;

import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/temperature_reading.dart';
import '../../domain/repositories/hvac_repository.dart';
import '../datasources/mqtt_datasource.dart';

class HvacRepositoryImpl implements HvacRepository {
  final MqttDatasource datasource;

  HvacRepositoryImpl(this.datasource);

  @override
  Future<void> connect() async {
    await datasource.connect();
  }

  @override
  Future<void> disconnect() async {
    await datasource.disconnect();
  }

  @override
  bool isConnected() {
    return datasource.isConnected;
  }

  @override
  Stream<List<HvacUnit>> getAllUnits() {
    return datasource.getAllUnits().map((models) {
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Stream<HvacUnit> getUnitById(String id) {
    return datasource.getUnitById(id).map((model) => model.toEntity());
  }

  @override
  Future<List<TemperatureReading>> getTemperatureHistory(
    String unitId, {
    int hours = 24,
  }) async {
    // TODO: Implement real temperature history from backend
    // For now, return empty list
    // In real implementation, this would be a separate MQTT topic or REST API call
    return [];
  }

  @override
  Future<void> updateUnit({
    required String unitId,
    bool? power,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
  }) async {
    await datasource.publishCommand(
      unitId: unitId,
      power: power,
      targetTemp: targetTemp,
      mode: mode,
      fanSpeed: fanSpeed,
    );
  }
}
