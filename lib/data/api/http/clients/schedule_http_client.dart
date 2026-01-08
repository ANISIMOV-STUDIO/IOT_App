/// HTTP client for Schedule service (Web platform)
///
/// ВАЖНО: Backend модель расписания отличается от Flutter модели!
///
/// Backend endpoints:
/// - GET /api/device/{id} → timerSettings (расписание по дням)
/// - POST /api/device/{id}/schedule → { enabled: bool } - вкл/выкл расписания
/// - PATCH /api/device/{id}/timer-settings → установка таймера для дня недели
///
/// Flutter модель: ScheduleEntry с id, day, timeRange, etc.
/// Backend модель: timerSettings[day] = { onHour, onMinute, offHour, offMinute, enabled }
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/error/http_error_handler.dart';
import '../../../../core/logging/api_logger.dart';
import '../../platform/api_client.dart';

class ScheduleHttpClient {
  final ApiClient _apiClient;

  ScheduleHttpClient(this._apiClient);

  /// Получить расписание устройства
  ///
  /// Backend возвращает timerSettings как часть device state.
  /// Преобразуем в формат ScheduleEntry для Flutter.
  Future<List<Map<String, dynamic>>> getSchedules(String deviceId) async {
    final url = '${ApiConfig.deviceApiUrl}/$deviceId';

    try {
      ApiLogger.logHttpRequest('GET', url, null);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );

      ApiLogger.logHttpResponse('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Извлекаем timerSettings из ответа устройства
        final timerSettings = data['timerSettings'] as Map<String, dynamic>?;
        if (timerSettings == null || timerSettings.isEmpty) {
          return [];
        }

        // Преобразуем timerSettings в формат ScheduleEntry
        return _convertTimerSettingsToScheduleEntries(deviceId, timerSettings);
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('GET', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Преобразует timerSettings backend в формат ScheduleEntry для Flutter
  List<Map<String, dynamic>> _convertTimerSettingsToScheduleEntries(
    String deviceId,
    Map<String, dynamic> timerSettings,
  ) {
    final entries = <Map<String, dynamic>>[];

    for (final dayEntry in timerSettings.entries) {
      final day = dayEntry.key; // monday, tuesday, etc.
      final settings = dayEntry.value as Map<String, dynamic>?;

      if (settings == null) continue;

      final onHour = settings['onHour'] as int? ?? 0;
      final onMinute = settings['onMinute'] as int? ?? 0;
      final offHour = settings['offHour'] as int? ?? 23;
      final offMinute = settings['offMinute'] as int? ?? 59;
      final enabled = settings['enabled'] as bool? ?? false;

      // Формируем timeRange в формате HH:MM-HH:MM
      final timeRange =
          '${onHour.toString().padLeft(2, '0')}:${onMinute.toString().padLeft(2, '0')}-'
          '${offHour.toString().padLeft(2, '0')}:${offMinute.toString().padLeft(2, '0')}';

      entries.add({
        'id': '${deviceId}_$day', // Синтетический ID
        'deviceId': deviceId,
        'day': day,
        'mode': 'auto', // Backend не хранит mode в timer
        'timeRange': timeRange,
        'tempDay': 22, // Backend не хранит температуры в timer
        'tempNight': 20,
        'isActive': enabled,
        'enabled': enabled,
      });
    }

    return entries;
  }

  /// Создать/обновить запись расписания
  ///
  /// Backend: PATCH /api/device/{id}/timer-settings
  Future<Map<String, dynamic>> createSchedule(
      Map<String, dynamic> schedule) async {
    final deviceId = schedule['deviceId'] as String;
    final url = '${ApiConfig.deviceApiUrl}/$deviceId/timer-settings';

    // Парсим timeRange из формата HH:MM-HH:MM
    final timeRange = schedule['timeRange'] as String? ?? '08:00-22:00';
    final times = _parseTimeRange(timeRange);

    final body = json.encode({
      'day': schedule['day'],
      'onHour': times['onHour'],
      'onMinute': times['onMinute'],
      'offHour': times['offHour'],
      'offMinute': times['offMinute'],
      'enabled': schedule['isActive'] ?? schedule['enabled'] ?? true,
    });

    try {
      ApiLogger.logHttpRequest('PATCH', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().patch(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('PATCH', url, response.statusCode, response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Возвращаем созданную запись с синтетическим ID
        return {
          ...schedule,
          'id': '${deviceId}_${schedule['day']}',
        };
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('PATCH', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Обновить запись расписания
  ///
  /// Backend: PATCH /api/device/{id}/timer-settings (тот же endpoint что и create)
  Future<Map<String, dynamic>> updateSchedule(
      String scheduleId, Map<String, dynamic> schedule) async {
    // scheduleId имеет формат deviceId_day
    final parts = scheduleId.split('_');
    if (parts.length < 2) {
      throw ArgumentError('Invalid scheduleId format: $scheduleId');
    }

    final deviceId = parts[0];
    final day = parts.sublist(1).join('_'); // На случай если день содержит _
    final url = '${ApiConfig.deviceApiUrl}/$deviceId/timer-settings';

    // Парсим timeRange
    final timeRange = schedule['timeRange'] as String? ?? '08:00-22:00';
    final times = _parseTimeRange(timeRange);

    final body = json.encode({
      'day': day,
      'onHour': times['onHour'],
      'onMinute': times['onMinute'],
      'offHour': times['offHour'],
      'offMinute': times['offMinute'],
      'enabled': schedule['isActive'] ?? schedule['enabled'] ?? true,
    });

    try {
      ApiLogger.logHttpRequest('PATCH', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().patch(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('PATCH', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return {
          'id': scheduleId,
          'deviceId': deviceId,
          'day': day,
          ...schedule,
        };
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('PATCH', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Удалить запись расписания
  ///
  /// Backend не имеет delete для timer — отключаем enabled=false
  Future<void> deleteSchedule(String scheduleId) async {
    // scheduleId имеет формат deviceId_day
    final parts = scheduleId.split('_');
    if (parts.length < 2) {
      throw ArgumentError('Invalid scheduleId format: $scheduleId');
    }

    final deviceId = parts[0];
    final day = parts.sublist(1).join('_');
    final url = '${ApiConfig.deviceApiUrl}/$deviceId/timer-settings';

    // "Удаление" = отключение таймера для этого дня
    final body = json.encode({
      'day': day,
      'onHour': 0,
      'onMinute': 0,
      'offHour': 0,
      'offMinute': 0,
      'enabled': false,
    });

    try {
      ApiLogger.logHttpRequest('PATCH (delete)', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().patch(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('PATCH (delete)', url, response.statusCode, response.body);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('PATCH (delete)', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Включить/выключить расписание для устройства
  ///
  /// Backend: POST /api/device/{id}/schedule
  Future<void> setScheduleEnabled(String deviceId, bool enabled) async {
    final url = '${ApiConfig.deviceApiUrl}/$deviceId/schedule';
    final body = json.encode({'enabled': enabled});

    try {
      ApiLogger.logHttpRequest('POST', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('POST', url, response.statusCode, response.body);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('POST', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Парсит timeRange формата HH:MM-HH:MM в компоненты
  Map<String, int> _parseTimeRange(String timeRange) {
    try {
      final parts = timeRange.split('-');
      if (parts.length != 2) {
        return {'onHour': 8, 'onMinute': 0, 'offHour': 22, 'offMinute': 0};
      }

      final onParts = parts[0].split(':');
      final offParts = parts[1].split(':');

      return {
        'onHour': int.tryParse(onParts[0]) ?? 8,
        'onMinute': onParts.length > 1 ? (int.tryParse(onParts[1]) ?? 0) : 0,
        'offHour': int.tryParse(offParts[0]) ?? 22,
        'offMinute': offParts.length > 1 ? (int.tryParse(offParts[1]) ?? 0) : 0,
      };
    } catch (_) {
      return {'onHour': 8, 'onMinute': 0, 'offHour': 22, 'offMinute': 0};
    }
  }
}
