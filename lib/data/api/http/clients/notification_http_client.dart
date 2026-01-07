/// HTTP client for Notification service (Web platform)
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/error/http_error_handler.dart';
import '../../../../core/logging/api_logger.dart';
import '../../platform/api_client.dart';

class NotificationHttpClient {
  final ApiClient _apiClient;

  NotificationHttpClient(this._apiClient);

  /// Get notifications
  Future<List<Map<String, dynamic>>> getNotifications({String? deviceId}) async {
    final url = deviceId != null
        ? '${ApiConfig.notificationApiUrl}?deviceId=$deviceId'
        : ApiConfig.notificationApiUrl;

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
        } else if (data is Map) {
          final notifications = data['notifications'];
          if (notifications is List) {
            return notifications.cast<Map<String, dynamic>>();
          }
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

  /// Mark notifications as read (one or multiple)
  /// Backend: POST /api/notification/mark-read with body ["id1", "id2", ...]
  Future<void> markAsRead(List<String> notificationIds) async {
    final url = '${ApiConfig.notificationApiUrl}/mark-read';

    try {
      final body = json.encode(notificationIds);
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

  /// Dismiss (delete) notification
  /// Backend: DELETE /api/notification/{id}
  Future<void> dismiss(String notificationId) async {
    final url = '${ApiConfig.notificationApiUrl}/$notificationId';

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
