/// JSON Mapper: HTTP JSON ↔ Domain entities
///
/// Маппер для преобразования JSON данных в доменные сущности.
/// Не содержит Flutter зависимостей - только Dart.
library;

import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/entities/sensor_history.dart';

class DeviceJsonMapper {
  /// JSON → Domain HvacDevice
  static HvacDevice hvacDeviceFromJson(Map<String, dynamic> json) => HvacDevice(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown Device',
      macAddress: json['macAddress'] as String? ?? '',
      deviceType: _stringToDeviceType(json['type'] as String?),
      isOnline: json['isOnline'] as bool? ?? true,
      isActive: json['running'] as bool? ?? false, // running = фактически работает
      operatingMode: _modeToOperatingMode(json['mode'] as String?),
      isScheduleEnabled: json['scheduleEnabled'] as bool? ?? false,
    );

  /// Преобразование строки типа в enum
  static HvacDeviceType _stringToDeviceType(String? type) {
    if (type == null) {
      return HvacDeviceType.ventilation;
    }

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
  static ClimateState climateStateFromJson(Map<String, dynamic> json) => ClimateState(
      roomId: json['id'] as String? ?? json['deviceId'] as String? ?? '',
      deviceName: json['name'] as String? ?? 'Unknown Device',
      currentTemperature:
          (json['roomTemperature'] as num?)?.toDouble() ?? 20.0,
      targetTemperature: (json['temperatureSetpoint'] as num?)?.toDouble() ?? 22.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 50.0,
      targetHumidity: (json['targetHumidity'] as num?)?.toDouble() ?? 50.0,
      supplyAirflow: parseFanValue(json['supplyFan']),
      exhaustAirflow: parseFanValue(json['exhaustFan']),
      mode: _stringToClimateMode(json['mode'] as String?),
      // Используем mode как operating mode (basic, intensive, etc.)
      // Backend возвращает Mode как "Basic", "Intensive" и т.д.
      preset: _modeToOperatingMode(json['mode'] as String?),
      airQuality: _stringToAirQuality(json['airQuality'] as String?),
      co2Ppm: json['co2'] as int? ?? 400,
      pollutantsAqi: json['pollutantsAqi'] as int? ?? 50,
      isOn: json['running'] as bool? ?? false, // running = device is on
    );

  /// Конвертирует имя режима от бэкенда в snake_case для API
  /// Backend: "Basic", "Intensive", "MaxPerformance"
  /// API: "basic", "intensive", "max_performance"
  static String _modeToOperatingMode(String? mode) {
    if (mode == null || mode.isEmpty) {
      return 'basic';
    }
    
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
    if (mode == null) {
      return ClimateMode.auto;
    }

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
    if (quality == null) {
      return AirQualityLevel.good;
    }

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
  static double parseFanValue(dynamic value) {
    if (value == null) {
      return 50;
    }

    // Если int - возвращаем напрямую как double
    if (value is int) {
      return value.toDouble();
    }
    if (value is num) {
      return value.toDouble();
    }

    // Если String - конвертируем по названию
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'low':
          return 33;
        case 'medium':
          return 66;
        case 'high':
          return 100;
        case 'auto':
          return 50;
        default:
          // Попробовать распарсить как число
          return double.tryParse(value) ?? 50.0;
      }
    }

    return 50;
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

    if (clamped < 33) {
      return 'low';
    }
    if (clamped < 66) {
      return 'medium';
    }
    return 'high'; // 66-100
  }

