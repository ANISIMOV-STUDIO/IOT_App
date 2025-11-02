/// Update Schedule Use Case
///
/// Updates the weekly schedule for a ventilation unit
library;

import '../entities/week_schedule.dart';
import '../entities/day_schedule.dart';
import '../repositories/hvac_repository.dart';

class UpdateSchedule {
  final HvacRepository repository;

  UpdateSchedule(this.repository);

  /// Update entire week schedule
  Future<void> call(String unitId, WeekSchedule schedule) async {
    final unit = await repository.getUnitById(unitId).first;
    final updatedUnit = unit.copyWith(schedule: schedule);
    await repository.updateUnitEntity(updatedUnit);
  }

  /// Update a single day schedule
  Future<void> updateDay(
    String unitId,
    int dayOfWeek,
    DaySchedule daySchedule,
  ) async {
    final unit = await repository.getUnitById(unitId).first;
    final currentSchedule = unit.schedule ?? WeekSchedule.defaultSchedule;
    final updatedSchedule = currentSchedule.updateDay(dayOfWeek, daySchedule);
    final updatedUnit = unit.copyWith(schedule: updatedSchedule);
    await repository.updateUnitEntity(updatedUnit);
  }
}
