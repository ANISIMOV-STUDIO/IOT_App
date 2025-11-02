/// Day Schedule Entity
///
/// Schedule configuration for a single day
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DaySchedule extends Equatable {
  final TimeOfDay? turnOnTime; // Время включения (null = не установлено)
  final TimeOfDay? turnOffTime; // Время отключения (null = не установлено)
  final bool timerEnabled; // Таймер включен/выключен

  const DaySchedule({
    this.turnOnTime,
    this.turnOffTime,
    this.timerEnabled = false,
  });

  /// Create a copy with updated fields
  DaySchedule copyWith({
    TimeOfDay? turnOnTime,
    TimeOfDay? turnOffTime,
    bool? timerEnabled,
  }) {
    return DaySchedule(
      turnOnTime: turnOnTime ?? this.turnOnTime,
      turnOffTime: turnOffTime ?? this.turnOffTime,
      timerEnabled: timerEnabled ?? this.timerEnabled,
    );
  }

  /// Default schedule (timer off, no times set)
  static const DaySchedule defaultSchedule = DaySchedule(
    turnOnTime: null,
    turnOffTime: null,
    timerEnabled: false,
  );

  @override
  List<Object?> get props => [
        turnOnTime?.hour,
        turnOnTime?.minute,
        turnOffTime?.hour,
        turnOffTime?.minute,
        timerEnabled,
      ];

  @override
  String toString() {
    final onTime = turnOnTime != null
        ? '${turnOnTime!.hour.toString().padLeft(2, '0')}:${turnOnTime!.minute.toString().padLeft(2, '0')}'
        : '--:--';
    final offTime = turnOffTime != null
        ? '${turnOffTime!.hour.toString().padLeft(2, '0')}:${turnOffTime!.minute.toString().padLeft(2, '0')}'
        : '--:--';
    return 'DaySchedule(on: $onTime, off: $offTime, enabled: $timerEnabled)';
  }
}
