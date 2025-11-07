/// HVAC Unit Model
///
/// Data model for HVAC/Ventilation Unit with JSON serialization
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/device_type.dart';
import '../../domain/entities/ventilation_mode.dart';
import '../../domain/entities/mode_preset.dart';
import '../../domain/entities/week_schedule.dart';
import '../../domain/entities/day_schedule.dart';
import '../../domain/entities/wifi_status.dart';
import '../../domain/entities/alert.dart';

class HvacUnitModel extends HvacUnit {
  const HvacUnitModel({
    required super.id,
    required super.name,
    required super.power,
    required super.currentTemp,
    required super.targetTemp,
    required super.mode,
    required super.fanSpeed,
    required super.timestamp,
    super.macAddress,
    super.location,
    super.humidity,
    super.deviceType,
    super.supplyAirTemp,
    super.roomTemp,
    super.outdoorTemp,
    super.heatingTemp,
    super.coolingTemp,
    super.supplyFanSpeed,
    super.exhaustFanSpeed,
    super.ventMode,
    super.modePresets,
    super.schedule,
    super.wifiStatus,
    super.alerts,
  });

  /// Create from JSON
  factory HvacUnitModel.fromJson(Map<String, dynamic> json) {
    return HvacUnitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      power: json['power'] as bool,
      currentTemp: (json['currentTemp'] as num).toDouble(),
      targetTemp: (json['targetTemp'] as num).toDouble(),
      mode: json['mode'] as String,
      fanSpeed: json['fanSpeed'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      macAddress: json['macAddress'] as String?,
      location: json['location'] as String?,
      humidity: json['humidity'] != null
          ? (json['humidity'] as num).toDouble()
          : 50.0,
      deviceType: json['deviceType'] != null
          ? DeviceType.values.firstWhere(
              (e) => e.name == json['deviceType'],
              orElse: () => DeviceType.hvac,
            )
          : DeviceType.hvac,
      supplyAirTemp: json['supplyAirTemp'] != null
          ? (json['supplyAirTemp'] as num).toDouble()
          : null,
      roomTemp: json['roomTemp'] != null
          ? (json['roomTemp'] as num).toDouble()
          : null,
      outdoorTemp: json['outdoorTemp'] != null
          ? (json['outdoorTemp'] as num).toDouble()
          : null,
      heatingTemp: json['heatingTemp'] != null
          ? (json['heatingTemp'] as num).toDouble()
          : null,
      coolingTemp: json['coolingTemp'] != null
          ? (json['coolingTemp'] as num).toDouble()
          : null,
      supplyFanSpeed: json['supplyFanSpeed'] as int?,
      exhaustFanSpeed: json['exhaustFanSpeed'] as int?,
      ventMode: json['ventMode'] != null
          ? VentilationMode.values.firstWhere(
              (e) => e.name == json['ventMode'],
              orElse: () => VentilationMode.basic,
            )
          : null,
      modePresets: json['modePresets'] != null
          ? _parsePresets(json['modePresets'] as Map<String, dynamic>)
          : null,
      schedule: json['schedule'] != null
          ? _parseSchedule(json['schedule'] as Map<String, dynamic>)
          : null,
      wifiStatus: json['wifiStatus'] != null
          ? _parseWiFiStatus(json['wifiStatus'] as Map<String, dynamic>)
          : null,
      alerts: json['alerts'] != null
          ? (json['alerts'] as List)
              .map((a) => _parseAlert(a as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// Parse mode presets from JSON
  static Map<VentilationMode, ModePreset> _parsePresets(
      Map<String, dynamic> json) {
    final presets = <VentilationMode, ModePreset>{};
    for (final entry in json.entries) {
      final mode = VentilationMode.values.firstWhere(
        (e) => e.name == entry.key,
        orElse: () => VentilationMode.basic,
      );
      final presetJson = entry.value as Map<String, dynamic>;
      presets[mode] = ModePreset(
        mode: mode,
        supplyFanSpeed: presetJson['supplyFanSpeed'] as int,
        exhaustFanSpeed: presetJson['exhaustFanSpeed'] as int,
        heatingTemp: (presetJson['heatingTemp'] as num).toDouble(),
        coolingTemp: (presetJson['coolingTemp'] as num).toDouble(),
      );
    }
    return presets;
  }

  /// Parse week schedule from JSON
  static WeekSchedule _parseSchedule(Map<String, dynamic> json) {
    return WeekSchedule(
      monday: _parseDaySchedule(json['monday'] as Map<String, dynamic>?),
      tuesday: _parseDaySchedule(json['tuesday'] as Map<String, dynamic>?),
      wednesday: _parseDaySchedule(json['wednesday'] as Map<String, dynamic>?),
      thursday: _parseDaySchedule(json['thursday'] as Map<String, dynamic>?),
      friday: _parseDaySchedule(json['friday'] as Map<String, dynamic>?),
      saturday: _parseDaySchedule(json['saturday'] as Map<String, dynamic>?),
      sunday: _parseDaySchedule(json['sunday'] as Map<String, dynamic>?),
    );
  }

  /// Parse day schedule from JSON
  static DaySchedule _parseDaySchedule(Map<String, dynamic>? json) {
    if (json == null) return DaySchedule.defaultSchedule;
    return DaySchedule(
      turnOnTime: json['turnOnTime'] != null
          ? _parseTimeOfDay(json['turnOnTime'] as String)
          : null,
      turnOffTime: json['turnOffTime'] != null
          ? _parseTimeOfDay(json['turnOffTime'] as String)
          : null,
      timerEnabled: json['timerEnabled'] as bool? ?? false,
    );
  }

  /// Parse TimeOfDay from string (HH:MM)
  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// Parse WiFi status from JSON
  static WiFiStatus _parseWiFiStatus(Map<String, dynamic> json) {
    return WiFiStatus(
      isConnected: json['isConnected'] as bool,
      connectedSSID: json['connectedSSID'] as String?,
      stationPassword: json['stationPassword'] as String?,
      apSSID: json['apSSID'] as String,
      apPassword: json['apPassword'] as String,
      signalStrength: json['signalStrength'] as int? ?? -100,
      ipAddress: json['ipAddress'] as String?,
      macAddress: json['macAddress'] as String?,
    );
  }

  /// Parse alert from JSON
  static Alert _parseAlert(Map<String, dynamic> json) {
    return Alert(
      code: json['code'] as int,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      description: json['description'] as String? ??
          Alert.getDescription(json['code'] as int),
      severity: json['severity'] != null
          ? AlertSeverity.values.firstWhere(
              (e) => e.name == json['severity'],
              orElse: () => Alert.getSeverity(json['code'] as int),
            )
          : Alert.getSeverity(json['code'] as int),
    );
  }

  /// Create from JSON string
  factory HvacUnitModel.fromJsonString(String jsonString) {
    return HvacUnitModel.fromJson(json.decode(jsonString));
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'power': power,
      'currentTemp': currentTemp,
      'targetTemp': targetTemp,
      'mode': mode,
      'fanSpeed': fanSpeed,
      'timestamp': timestamp.toIso8601String(),
      if (macAddress != null) 'macAddress': macAddress,
      if (location != null) 'location': location,
      'humidity': humidity,
      'deviceType': deviceType.name,
      if (supplyAirTemp != null) 'supplyAirTemp': supplyAirTemp,
      if (roomTemp != null) 'roomTemp': roomTemp,
      if (outdoorTemp != null) 'outdoorTemp': outdoorTemp,
      if (heatingTemp != null) 'heatingTemp': heatingTemp,
      if (coolingTemp != null) 'coolingTemp': coolingTemp,
      if (supplyFanSpeed != null) 'supplyFanSpeed': supplyFanSpeed,
      if (exhaustFanSpeed != null) 'exhaustFanSpeed': exhaustFanSpeed,
      if (ventMode != null) 'ventMode': ventMode!.name,
      if (modePresets != null) 'modePresets': _presetsToJson(modePresets!),
      if (schedule != null) 'schedule': _scheduleToJson(schedule!),
      if (wifiStatus != null) 'wifiStatus': _wifiStatusToJson(wifiStatus!),
      if (alerts != null)
        'alerts': alerts!.map((a) => _alertToJson(a)).toList(),
    };
  }

  /// Convert presets to JSON
  static Map<String, dynamic> _presetsToJson(
      Map<VentilationMode, ModePreset> presets) {
    final json = <String, dynamic>{};
    for (final entry in presets.entries) {
      json[entry.key.name] = {
        'supplyFanSpeed': entry.value.supplyFanSpeed,
        'exhaustFanSpeed': entry.value.exhaustFanSpeed,
        'heatingTemp': entry.value.heatingTemp,
        'coolingTemp': entry.value.coolingTemp,
      };
    }
    return json;
  }

  /// Convert schedule to JSON
  static Map<String, dynamic> _scheduleToJson(WeekSchedule schedule) {
    return {
      'monday': _dayScheduleToJson(schedule.monday),
      'tuesday': _dayScheduleToJson(schedule.tuesday),
      'wednesday': _dayScheduleToJson(schedule.wednesday),
      'thursday': _dayScheduleToJson(schedule.thursday),
      'friday': _dayScheduleToJson(schedule.friday),
      'saturday': _dayScheduleToJson(schedule.saturday),
      'sunday': _dayScheduleToJson(schedule.sunday),
    };
  }

  /// Convert day schedule to JSON
  static Map<String, dynamic> _dayScheduleToJson(DaySchedule day) {
    return {
      if (day.turnOnTime != null)
        'turnOnTime': _timeOfDayToString(day.turnOnTime!),
      if (day.turnOffTime != null)
        'turnOffTime': _timeOfDayToString(day.turnOffTime!),
      'timerEnabled': day.timerEnabled,
    };
  }

  /// Convert TimeOfDay to string (HH:MM)
  static String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Convert WiFi status to JSON
  static Map<String, dynamic> _wifiStatusToJson(WiFiStatus status) {
    return {
      'isConnected': status.isConnected,
      if (status.connectedSSID != null) 'connectedSSID': status.connectedSSID,
      if (status.stationPassword != null)
        'stationPassword': status.stationPassword,
      'apSSID': status.apSSID,
      'apPassword': status.apPassword,
      'signalStrength': status.signalStrength,
      if (status.ipAddress != null) 'ipAddress': status.ipAddress,
      if (status.macAddress != null) 'macAddress': status.macAddress,
    };
  }

  /// Convert alert to JSON
  static Map<String, dynamic> _alertToJson(Alert alert) {
    return {
      'code': alert.code,
      if (alert.timestamp != null)
        'timestamp': alert.timestamp!.toIso8601String(),
      'description': alert.description,
      'severity': alert.severity.name,
    };
  }

  /// Convert to JSON string
  String toJsonString() {
    return json.encode(toJson());
  }

  /// Create from Entity
  factory HvacUnitModel.fromEntity(HvacUnit entity) {
    return HvacUnitModel(
      id: entity.id,
      name: entity.name,
      power: entity.power,
      currentTemp: entity.currentTemp,
      targetTemp: entity.targetTemp,
      mode: entity.mode,
      fanSpeed: entity.fanSpeed,
      timestamp: entity.timestamp,
      macAddress: entity.macAddress,
      location: entity.location,
      humidity: entity.humidity,
      deviceType: entity.deviceType,
      supplyAirTemp: entity.supplyAirTemp,
      roomTemp: entity.roomTemp,
      outdoorTemp: entity.outdoorTemp,
      heatingTemp: entity.heatingTemp,
      coolingTemp: entity.coolingTemp,
      supplyFanSpeed: entity.supplyFanSpeed,
      exhaustFanSpeed: entity.exhaustFanSpeed,
      ventMode: entity.ventMode,
      modePresets: entity.modePresets,
      schedule: entity.schedule,
      wifiStatus: entity.wifiStatus,
      alerts: entity.alerts,
    );
  }

  /// Convert to Entity
  HvacUnit toEntity() {
    return HvacUnit(
      id: id,
      name: name,
      power: power,
      currentTemp: currentTemp,
      targetTemp: targetTemp,
      mode: mode,
      fanSpeed: fanSpeed,
      timestamp: timestamp,
      macAddress: macAddress,
      location: location,
      humidity: humidity,
      deviceType: deviceType,
      supplyAirTemp: supplyAirTemp,
      roomTemp: roomTemp,
      outdoorTemp: outdoorTemp,
      heatingTemp: heatingTemp,
      coolingTemp: coolingTemp,
      supplyFanSpeed: supplyFanSpeed,
      exhaustFanSpeed: exhaustFanSpeed,
      ventMode: ventMode,
      modePresets: modePresets,
      schedule: schedule,
      wifiStatus: wifiStatus,
      alerts: alerts,
    );
  }
}
