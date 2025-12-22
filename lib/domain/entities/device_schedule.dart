/// Device schedule entity for HVAC automation
library;

import 'package:flutter/material.dart';

/// Schedule action types
enum ScheduleAction {
  turnOn,
  turnOff,
  setTemperature,
  setMode,
}

/// Days of week for schedule repeat
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get shortName => switch (this) {
        monday => 'Пн',
        tuesday => 'Вт',
        wednesday => 'Ср',
        thursday => 'Чт',
        friday => 'Пт',
        saturday => 'Сб',
        sunday => 'Вс',
      };
}

/// Schedule entry for device automation
class DeviceSchedule {
  final String id;
  final String? deviceId; // null = applies to all devices
  final TimeOfDay time;
  final ScheduleAction action;
  final double? temperature;
  final String? mode;
  final Set<DayOfWeek> repeatDays;
  final bool isEnabled;
  final String? label; // e.g., "Wake up", "Night mode"

  const DeviceSchedule({
    required this.id,
    this.deviceId,
    required this.time,
    required this.action,
    this.temperature,
    this.mode,
    required this.repeatDays,
    this.isEnabled = true,
    this.label,
  });

  /// Check if schedule applies to specific device
  bool appliesTo(String targetDeviceId) =>
      deviceId == null || deviceId == targetDeviceId;

  /// Check if schedule is for all devices
  bool get isGlobal => deviceId == null;

  /// Format time as HH:MM
  String get timeFormatted =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  /// Get action description
  String get actionDescription => switch (action) {
        ScheduleAction.turnOn => 'Включить',
        ScheduleAction.turnOff => 'Выключить',
        ScheduleAction.setTemperature => 'Установить ${temperature?.round()}°C',
        ScheduleAction.setMode => 'Режим: $mode',
      };

  DeviceSchedule copyWith({
    String? id,
    String? deviceId,
    TimeOfDay? time,
    ScheduleAction? action,
    double? temperature,
    String? mode,
    Set<DayOfWeek>? repeatDays,
    bool? isEnabled,
    String? label,
  }) {
    return DeviceSchedule(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      time: time ?? this.time,
      action: action ?? this.action,
      temperature: temperature ?? this.temperature,
      mode: mode ?? this.mode,
      repeatDays: repeatDays ?? this.repeatDays,
      isEnabled: isEnabled ?? this.isEnabled,
      label: label ?? this.label,
    );
  }
}
