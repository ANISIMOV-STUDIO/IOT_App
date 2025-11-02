/// Mock HVAC Repository
///
/// Fake implementation for testing and development with ventilation support
library;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/device_type.dart';
import '../../domain/entities/ventilation_mode.dart';
import '../../domain/entities/mode_preset.dart';
import '../../domain/entities/week_schedule.dart';
import '../../domain/entities/day_schedule.dart';
import '../../domain/entities/wifi_status.dart';
import '../../domain/entities/alert.dart';
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

  /// Initialize with mock data (ventilation units)
  void _initializeMockData() {
    final now = DateTime.now();

    // Вентиляционная установка 1 - Гостиная (Базовый режим)
    _units['vent1'] = HvacUnit(
      id: 'vent1',
      name: 'ПВУ-1',
      location: 'Гостиная',
      power: true,
      currentTemp: 21.5,
      targetTemp: 22.0,
      mode: 'auto',
      fanSpeed: 'auto',
      timestamp: now,
      macAddress: 'AA:BB:CC:DD:EE:01',
      humidity: 45.0,
      deviceType: DeviceType.ventilation,
      // Ventilation-specific
      supplyAirTemp: 20.3,
      roomTemp: 21.5,
      outdoorTemp: 17.8,
      heatingTemp: 23.0,
      coolingTemp: 23.0,
      supplyFanSpeed: 70,
      exhaustFanSpeed: 50,
      ventMode: VentilationMode.basic,
      modePresets: ModePreset.defaults,
      schedule: _createDefaultSchedule(),
      wifiStatus: const WiFiStatus(
        isConnected: true,
        connectedSSID: 'Home_WiFi_5G',
        stationPassword: 'demo_password',
        apSSID: 'PVU-ESP8266',
        apPassword: '12345678',
        signalStrength: -47,
        ipAddress: '192.168.1.105',
        macAddress: 'AA:BB:CC:DD:EE:01',
      ),
      alerts: const [],
    );

    // Вентиляционная установка 2 - Спальня (Экономичный режим)
    _units['vent2'] = HvacUnit(
      id: 'vent2',
      name: 'ПВУ-2',
      location: 'Спальня',
      power: true,
      currentTemp: 22.0,
      targetTemp: 21.0,
      mode: 'auto',
      fanSpeed: 'low',
      timestamp: now,
      macAddress: 'AA:BB:CC:DD:EE:02',
      humidity: 48.0,
      deviceType: DeviceType.ventilation,
      // Ventilation-specific
      supplyAirTemp: 18.5,
      roomTemp: 22.0,
      outdoorTemp: 17.8,
      heatingTemp: 18.0,
      coolingTemp: 28.0,
      supplyFanSpeed: 20,
      exhaustFanSpeed: 20,
      ventMode: VentilationMode.economic,
      modePresets: ModePreset.defaults,
      schedule: _createNightSchedule(),
      wifiStatus: const WiFiStatus(
        isConnected: true,
        connectedSSID: 'Home_WiFi_5G',
        stationPassword: 'demo_password',
        apSSID: 'PVU-ESP8267',
        apPassword: '12345678',
        signalStrength: -55,
        ipAddress: '192.168.1.106',
        macAddress: 'AA:BB:CC:DD:EE:02',
      ),
      alerts: const [],
    );

    // Вентиляционная установка 3 - Кухня (Режим "Кухня" с усиленной вытяжкой)
    _units['vent3'] = HvacUnit(
      id: 'vent3',
      name: 'ПВУ-3',
      location: 'Кухня',
      power: false,
      currentTemp: 23.5,
      targetTemp: 22.0,
      mode: 'fan',
      fanSpeed: 'medium',
      timestamp: now,
      macAddress: 'AA:BB:CC:DD:EE:03',
      humidity: 55.0,
      deviceType: DeviceType.ventilation,
      // Ventilation-specific
      supplyAirTemp: 21.0,
      roomTemp: 23.5,
      outdoorTemp: 17.8,
      heatingTemp: 20.0,
      coolingTemp: 24.0,
      supplyFanSpeed: 0, // Выключено
      exhaustFanSpeed: 0, // Выключено
      ventMode: VentilationMode.kitchen,
      modePresets: ModePreset.defaults,
      schedule: _createKitchenSchedule(),
      wifiStatus: const WiFiStatus(
        isConnected: true,
        connectedSSID: 'Home_WiFi_5G',
        stationPassword: 'demo_password',
        apSSID: 'PVU-ESP8268',
        apPassword: '12345678',
        signalStrength: -62,
        ipAddress: '192.168.1.107',
        macAddress: 'AA:BB:CC:DD:EE:03',
      ),
      alerts: [
        Alert(
          code: 9,
          timestamp: now.subtract(const Duration(days: 3)),
          description: Alert.getDescription(9),
          severity: Alert.getSeverity(9),
        ),
      ],
    );

    // Вентиляционная установка 4 - Кабинет (Интенсивный режим)
    _units['vent4'] = HvacUnit(
      id: 'vent4',
      name: 'ПВУ-4',
      location: 'Кабинет',
      power: true,
      currentTemp: 20.5,
      targetTemp: 21.0,
      mode: 'heating',
      fanSpeed: 'high',
      timestamp: now,
      macAddress: 'AA:BB:CC:DD:EE:04',
      humidity: 42.0,
      deviceType: DeviceType.ventilation,
      // Ventilation-specific
      supplyAirTemp: 19.8,
      roomTemp: 20.5,
      outdoorTemp: 17.8,
      heatingTemp: 21.0,
      coolingTemp: 25.0,
      supplyFanSpeed: 70,
      exhaustFanSpeed: 70,
      ventMode: VentilationMode.intensive,
      modePresets: ModePreset.defaults,
      schedule: WeekSchedule.defaultSchedule,
      wifiStatus: const WiFiStatus(
        isConnected: true,
        connectedSSID: 'Home_WiFi_5G',
        stationPassword: 'demo_password',
        apSSID: 'PVU-ESP8269',
        apPassword: '12345678',
        signalStrength: -50,
        ipAddress: '192.168.1.108',
        macAddress: 'AA:BB:CC:DD:EE:04',
      ),
      alerts: const [],
    );
  }

  /// Create default schedule (weekdays 7:00-20:00)
  WeekSchedule _createDefaultSchedule() {
    const weekdaySchedule = DaySchedule(
      turnOnTime: TimeOfDay(hour: 7, minute: 0),
      turnOffTime: TimeOfDay(hour: 20, minute: 0),
      timerEnabled: true,
    );
    const weekendSchedule = DaySchedule(
      turnOnTime: TimeOfDay(hour: 9, minute: 0),
      turnOffTime: TimeOfDay(hour: 22, minute: 0),
      timerEnabled: true,
    );
    return const WeekSchedule(
      monday: weekdaySchedule,
      tuesday: weekdaySchedule,
      wednesday: weekdaySchedule,
      thursday: weekdaySchedule,
      friday: weekdaySchedule,
      saturday: weekendSchedule,
      sunday: weekendSchedule,
    );
  }

  /// Create night schedule (for bedroom - 22:00-7:00)
  WeekSchedule _createNightSchedule() {
    const nightSchedule = DaySchedule(
      turnOnTime: TimeOfDay(hour: 22, minute: 0),
      turnOffTime: TimeOfDay(hour: 7, minute: 0),
      timerEnabled: true,
    );
    return const WeekSchedule(
      monday: nightSchedule,
      tuesday: nightSchedule,
      wednesday: nightSchedule,
      thursday: nightSchedule,
      friday: nightSchedule,
      saturday: nightSchedule,
      sunday: nightSchedule,
    );
  }

  /// Create kitchen schedule (meal times)
  WeekSchedule _createKitchenSchedule() {
    const mealSchedule = DaySchedule(
      turnOnTime: TimeOfDay(hour: 12, minute: 0),
      turnOffTime: TimeOfDay(hour: 20, minute: 0),
      timerEnabled: true,
    );
    return const WeekSchedule(
      monday: mealSchedule,
      tuesday: mealSchedule,
      wednesday: mealSchedule,
      thursday: mealSchedule,
      friday: mealSchedule,
      saturday: mealSchedule,
      sunday: mealSchedule,
    );
  }

  /// Simulate temperature and sensor changes
  void _startSimulation() {
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_connected) return;

      final random = Random();
      for (var entry in _units.entries) {
        final unit = entry.value;
        if (!unit.power) continue;

        // Simulate temperature changes
        var newSupplyTemp = unit.supplyAirTemp ?? unit.currentTemp;
        var newRoomTemp = unit.roomTemp ?? unit.currentTemp;

        // Supply air temperature approaches heating/cooling setpoint
        if (unit.isVentilation && unit.heatingTemp != null) {
          final targetSupply = unit.heatingTemp!;
          final diff = targetSupply - newSupplyTemp;
          if (diff.abs() > 0.1) {
            newSupplyTemp += diff * 0.15 + (random.nextDouble() - 0.5) * 0.3;
          } else {
            newSupplyTemp += (random.nextDouble() - 0.5) * 0.2;
          }
        }

        // Room temperature slowly approaches supply air temperature
        final roomDiff = newSupplyTemp - newRoomTemp;
        newRoomTemp += roomDiff * 0.05 + (random.nextDouble() - 0.5) * 0.1;

        // Current temp = room temp (for compatibility)
        final newCurrentTemp = newRoomTemp;

        // Humidity simulation (45-55% range)
        var newHumidity = unit.humidity + (random.nextDouble() - 0.5) * 2.0;
        newHumidity = newHumidity.clamp(40.0, 60.0);

        final updatedUnit = unit.copyWith(
          supplyAirTemp: newSupplyTemp,
          roomTemp: newRoomTemp,
          currentTemp: newCurrentTemp,
          humidity: newHumidity,
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

    final baseTemp = unit.targetTemp;
    for (int i = hours * 12; i >= 0; i--) {
      final time = now.subtract(Duration(minutes: i * 5));
      final temp = baseTemp +
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
  @Deprecated('Use updateUnitEntity instead')
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

  @override
  Future<void> updateUnitEntity(HvacUnit unit) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate network

    if (!_units.containsKey(unit.id)) return;

    final updatedUnit = unit.copyWith(timestamp: DateTime.now());
    _units[unit.id] = updatedUnit;

    // Emit updated unit
    if (_unitControllers.containsKey(unit.id)) {
      _unitControllers[unit.id]!.add(updatedUnit);
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
