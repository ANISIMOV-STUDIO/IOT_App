/// HTTP реализация NotificationDataSource
///
/// Используется на Web платформе.
/// Real-time обновления через SignalR (обрабатываются в repository).
library;

import 'package:hvac_control/data/api/http/clients/notification_http_client.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/datasources/notification/notification_data_source.dart';

class NotificationHttpDataSource implements NotificationDataSource {

  NotificationHttpDataSource(ApiClient apiClient)
      : _httpClient = NotificationHttpClient(apiClient);
  final NotificationHttpClient _httpClient;

  @override
  Future<List<NotificationDto>> getNotifications({String? deviceId}) async {
    final jsonList = await _httpClient.getNotifications(deviceId: deviceId);

    return jsonList.map((json) => NotificationDto(
        id: json['id'] as String,
        deviceId: json['deviceId'] as String? ?? '',
        title: json['title'] as String,
        message: json['message'] as String,
        type: json['type'] as String? ?? 'info',
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
        isRead: json['isRead'] as bool? ?? false,
      )).toList();
  }

  @override
  Future<void> markAsRead(List<String> notificationIds) async {
    await _httpClient.markAsRead(notificationIds);
  }

  @override
  Future<void> dismiss(String notificationId) async {
    await _httpClient.dismiss(notificationId);
  }

  @override
  Stream<NotificationDto>? watchNotifications({String? deviceId}) =>
    // Web использует SignalR для real-time, который обрабатывается в repository
    null;

  @override
  void dispose() {
    // HTTP клиент не требует явного освобождения
  }
}
