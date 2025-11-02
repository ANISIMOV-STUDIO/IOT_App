/// Week Schedule Entity
///
/// Weekly schedule configuration for ventilation unit
library;

import 'package:equatable/equatable.dart';
import 'day_schedule.dart';

class WeekSchedule extends Equatable {
  final DaySchedule monday;
  final DaySchedule tuesday;
  final DaySchedule wednesday;
  final DaySchedule thursday;
  final DaySchedule friday;
  final DaySchedule saturday;
  final DaySchedule sunday;

  const WeekSchedule({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  /// Create a copy with updated fields
  WeekSchedule copyWith({
    DaySchedule? monday,
    DaySchedule? tuesday,
    DaySchedule? wednesday,
    DaySchedule? thursday,
    DaySchedule? friday,
    DaySchedule? saturday,
    DaySchedule? sunday,
  }) {
    return WeekSchedule(
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
    );
  }

  /// Get schedule for a specific day (1 = Monday, 7 = Sunday)
  DaySchedule getDaySchedule(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return monday;
      case 2:
        return tuesday;
      case 3:
        return wednesday;
      case 4:
        return thursday;
      case 5:
        return friday;
      case 6:
        return saturday;
      case 7:
        return sunday;
      default:
        return DaySchedule.defaultSchedule;
    }
  }

  /// Update schedule for a specific day
  WeekSchedule updateDay(int dayOfWeek, DaySchedule schedule) {
    switch (dayOfWeek) {
      case 1:
        return copyWith(monday: schedule);
      case 2:
        return copyWith(tuesday: schedule);
      case 3:
        return copyWith(wednesday: schedule);
      case 4:
        return copyWith(thursday: schedule);
      case 5:
        return copyWith(friday: schedule);
      case 6:
        return copyWith(saturday: schedule);
      case 7:
        return copyWith(sunday: schedule);
      default:
        return this;
    }
  }

  /// Default week schedule (all days with timer off)
  static const WeekSchedule defaultSchedule = WeekSchedule(
    monday: DaySchedule.defaultSchedule,
    tuesday: DaySchedule.defaultSchedule,
    wednesday: DaySchedule.defaultSchedule,
    thursday: DaySchedule.defaultSchedule,
    friday: DaySchedule.defaultSchedule,
    saturday: DaySchedule.defaultSchedule,
    sunday: DaySchedule.defaultSchedule,
  );

  @override
  List<Object?> get props => [
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
        sunday,
      ];

  @override
  String toString() {
    return 'WeekSchedule(mon: $monday, tue: $tuesday, wed: $wednesday, thu: $thursday, fri: $friday, sat: $saturday, sun: $sunday)';
  }
}