  /// Безопасная конвертация любого Map в Map<String, dynamic>
  static Map<String, dynamic>? _safeMapCast(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(
        value.map((k, v) => MapEntry(k?.toString() ?? '', v)),
      );
    }
    return null;
  }

  /// Парсинг настроек режимов из JSON объекта
  static Map<String, ModeSettings>? modeSettingsFromJson(Object? json) {
    final map = _safeMapCast(json);
    if (map == null) {
      return null;
    }
    return map.map((key, value) {
      final valueMap = _safeMapCast(value);
      return MapEntry(
        key,
        ModeSettings.fromJson(valueMap ?? <String, dynamic>{}),
      );
    });
  }

  /// Парсинг настроек таймера из JSON объекта
  static Map<String, TimerSettings>? timerSettingsFromJson(Object? json) {
    final map = _safeMapCast(json);
    if (map == null) {
      return null;
    }
    return map.map((key, value) {
      final valueMap = _safeMapCast(value);
      return MapEntry(
        key.toLowerCase(),
        TimerSettings.fromJson(valueMap ?? <String, dynamic>{}),
      );
    });
  }

  /// Парсинг активных аварий из JSON объекта
  static Map<String, AlarmInfo>? activeAlarmsFromJson(Object? json) {
    final map = _safeMapCast(json);
    if (map == null) {
      return null;
    }
    return map.map((key, value) {
      final valueMap = _safeMapCast(value);
      return MapEntry(
        key,
        AlarmInfo.fromJson(valueMap ?? <String, dynamic>{}),
      );
    });
  }

  /// Парсинг истории аварий из JSON списка
  static List<AlarmHistory> alarmHistoryListFromJson(List<dynamic> json) => json
        .map((item) {
          final itemMap = _safeMapCast(item);
          return AlarmHistory.fromJson(itemMap ?? <String, dynamic>{});
        })
        .toList();

  /// JSON → DeviceFullState (полное состояние с настройками и авариями)
  static DeviceFullState deviceFullStateFromJson(Map<String, dynamic> json) => DeviceFullState(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown Device',
      macAddress: json['macAddress'] as String? ?? '',
      power: json['running'] as bool? ?? false,
      mode: _stringToClimateMode(json['mode'] as String?),
      currentTemperature: (json['roomTemperature'] as num?)?.toDouble() ?? 20.0,
      targetTemperature: (json['temperatureSetpoint'] as num?)?.toDouble() ?? 22.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 50.0,
      targetHumidity: (json['targetHumidity'] as num?)?.toDouble() ?? 50.0,
      operatingMode: _modeToOperatingMode(json['mode'] as String?),
      scheduleIndicator: json['scheduleEnabled'] == true ? 1 : 0,
      isOnline: json['isOnline'] as bool? ?? true,
      outdoorTemperature: (json['outdoorTemperature'] as num?)?.toDouble(),
      kpdRecuperator: json['kpdRecuperator'] as int?,
      recuperatorTemperature: (json['recuperatorTemperature'] as num?)?.toDouble(),
      // Новые датчики с бэкенда
      indoorTemperature: (json['roomTemperature'] as num?)?.toDouble(),
      supplyTemperature: (json['supplyTemperature'] as num?)?.toDouble(),
      coIndicator: json['coIndicator'] as int?,
      freeCooling: json['freeCooling'] as bool? ?? false,
      heaterPower: json['power'] as int?,
      coolerStatus: json['coolerStatusLabel'] as String?,
      ductPressure: json['pressure'] as int?,
      // Фактические обороты вентиляторов и уставка температуры
      actualSupplyFan: json['actualSupplyFan'] as int?,
      actualExhaustFan: json['actualExhaustFan'] as int?,
      temperatureSetpoint: (json['temperatureSetpoint'] as num?)?.toDouble(),
      modeSettings: modeSettingsFromJson(json['modeSettings']),
      timerSettings: timerSettingsFromJson(json['timerSettings']),
      activeAlarms: activeAlarmsFromJson(json['activeAlarms']),
      isScheduleEnabled: json['scheduleEnabled'] as bool? ?? false,
      quickSensors: _parseQuickSensors(json['quickSensors']),
      deviceTime: _parseDeviceTime(json),
      updatedAt: _parseDateTime(json['updatedAt'] as String?),
    );

  /// Парсинг ISO DateTime строки
  static DateTime? _parseDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) {
      return null;
    }
    return DateTime.tryParse(dateTimeStr);
  }

  /// Парсинг времени устройства из JSON
  static DateTime? _parseDeviceTime(Map<String, dynamic> json) {
    // Вариант 1: ISO строка deviceTime
    final deviceTimeStr = json['deviceTime'] as String?;
    if (deviceTimeStr != null) {
      return DateTime.tryParse(deviceTimeStr);
    }

    // Вариант 2: отдельные поля date и time
    final dateStr = json['date'] as String?;
    final timeStr = json['time'] as String?;
    if (dateStr != null && timeStr != null) {
      return DateTime.tryParse('$dateStr $timeStr');
    }

    return null;
  }

  /// Парсинг quickSensors из JSON
  static List<String> _parseQuickSensors(dynamic json) {
    const defaultSensors = ['outside_temp', 'indoor_temp', 'humidity'];
    // null = не настроено, используем дефолтные
    if (json == null) {
      return defaultSensors;
    }
    if (json is List) {
      // Возвращаем что есть (0-3 сенсора)
      return json.whereType<String>().toList();
    }
    return defaultSensors;
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
  static List<SensorHistory> sensorHistoryListFromJson(List<dynamic> json) => json
        .map((item) {
          final itemMap = _safeMapCast(item);
          return sensorHistoryFromJson(itemMap ?? <String, dynamic>{});
        })
        .toList();
}
