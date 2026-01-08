/// Mock Schedule Repository
library;

import 'dart:async';
import '../../domain/entities/schedule_entry.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../mock/mock_data.dart';

class MockScheduleRepository implements ScheduleRepository {
  final _controller = StreamController<List<ScheduleEntry>>.broadcast();
  final Map<String, List<ScheduleEntry>> _schedules = {};

  MockScheduleRepository() {
    _initializeFromMockData();
  }

  void _initializeFromMockData() {
    for (final entry in MockData.schedules.entries) {
      final deviceId = entry.key;
      _schedules[deviceId] = entry.value.map((s) => ScheduleEntry(
        id: s['id'] as String,
        deviceId: deviceId,
        day: s['day'] as String,
        mode: s['mode'] as String,
        timeRange: s['timeRange'] as String,
        tempDay: s['tempDay'] as int,
        tempNight: s['tempNight'] as int,
        isActive: s['isActive'] as bool? ?? false,
      )).toList();
    }
  }

  @override
  Future<List<ScheduleEntry>> getSchedule(String deviceId) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast']!));
    return List.unmodifiable(_schedules[deviceId] ?? []);
  }

  @override
  Stream<List<ScheduleEntry>> watchSchedule(String deviceId) {
    Future.microtask(() => _controller.add(_schedules[deviceId] ?? []));
    return _controller.stream;
  }

  @override
  Future<ScheduleEntry> addEntry(ScheduleEntry entry) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal']!));

    final deviceSchedule = _schedules.putIfAbsent(entry.deviceId, () => []);
    final newEntry = entry.copyWith(
      id: 'sch_${DateTime.now().millisecondsSinceEpoch}',
    );
    deviceSchedule.add(newEntry);
    _controller.add(List.unmodifiable(deviceSchedule));
    return newEntry;
  }

  @override
  Future<ScheduleEntry> updateEntry(ScheduleEntry entry) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal']!));

    final deviceSchedule = _schedules[entry.deviceId];
    if (deviceSchedule == null) {
      throw Exception('Device not found: ${entry.deviceId}');
    }

    final index = deviceSchedule.indexWhere((e) => e.id == entry.id);
    if (index == -1) {
      throw Exception('Schedule entry not found: ${entry.id}');
    }

    deviceSchedule[index] = entry;
    _controller.add(List.unmodifiable(deviceSchedule));
    return entry;
  }

  @override
  Future<void> deleteEntry(String entryId) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast']!));

    for (final deviceSchedule in _schedules.values) {
      final index = deviceSchedule.indexWhere((e) => e.id == entryId);
      if (index != -1) {
        deviceSchedule.removeAt(index);
        _controller.add(List.unmodifiable(deviceSchedule));
        return;
      }
    }
  }

  @override
  Future<ScheduleEntry> toggleEntry(String entryId, bool isActive) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast']!));

    for (final entry in _schedules.entries) {
      final deviceSchedule = entry.value;
      final index = deviceSchedule.indexWhere((e) => e.id == entryId);
      if (index != -1) {
        final updated = deviceSchedule[index].copyWith(isActive: isActive);
        deviceSchedule[index] = updated;
        _controller.add(List.unmodifiable(deviceSchedule));
        return updated;
      }
    }

    throw Exception('Schedule entry not found: $entryId');
  }

  @override
  Future<void> setScheduleEnabled(String deviceId, bool enabled) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['fast']!));
    // Mock implementation - just simulate API call
  }

  void dispose() {
    _controller.close();
  }
}
