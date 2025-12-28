/// Real implementation of ScheduleRepository
library;

import 'dart:async';
import '../../domain/entities/schedule_entry.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../api/platform/api_client.dart';
import '../api/http/clients/schedule_http_client.dart';

class RealScheduleRepository implements ScheduleRepository {
  final ApiClient _apiClient;
  late final ScheduleHttpClient _httpClient;

  final _scheduleController = StreamController<List<ScheduleEntry>>.broadcast();

  RealScheduleRepository(this._apiClient) {
    _httpClient = ScheduleHttpClient(_apiClient);
  }

  @override
  Future<List<ScheduleEntry>> getSchedule(String deviceId) async {
    final jsonSchedules = await _httpClient.getSchedules(deviceId);

    return jsonSchedules.map((json) {
      return ScheduleEntry(
        id: json['id'] as String,
        deviceId: json['deviceId'] as String,
        day: json['day'] as String,
        mode: json['mode'] as String,
        timeRange: json['timeRange'] as String,
        tempDay: (json['tempDay'] as num?)?.toInt() ?? 22,
        tempNight: (json['tempNight'] as num?)?.toInt() ?? 20,
        isActive: json['isActive'] as bool? ?? true,
      );
    }).toList();
  }

  @override
  Stream<List<ScheduleEntry>> watchSchedule(String deviceId) {
    getSchedule(deviceId).then(
      _scheduleController.add,
      onError: (error) {
        // Логировать ошибку и добавить в stream
        _scheduleController.addError(error);
      },
    );
    return _scheduleController.stream;
  }

  @override
  Future<ScheduleEntry> addEntry(ScheduleEntry entry) async {
    final jsonEntry = await _httpClient.createSchedule({
      'deviceId': entry.deviceId,
      'day': entry.day,
      'mode': entry.mode,
      'timeRange': entry.timeRange,
      'tempDay': entry.tempDay,
      'tempNight': entry.tempNight,
      'isActive': entry.isActive,
    });

    return ScheduleEntry(
      id: jsonEntry['id'] as String,
      deviceId: entry.deviceId,
      day: entry.day,
      mode: entry.mode,
      timeRange: entry.timeRange,
      tempDay: entry.tempDay,
      tempNight: entry.tempNight,
      isActive: entry.isActive,
    );
  }

  @override
  Future<ScheduleEntry> updateEntry(ScheduleEntry entry) async {
    final jsonEntry = await _httpClient.updateSchedule(entry.id, {
      'day': entry.day,
      'mode': entry.mode,
      'timeRange': entry.timeRange,
      'tempDay': entry.tempDay,
      'tempNight': entry.tempNight,
      'isActive': entry.isActive,
    });

    return ScheduleEntry(
      id: jsonEntry['id'] as String,
      deviceId: entry.deviceId,
      day: entry.day,
      mode: entry.mode,
      timeRange: entry.timeRange,
      tempDay: entry.tempDay,
      tempNight: entry.tempNight,
      isActive: entry.isActive,
    );
  }

  @override
  Future<void> deleteEntry(String entryId) async {
    await _httpClient.deleteSchedule(entryId);
  }

  @override
  Future<ScheduleEntry> toggleEntry(String entryId, bool isActive) async {
    // Get current entry
    final schedule = await getSchedule('');
    final entry = schedule.firstWhere((e) => e.id == entryId);

    return updateEntry(entry.copyWith(isActive: isActive));
  }

  void dispose() {
    _scheduleController.close();
  }
}
