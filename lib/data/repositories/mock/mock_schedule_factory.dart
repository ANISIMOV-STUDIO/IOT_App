/// Mock Schedule Factory
///
/// Factory for creating mock schedules for testing
library;

import 'package:flutter/material.dart';
import '../../../domain/entities/week_schedule.dart';
import '../../../domain/entities/day_schedule.dart';

/// Factory for creating mock HVAC schedules
class MockScheduleFactory {
  MockScheduleFactory._();

  /// Default schedule (7:00-20:00 weekdays, 9:00-22:00 weekends)
  static WeekSchedule createDefaultSchedule() {
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

  /// Night schedule (22:00-7:00)
  static WeekSchedule createNightSchedule() {
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

  /// Kitchen schedule (12:00-20:00)
  static WeekSchedule createKitchenSchedule() {
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
}
