/// Schedule Repository - Interface for schedule operations
library;

import '../entities/schedule_entry.dart';

/// Interface for schedule data access and operations
abstract class ScheduleRepository {
  /// Get schedule entries for a device
  Future<List<ScheduleEntry>> getSchedule(String deviceId);

  /// Watch for schedule updates for a device
  Stream<List<ScheduleEntry>> watchSchedule(String deviceId);

  /// Add a new schedule entry
  Future<ScheduleEntry> addEntry(ScheduleEntry entry);

  /// Update an existing schedule entry
  Future<ScheduleEntry> updateEntry(ScheduleEntry entry);

  /// Delete a schedule entry
  Future<void> deleteEntry(String entryId);

  /// Toggle schedule entry active state
  Future<ScheduleEntry> toggleEntry(String entryId, bool isActive);
}
