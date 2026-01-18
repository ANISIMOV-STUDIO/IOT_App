/// Mock Notification Repository
library;

import 'dart:async';
import '../../domain/entities/unit_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../mock/mock_data.dart';

class MockNotificationRepository implements NotificationRepository {
  final _controller = StreamController<List<UnitNotification>>.broadcast();
  List<UnitNotification> _notifications = [];

  MockNotificationRepository() {
    _initializeFromMockData();
  }

  void _initializeFromMockData() {
    final now = DateTime.now();
    _notifications = MockData.unitNotifications.map((n) => UnitNotification(
      id: n['id'] as String,
      deviceId: n['deviceId'] as String?,
      title: n['title'] as String,
      message: n['message'] as String,
      type: _parseNotificationType(n['type'] as String),
      timestamp: now.subtract(Duration(hours: n['hoursAgo'] as int)),
      isRead: n['isRead'] as bool? ?? false,
    )).toList();
  }

  NotificationType _parseNotificationType(String type) {
    return NotificationType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => NotificationType.info,
    );
  }

  @override
  Future<List<UnitNotification>> getNotifications({String? deviceId}) async {
    await Future.delayed(MockData.fastDelay);

    if (deviceId != null) {
      return List.unmodifiable(
        _notifications.where((n) => n.deviceId == deviceId || n.deviceId == null),
      );
    }
    return List.unmodifiable(_notifications);
  }

  @override
  Stream<List<UnitNotification>> watchNotifications({String? deviceId}) {
    Future.microtask(() {
      if (deviceId != null) {
        _controller.add(
          _notifications.where((n) => n.deviceId == deviceId || n.deviceId == null).toList(),
        );
      } else {
        _controller.add(List.unmodifiable(_notifications));
      }
    });
    return _controller.stream;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(MockData.fastDelay);

    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications = List.from(_notifications)
        ..[index] = _notifications[index].markAsRead();
      _controller.add(List.unmodifiable(_notifications));
    }
  }

  @override
  Future<void> markAllAsRead({String? deviceId}) async {
    await Future.delayed(MockData.normalDelay);

    _notifications = _notifications.map((n) {
      if (deviceId == null || n.deviceId == deviceId) {
        return n.markAsRead();
      }
      return n;
    }).toList();
    _controller.add(List.unmodifiable(_notifications));
  }

  @override
  Future<void> dismiss(String notificationId) async {
    await Future.delayed(MockData.fastDelay);

    _notifications = _notifications.where((n) => n.id != notificationId).toList();
    _controller.add(List.unmodifiable(_notifications));
  }

  @override
  Future<int> getUnreadCount({String? deviceId}) async {
    await Future.delayed(MockData.fastDelay);

    if (deviceId != null) {
      return _notifications
          .where((n) => !n.isRead && (n.deviceId == deviceId || n.deviceId == null))
          .length;
    }
    return _notifications.where((n) => !n.isRead).length;
  }

  void dispose() {
    _controller.close();
  }
}
