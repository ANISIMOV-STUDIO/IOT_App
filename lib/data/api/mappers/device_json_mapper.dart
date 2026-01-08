/// JSON Mapper: HTTP JSON ↔ Domain entities
///
/// Маппер для преобразования JSON данных в доменные сущности.
/// Не содержит Flutter зависимостей - только Dart.
library;
import 'package:flutter/foundation.dart';
import '../../../domain/entities/hvac_device.dart';
import '../../../domain/entities/climate.dart';
import '../../../domain/entities/alarm_info.dart';
import '../../../domain/entities/mode_settings.dart';
import '../../../domain/entities/device_full_state.dart';
import '../../../domain/entities/sensor_history.dart';

class DeviceJsonMapper {
  /// JSON → Domain HvacDevice
  static HvacDevice hvacDeviceFromJson(Map<String, dynamic> json) {
    return HvacDevice(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown Device',
      brand: json['brand'] as String? ?? 'ZILON',
      deviceType: _stringToDeviceType(json['type'] as String?),
      isOnline: json['isOnline'] as bool? ?? true,
      isActive: json['running'] as bool? ?? false, // running = фактически работает
    );
  }

  /// Преобразование строки типа в enum
  static HvacDeviceType _stringToDeviceType(String? type) {
    if (type == null) return HvacDeviceType.ventilation;

    switch (type.toLowerCase()) {
      case 'ventilation':
      case 'vent':
        return HvacDeviceType.ventilation;
      case 'airconditioner':
      case 'ac':
      case 'air_conditioner':
        return HvacDeviceType.airConditioner;
      case 'heatpump':
      case 'heat_pump':
        return HvacDeviceType.heatPump;
      default:
        return HvacDeviceType.generic;
    }
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
      supplyAirflow: _parseFanValue(json['supplyFan']),
      exhaustAirflow: _parseFanValue(json['exhaustFan']),
      mode: _stringToClimateMode(json['mode'] as String?),
      // Используем mode как operating mode (basic, intensive, etc.)
      // Backend возвращает Mode как "Basic", "Intensive" и т.д.
      preset: _modeToOperatingMode(json['mode'] as String?),
      airQuality: _stringToAirQuality(json['airQuality'] as String?),
      co2Ppm: json['co2'] as int? ?? 400,
      pollutantsAqi: json['pollutantsAqi'] as int? ?? 50,
      isOn: json['running'] as bool? ?? false, // running = device is on
    );
  }

  /// Конвертирует имя режима от бэкенда в snake_case для API
  /// Backend: "Basic", "Intensive", "MaxPerformance"
  /// API: "basic", "intensive", "max_performance"
  static String _modeToOperatingMode(String? mode) {
    if (mode == null || mode.isEmpty) return 'basic';
    
    final lower = mode.toLowerCase();
    return switch (lower) {
      'maxperformance' => 'max_performance',
      'basic' => 'basic',
      'intensive' => 'intensive',
      'economy' => 'economy',
      'kitchen' => 'kitchen',
      'fireplace' => 'fireplace',
      'vacation' => 'vacation',
      'custom' => 'custom',
      _ => 'basic', // Default to basic for unknown modes
    };
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

  /// Parse fan value (can be int or String) → Percent (0-100)
  static double _parseFanValue(dynamic value) {
    if (value == null) return 50.0;

    // Если int - возвращаем напрямую как double
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();

    // Если String - конвертируем по названию
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'low':
          return 33.0;
        case 'medium':
          return 66.0;
        case 'high':
          return 100.0;
        case 'auto':
          return 50.0;
        default:
          // Попробовать распарсить как число
          return double.tryParse(value) ?? 50.0;
      }
    }

    return 50.0;
  }


  /// Percent (0-100) → FanSpeed int (20-100)
  /// UI использует 0-100%, API ожидает 20-100
  static int percentToFanSpeedInt(double percent) {
    // Ограничить значение в диапазоне 20-100
    final clamped = percent.clamp(20.0, 100.0);
    return clamped.round();
  }
  /// Percent → FanSpeed string
  static String percentToFanSpeed(double percent) {
    // Ограничить значение в диапазоне 0-100
    final clamped = percent.clamp(0.0, 100.0);

    if (clamped < 33) return 'low';
    if (clamped < 66) return 'medium';
    return 'high'; // 66-100
  }

  /// Парсинг настроек режимов из JSON объекта
  static Map<String, ModeSettings>? modeSettingsFromJson(
      Map<String, dynamic>? json) {
    if (json == null) return null;
    return json.map((key, value) =>
        MapEntry(key, ModeSettings.fromJson(value as Map<String, dynamic>)));
  }

  /// Парсинг настроек таймера из JSON объекта
  static Map<String, TimerSettings>? timerSettingsFromJson(
      Map<String, dynamic>? json) {
    if (json == null) return null;
    return json.map((key, value) => MapEntry(
        key.toLowerCase(), TimerSettings.fromJson(value as Map<String, dynamic>)));
  }

  /// Парсинг активных аварий из JSON объекта
  static Map<String, AlarmInfo>? activeAlarmsFromJson(
      Map<String, dynamic>? json) {
    if (json == null) return null;
    return json.map((key, value) =>
        MapEntry(key, AlarmInfo.fromJson(value as Map<String, dynamic>)));
  }

  /// Парсинг истории аварий из JSON списка
  static List<AlarmHistory> alarmHistoryListFromJson(List<dynamic> json) {
    return json
        .map((item) => AlarmHistory.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// JSON → DeviceFullState (полное состояние с настройками и авариями)
  static DeviceFullState deviceFullStateFromJson(Map<String, dynamic> json) {
    return DeviceFullState(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown Device',
      macAddress: json['macAddress'] as String? ?? '',
      power: () {
        final running = json['running'] as bool? ?? false;
        debugPrint('🔋 DeviceFullState power from JSON: running=$running (raw=${json['running']})');
        return running;
      }(),
      mode: _stringToClimateMode(json['mode'] as String?),
      currentTemperature: (json['currentTemp'] as num?)?.toDouble() ?? 20.0,
      targetTemperature: (json['temp'] as num?)?.toDouble() ?? 22.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 50.0,
      heatingTemperature: json['heatingTemperature'] as int?,
      coolingTemperature: json['coolingTemperature'] as int?,
      supplyFan: json['supplyFan']?.toString(),
      exhaustFan: json['exhaustFan']?.toString(),
      scheduleIndicator: json['scheduleIndicator'] as int?,
      devicePower: json['devicePower'] as int?,
      isOnline: json['isOnline'] as bool? ?? true,
      outdoorTemperature: (json['outdoorTemperature'] as num?)?.toDouble(),
      kpdRecuperator: json['kpdRecuperator'] as int?,
      // Новые датчики с бэкенда
      indoorTemperature: (json['roomTemperature'] as num?)?.toDouble(),
      supplyTemperature: (json['supplyTemperature'] as num?)?.toDouble(),
      supplyTempAfterRecup: (json['temperatureSetpoint'] as num?)?.toDouble(),
      co2Level: json['coIndicator'] as int?,
      freeCooling: json['statusOhl'] as int?,
      heaterPerformance: json['devicePower'] as int?,
      coolerStatus: (json['running'] as bool? ?? false) ? 100 : 0,
      ductPressure: json['pressure'] as int?,
      modeSettings: json['modeSettings'] != null
          ? modeSettingsFromJson(json['modeSettings'] as Map<String, dynamic>)
          : null,
      timerSettings: json['timerSettings'] != null
          ? timerSettingsFromJson(json['timerSettings'] as Map<String, dynamic>)
          : null,
      activeAlarms: json['activeAlarms'] != null
          ? activeAlarmsFromJson(json['activeAlarms'] as Map<String, dynamic>)
          : null,
    );
  }

  // ============================================
  // ИСТОРИЯ ДАТЧИКОВ
  // ============================================

  /// JSON → SensorHistory entity
  static SensorHistory sensorHistoryFromJson(Map<String, dynamic> json) {
    // Безопасный парсинг timestamp с fallback на текущее время
    final timestampStr = json['timestamp'] as String?;
    final timestamp = timestampStr != null
        ? DateTime.tryParse(timestampStr) ?? DateTime.now()
        : DateTime.now();

    return SensorHistory(
      id: json['id'] as String? ?? '',
      timestamp: timestamp,
      supplyTemperature: (json['supplyTemperature'] as num?)?.toDouble(),
      roomTemperature: (json['roomTemperature'] as num?)?.toDouble(),
      outdoorTemperature: (json['outdoorTemperature'] as num?)?.toDouble(),
      humidity: json['humidity'] as int?,
      supplyFan: json['supplyFan'] as int?,
      exhaustFan: json['exhaustFan'] as int?,
      power: json['power'] as int?,
    );
  }

  /// JSON List → List<SensorHistory>
  static List<SensorHistory> sensorHistoryListFromJson(List<dynamic> json) {
    return json
        .map((item) => sensorHistoryFromJson(item as Map<String, dynamic>))
        .toList();
  }
}
