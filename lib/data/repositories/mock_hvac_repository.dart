/// Mock HVAC Repository
///
/// Fake implementation for testing and development (Phase 4)
library;

import 'dart:async';
import 'dart:math';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/temperature_reading.dart';
import '../../domain/repositories/hvac_repository.dart';

class MockHvacRepository implements HvacRepository {
  final _unitsController = StreamController<List<HvacUnit>>.broadcast();
  final Map<String, StreamController<HvacUnit>> _unitControllers = {};
  final Map<String, HvacUnit> _units = {};
  bool _connected = false;
  Timer? _updateTimer;

  MockHvacRepository() {
    _initializeMockData();
    _startSimulation();
  }

  /// Initialize with mock data
  void _initializeMockData() {
    final now = DateTime.now();
    _units['1'] = HvacUnit(
      id: '1',
      name: 'Living Room',
      power: true,
      currentTemp: 22.5,
      targetTemp: 24.0,
      mode: 'cooling',
      fanSpeed: 'auto',
      timestamp: now,
    );

    _units['2'] = HvacUnit(
      id: '2',
      name: 'Bedroom',
      power: true,
      currentTemp: 23.0,
      targetTemp: 22.0,
      mode: 'cooling',
      fanSpeed: 'medium',
      timestamp: now,
    );

    _units['3'] = HvacUnit(
      id: '3',
      name: 'Kitchen',
      power: false,
      currentTemp: 25.0,
      targetTemp: 24.0,
      mode: 'fan',
      fanSpeed: 'low',
      timestamp: now,
    );

    _units['4'] = HvacUnit(
      id: '4',
      name: 'Office',
      power: true,
      currentTemp: 21.0,
      targetTemp: 22.0,
      mode: 'heating',
      fanSpeed: 'high',
      timestamp: now,
    );
  }

  /// Simulate temperature changes
  void _startSimulation() {
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_connected) return;

      final random = Random();
      for (var entry in _units.entries) {
        final unit = entry.value;
        if (!unit.power) continue;

        // Simulate temperature change towards target
        var newTemp = unit.currentTemp;
        final diff = unit.targetTemp - unit.currentTemp;
        if (diff.abs() > 0.1) {
          newTemp += diff * 0.1 + (random.nextDouble() - 0.5) * 0.2;
        } else {
          newTemp += (random.nextDouble() - 0.5) * 0.1;
        }

        final updatedUnit = unit.copyWith(
          currentTemp: newTemp,
          timestamp: DateTime.now(),
        );

        _units[entry.key] = updatedUnit;

        // Emit to specific unit stream
        if (_unitControllers.containsKey(entry.key)) {
          _unitControllers[entry.key]!.add(updatedUnit);
        }
      }

      // Emit all units
      _unitsController.add(_units.values.toList());
    });
  }

  @override
  Future<void> connect() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate connection
    _connected = true;
    _unitsController.add(_units.values.toList());
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
    _updateTimer?.cancel();
  }

  @override
  bool isConnected() => _connected;

  @override
  Stream<List<HvacUnit>> getAllUnits() {
    if (_connected && !_unitsController.hasListener) {
      _unitsController.add(_units.values.toList());
    }
    return _unitsController.stream;
  }

  @override
  Stream<HvacUnit> getUnitById(String id) {
    if (!_unitControllers.containsKey(id)) {
      _unitControllers[id] = StreamController<HvacUnit>.broadcast();
    }

    if (_connected && _units.containsKey(id)) {
      Future.microtask(() {
        if (_unitControllers[id]!.hasListener) {
          _unitControllers[id]!.add(_units[id]!);
        }
      });
    }

    return _unitControllers[id]!.stream;
  }

  @override
  Future<List<TemperatureReading>> getTemperatureHistory(
    String unitId, {
    int hours = 24,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call

    final unit = _units[unitId];
    if (unit == null) return [];

    // Generate fake history data
    final readings = <TemperatureReading>[];
    final now = DateTime.now();
    final random = Random();

    for (int i = hours * 12; i >= 0; i--) {
      final time = now.subtract(Duration(minutes: i * 5));
      final temp = unit.targetTemp +
          (random.nextDouble() - 0.5) * 2.0 +
          sin(i / 12.0) * 1.5;
      readings.add(TemperatureReading(
        timestamp: time,
        temperature: temp,
      ));
    }

    return readings;
  }

  @override
  Future<void> updateUnit({
    required String unitId,
    bool? power,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate network

    if (!_units.containsKey(unitId)) return;

    final unit = _units[unitId]!;
    final updatedUnit = unit.copyWith(
      power: power ?? unit.power,
      targetTemp: targetTemp ?? unit.targetTemp,
      mode: mode ?? unit.mode,
      fanSpeed: fanSpeed ?? unit.fanSpeed,
      timestamp: DateTime.now(),
    );

    _units[unitId] = updatedUnit;

    // Emit updated unit
    if (_unitControllers.containsKey(unitId)) {
      _unitControllers[unitId]!.add(updatedUnit);
    }

    _unitsController.add(_units.values.toList());
  }

  /// Dispose resources
  void dispose() {
    _updateTimer?.cancel();
    _unitsController.close();
    for (var controller in _unitControllers.values) {
      controller.close();
    }
  }
}
