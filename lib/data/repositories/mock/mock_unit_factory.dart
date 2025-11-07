/// Mock Unit Factory
///
/// Factory for creating mock HVAC units for testing
library;

import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/device_type.dart';
import '../../../domain/entities/ventilation_mode.dart';
import '../../../domain/entities/mode_preset.dart';
import '../../../domain/entities/wifi_status.dart';
import 'mock_schedule_factory.dart';

/// Factory for creating mock HVAC units
class MockUnitFactory {
  MockUnitFactory._();

  /// Create mock living room ventilation unit
  static HvacUnit createLivingRoomUnit() {
    final now = DateTime.now();
    return HvacUnit(
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
      supplyAirTemp: 20.3,
      roomTemp: 21.5,
      outdoorTemp: 17.8,
      heatingTemp: 23.0,
      coolingTemp: 23.0,
      supplyFanSpeed: 70,
      exhaustFanSpeed: 50,
      ventMode: VentilationMode.basic,
      modePresets: ModePreset.defaults,
      schedule: MockScheduleFactory.createDefaultSchedule(),
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
  }

  /// Create mock bedroom ventilation unit
  static HvacUnit createBedroomUnit() {
    final now = DateTime.now();
    return HvacUnit(
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
      supplyAirTemp: 18.5,
      roomTemp: 22.0,
      outdoorTemp: 17.8,
      heatingTemp: 18.0,
      coolingTemp: 28.0,
      supplyFanSpeed: 20,
      exhaustFanSpeed: 20,
      ventMode: VentilationMode.economic,
      modePresets: ModePreset.defaults,
      schedule: MockScheduleFactory.createNightSchedule(),
      wifiStatus: const WiFiStatus(
        isConnected: true,
        connectedSSID: 'Home_WiFi_5G',
        stationPassword: 'demo_password',
        apSSID: 'PVU-ESP8266',
        apPassword: '12345678',
        signalStrength: -52,
        ipAddress: '192.168.1.106',
        macAddress: 'AA:BB:CC:DD:EE:02',
      ),
      alerts: const [],
    );
  }

  /// Create mock kitchen ventilation unit
  static HvacUnit createKitchenUnit() {
    final now = DateTime.now();
    return HvacUnit(
      id: 'vent3',
      name: 'ПВУ-3',
      location: 'Кухня',
      power: false,
      currentTemp: 23.5,
      targetTemp: 23.0,
      mode: 'cool',
      fanSpeed: 'medium',
      timestamp: now,
      macAddress: 'AA:BB:CC:DD:EE:03',
      humidity: 52.0,
      deviceType: DeviceType.ventilation,
      supplyAirTemp: 22.0,
      roomTemp: 23.5,
      outdoorTemp: 17.8,
      heatingTemp: 18.0,
      coolingTemp: 21.0,
      supplyFanSpeed: 50,
      exhaustFanSpeed: 90,
      ventMode: VentilationMode.kitchen,
      modePresets: ModePreset.defaults,
      schedule: MockScheduleFactory.createKitchenSchedule(),
      wifiStatus: const WiFiStatus(
        isConnected: false,
        connectedSSID: '',
        stationPassword: '',
        apSSID: 'PVU-ESP8266',
        apPassword: '12345678',
        signalStrength: 0,
        ipAddress: '',
        macAddress: 'AA:BB:CC:DD:EE:03',
      ),
      alerts: const [],
    );
  }

  /// Get all default mock units
  static Map<String, HvacUnit> createAllUnits() {
    return {
      'vent1': createLivingRoomUnit(),
      'vent2': createBedroomUnit(),
      'vent3': createKitchenUnit(),
    };
  }
}
