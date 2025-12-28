/// Real implementation of NotificationRepository
library;

import 'dart:async';
import '../../domain/entities/unit_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../api/platform/api_client.dart';
import '../api/http/clients/notification_http_client.dart';

class RealNotificationRepository implements NotificationRepository {
  final ApiClient _apiClient;
  late final NotificationHttpClient _httpClient;

  final _notificationsController =
      StreamController<List<UnitNotification>>.broadcast();

  RealNotificationRepository(this._apiClient) {
    _httpClient = NotificationHttpClient(_apiClient);
  }

  @override
  Future<List<UnitNotification>> getNotifications({String? deviceId}) async {
    final jsonNotifications = await _httpClient.getNotifications(deviceId: deviceId);

    return jsonNotifications.map((json) {
      return UnitNotification(
        id: json['id'] as String,
        deviceId: json['deviceId'] as String? ?? '',
        title: json['title'] as String,
        message: json['message'] as String,
        type: _stringToNotificationType(json['type'] as String?),
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
        isRead: json['isRead'] as bool? ?? false,
      );
    }).toList();
  }

  @override
  Stream<List<UnitNotification>> watchNotifications({String? deviceId}) {
    getNotifications(deviceId: deviceId).then(
      _notificationsController.add,
      onError: (error) {
        // Логировать ошибку и добавить в stream
        _notificationsController.addError(error);
      },
    );
    return _notificationsController.stream;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _httpClient.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead({String? deviceId}) async {
    await _httpClient.markAllAsRead();
  }

  @override
  Future<void> dismiss(String notificationId) async {
    // Same as mark as read for HTTP API
    await _httpClient.markAsRead(notificationId);
  }

  @override
  Future<int> getUnreadCount({String? deviceId}) async {
    final notifications = await getNotifications(deviceId: deviceId);
    return notifications.where((n) => !n.isRead).length;
  }

  NotificationType _stringToNotificationType(String? type) {
    if (type == null) return NotificationType.info;

    switch (type.toLowerCase()) {
      case 'info':
        return NotificationType.info;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      case 'success':
        return NotificationType.success;
      default:
        return NotificationType.info;
    }
  }

  void dispose() {
    _notificationsController.close();
  }
}
