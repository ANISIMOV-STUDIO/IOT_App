/// Schedule logic helpers
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/day_schedule.dart';
import '../../../domain/entities/week_schedule.dart';

/// Helper class for schedule manipulation
class ScheduleLogic {
  ScheduleLogic._();

  /// Create weekday schedule (Mon-Fri 7:00-20:00)
  static WeekSchedule applyWeekdaySchedule(WeekSchedule current) {
    const schedule = DaySchedule(
      turnOnTime: TimeOfDay(hour: 7, minute: 0),
      turnOffTime: TimeOfDay(hour: 20, minute: 0),
      timerEnabled: true,
    );
    return current.copyWith(
      monday: schedule,
      tuesday: schedule,
      wednesday: schedule,
      thursday: schedule,
      friday: schedule,
    );
  }

  /// Create weekend schedule (Sat-Sun 9:00-22:00)
  static WeekSchedule applyWeekendSchedule(WeekSchedule current) {
    const schedule = DaySchedule(
      turnOnTime: TimeOfDay(hour: 9, minute: 0),
      turnOffTime: TimeOfDay(hour: 22, minute: 0),
      timerEnabled: true,
    );
    return current.copyWith(
      saturday: schedule,
      sunday: schedule,
    );
  }

  /// Disable all schedules
  static WeekSchedule disableAllSchedules() {
    const disabled = DaySchedule(timerEnabled: false);
    return const WeekSchedule(
      monday: disabled,
      tuesday: disabled,
      wednesday: disabled,
      thursday: disabled,
      friday: disabled,
      saturday: disabled,
      sunday: disabled,
    );
  }

  /// Get day list for UI
  static List<(String, int, DaySchedule)> getDayList(WeekSchedule schedule) {
    return [
      ('Понедельник', 1, schedule.monday),
      ('Вторник', 2, schedule.tuesday),
      ('Среда', 3, schedule.wednesday),
      ('Четверг', 4, schedule.thursday),
      ('Пятница', 5, schedule.friday),
      ('Суббота', 6, schedule.saturday),
      ('Воскресенье', 7, schedule.sunday),
    ];
  }
}
