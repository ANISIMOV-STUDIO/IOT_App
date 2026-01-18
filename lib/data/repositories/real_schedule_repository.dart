/// Real implementation of ScheduleRepository
library;

import 'dart:async';

import 'package:hvac_control/data/api/http/clients/schedule_http_client.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/domain/entities/schedule_entry.dart';
import 'package:hvac_control/domain/repositories/schedule_repository.dart';

class RealScheduleRepository implements ScheduleRepository {

  RealScheduleRepository(this._apiClient) {
    _httpClient = ScheduleHttpClient(_apiClient);
  }
  final ApiClient _apiClient;
  late final ScheduleHttpClient _httpClient;

  final _scheduleController = StreamController<List<ScheduleEntry>>.broadcast();

  /// Флаг для предотвращения race condition при dispose
  bool _isDisposed = false;

  @override
  Future<List<ScheduleEntry>> getSchedule(String deviceId) async {
    final jsonSchedules = await _httpClient.getSchedules(deviceId);

    // Если API вернул пустой массив или неправильный формат - вернуть пустой список
    if (jsonSchedules.isEmpty) {
      return [];
    }

    return jsonSchedules.where((json) =>
      // Фильтруем только валидные записи расписания
      json['day'] != null).map((json) => ScheduleEntry(
        id: json['id'] as String? ?? '',
        deviceId: json['deviceId'] as String? ?? deviceId,
        day: json['day'] as String? ?? 'monday',
        mode: json['mode'] as String? ?? 'auto',
        timeRange: json['timeRange'] as String? ?? '00:00-23:59',
        tempDay: (json['tempDay'] as num?)?.toInt() ?? 22,
        tempNight: (json['tempNight'] as num?)?.toInt() ?? 20,
        isActive: json['isActive'] as bool? ?? json['enabled'] as bool? ?? true,
      )).toList();
  }

  @override
  Stream<List<ScheduleEntry>> watchSchedule(String deviceId) {
    getSchedule(deviceId).then(
      (schedule) {
        if (!_isDisposed && !_scheduleController.isClosed) {
          _scheduleController.add(schedule);
        }
      },
      onError: (Object error) {
        // Логировать ошибку и добавить в stream
        if (!_isDisposed && !_scheduleController.isClosed) {
          _scheduleController.addError(error);
        }
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
  Future<ScheduleEntry> toggleEntry(String entryId, {required bool isActive}) async {
    // Get current entry from all schedules
    final schedule = await getSchedule('');
    final entry = schedule.firstWhere(
      (e) => e.id == entryId,
      orElse: () => throw StateError('Schedule entry not found: $entryId'),
    );

    return updateEntry(entry.copyWith(isActive: isActive));
  }

  @override
  Future<void> setScheduleEnabled(String deviceId, {required bool enabled}) async {
    await _httpClient.setScheduleEnabled(deviceId, enabled: enabled);
  }

  void dispose() {
    _isDisposed = true;
    _scheduleController.close();
  }
}
