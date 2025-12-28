/// HTTP client for Schedule service (Web platform)
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

  /// Get schedules for device
  Future<List<Map<String, dynamic>>> getSchedules(String deviceId) async {
    final url = '${ApiConfig.scheduleApiUrl}?deviceId=$deviceId';

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
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map && data.containsKey('schedules')) {
          return (data['schedules'] as List).cast<Map<String, dynamic>>();
        }
        return [];
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

  /// Create schedule
  Future<Map<String, dynamic>> createSchedule(
      Map<String, dynamic> schedule) async {
    final url = ApiConfig.scheduleApiUrl;
    final body = json.encode(schedule);

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
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

  /// Update schedule
  Future<Map<String, dynamic>> updateSchedule(
      String scheduleId, Map<String, dynamic> schedule) async {
    final url = '${ApiConfig.scheduleApiUrl}/$scheduleId';
    final body = json.encode(schedule);

    try {
      ApiLogger.logHttpRequest('PUT', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().put(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('PUT', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('PUT', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Delete schedule
  Future<void> deleteSchedule(String scheduleId) async {
    final url = '${ApiConfig.scheduleApiUrl}/$scheduleId';

    try {
      ApiLogger.logHttpRequest('DELETE', url, null);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().delete(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );

      ApiLogger.logHttpResponse('DELETE', url, response.statusCode, response.body);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('DELETE', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }
}
