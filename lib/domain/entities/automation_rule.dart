/// Automation Rule Entity
///
/// Defines automatic actions based on conditions
library;

import 'package:equatable/equatable.dart';
import 'ventilation_mode.dart';

enum AutomationCondition {
  temperatureAbove,
  temperatureBelow,
  humidityAbove,
  humidityBelow,
  co2Above,
  scheduleTime,
}

enum AutomationAction {
  turnOn,
  turnOff,
  setMode,
  setFanSpeed,
  sendNotification,
}

class AutomationRule extends Equatable {
  final String id;
  final String name;
  final bool enabled;
  final AutomationCondition condition;
  final double? threshold; // for temperature, humidity, CO2
  final DateTime? triggerTime; // for schedule-based rules
  final AutomationAction action;
  final VentilationMode? targetMode;
  final int? targetFanSpeed;
  final String? notificationMessage;

  const AutomationRule({
    required this.id,
    required this.name,
    required this.enabled,
    required this.condition,
    this.threshold,
    this.triggerTime,
    required this.action,
    this.targetMode,
    this.targetFanSpeed,
    this.notificationMessage,
  });

  AutomationRule copyWith({
    String? id,
    String? name,
    bool? enabled,
    AutomationCondition? condition,
    double? threshold,
    DateTime? triggerTime,
    AutomationAction? action,
    VentilationMode? targetMode,
    int? targetFanSpeed,
    String? notificationMessage,
  }) {
    return AutomationRule(
      id: id ?? this.id,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      condition: condition ?? this.condition,
      threshold: threshold ?? this.threshold,
      triggerTime: triggerTime ?? this.triggerTime,
      action: action ?? this.action,
      targetMode: targetMode ?? this.targetMode,
      targetFanSpeed: targetFanSpeed ?? this.targetFanSpeed,
      notificationMessage: notificationMessage ?? this.notificationMessage,
    );
  }

  String get conditionDescription {
    switch (condition) {
      case AutomationCondition.temperatureAbove:
        return 'Температура выше ${threshold?.toInt()}°C';
      case AutomationCondition.temperatureBelow:
        return 'Температура ниже ${threshold?.toInt()}°C';
      case AutomationCondition.humidityAbove:
        return 'Влажность выше ${threshold?.toInt()}%';
      case AutomationCondition.humidityBelow:
        return 'Влажность ниже ${threshold?.toInt()}%';
      case AutomationCondition.co2Above:
        return 'CO2 выше ${threshold?.toInt()} ppm';
      case AutomationCondition.scheduleTime:
        return 'По расписанию ${triggerTime?.hour}:${triggerTime?.minute.toString().padLeft(2, '0')}';
    }
  }

  String get actionDescription {
    switch (action) {
      case AutomationAction.turnOn:
        return 'Включить установку';
      case AutomationAction.turnOff:
        return 'Выключить установку';
      case AutomationAction.setMode:
        return 'Установить режим: ${targetMode?.displayName}';
      case AutomationAction.setFanSpeed:
        return 'Установить скорость: $targetFanSpeed%';
      case AutomationAction.sendNotification:
        return 'Отправить уведомление';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        enabled,
        condition,
        threshold,
        triggerTime,
        action,
        targetMode,
        targetFanSpeed,
        notificationMessage,
      ];

  /// Default automation rules
  static final List<AutomationRule> defaults = [
    const AutomationRule(
      id: '1',
      name: 'Высокая влажность',
      enabled: true,
      condition: AutomationCondition.humidityAbove,
      threshold: 65,
      action: AutomationAction.setMode,
      targetMode: VentilationMode.maximum,
    ),
    const AutomationRule(
      id: '2',
      name: 'Низкая температура',
      enabled: true,
      condition: AutomationCondition.temperatureBelow,
      threshold: 18,
      action: AutomationAction.setMode,
      targetMode: VentilationMode.economic,
    ),
    const AutomationRule(
      id: '3',
      name: 'Высокий CO2',
      enabled: false,
      condition: AutomationCondition.co2Above,
      threshold: 1000,
      action: AutomationAction.sendNotification,
      notificationMessage: 'Требуется усиленная вентиляция!',
    ),
  ];
}
