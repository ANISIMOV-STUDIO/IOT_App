/// JSON Mapper: HTTP JSON ↔ Domain entities
library;

import '../../../domain/entities/hvac_device.dart';
import '../../../domain/entities/climate.dart';
import 'package:flutter/material.dart';

class DeviceJsonMapper {
  /// JSON → Domain HvacDevice
  static HvacDevice hvacDeviceFromJson(Map<String, dynamic> json) {
    return HvacDevice(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown Device',
      brand: json['brand'] as String? ?? 'ZILON',
      type: json['type'] as String? ?? 'Ventilation',
      isOnline: json['isOnline'] as bool? ?? true,
      isActive: json['power'] as bool? ?? false,
      icon: Icons.air,
    );
  }

  /// JSON → Domain ClimateState
  static ClimateState climateStateFromJson(Map<String, dynamic> json) {
    return ClimateState(
      roomId: json['id'] as String? ?? json['deviceId'] as String,
      deviceName: json['name'] as String? ?? 'Unknown Device',
      currentTemperature:
          (json['currentTemp'] as num?)?.toDouble() ?? 20.0,
      targetTemperature: (json['temp'] as num?)?.toDouble() ?? 22.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 50.0,
      targetHumidity: (json['targetHumidity'] as num?)?.toDouble() ?? 50.0,
      supplyAirflow: _fanSpeedToPercent(json['supplyFan'] as String?),
      exhaustAirflow: _fanSpeedToPercent(json['exhaustFan'] as String?),
      mode: _stringToClimateMode(json['mode'] as String?),
      preset: json['preset'] as String? ?? 'auto',
      airQuality: _stringToAirQuality(json['airQuality'] as String?),
      co2Ppm: json['co2'] as int? ?? 400,
      pollutantsAqi: json['pollutantsAqi'] as int? ?? 50,
      isOn: json['power'] as bool? ?? false,
    );
  }

  /// String mode → ClimateMode enum
  static ClimateMode _stringToClimateMode(String? mode) {
    if (mode == null) return ClimateMode.auto;

    switch (mode.toLowerCase()) {
      case 'heat':
      case 'heating':
        return ClimateMode.heating;
      case 'cool':
      case 'cooling':
        return ClimateMode.cooling;
      case 'auto':
        return ClimateMode.auto;
      case 'fan':
      case 'fan_only':
      case 'ventilation':
        return ClimateMode.ventilation;
      case 'dry':
        return ClimateMode.dry;
      case 'off':
        return ClimateMode.off;
      default:
        return ClimateMode.auto;
    }
  }

  /// ClimateMode enum → String
  static String climateModeToString(ClimateMode mode) {
    switch (mode) {
      case ClimateMode.heating:
        return 'heat';
      case ClimateMode.cooling:
        return 'cool';
      case ClimateMode.auto:
        return 'auto';
      case ClimateMode.ventilation:
        return 'fan_only';
      case ClimateMode.dry:
        return 'dry';
      case ClimateMode.off:
        return 'off';
    }
  }

  /// String air quality → AirQualityLevel enum
  static AirQualityLevel _stringToAirQuality(String? quality) {
    if (quality == null) return AirQualityLevel.good;

    switch (quality.toLowerCase()) {
      case 'excellent':
        return AirQualityLevel.excellent;
      case 'good':
        return AirQualityLevel.good;
      case 'moderate':
      case 'fair':
        return AirQualityLevel.moderate;
      case 'poor':
        return AirQualityLevel.poor;
      default:
        return AirQualityLevel.good;
    }
  }

  /// FanSpeed string → Percent (0-100)
  static double _fanSpeedToPercent(String? speed) {
    if (speed == null) return 50.0;

    switch (speed.toLowerCase()) {
      case 'low':
        return 33.0;
      case 'medium':
        return 66.0;
      case 'high':
        return 100.0;
      case 'auto':
        return 50.0;
      default:
        return 50.0;
    }
  }

  /// Percent → FanSpeed string
  static String percentToFanSpeed(double percent) {
    // Ограничить значение в диапазоне 0-100
    final clamped = percent.clamp(0.0, 100.0);

    if (clamped < 33) return 'low';
    if (clamped < 66) return 'medium';
    return 'high'; // 66-100
  }
}
