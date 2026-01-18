/// Notification Repository - Interface for notification operations
library;

import 'package:hvac_control/domain/entities/unit_notification.dart';

/// Interface for notification data access and operations
abstract class NotificationRepository {
  /// Get all notifications, optionally filtered by device
  Future<List<UnitNotification>> getNotifications({String? deviceId});

  /// Watch for notification updates
  Stream<List<UnitNotification>> watchNotifications({String? deviceId});

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<void> markAllAsRead({String? deviceId});

  /// Dismiss (delete) a notification
  Future<void> dismiss(String notificationId);

  /// Get unread notification count
  Future<int> getUnreadCount({String? deviceId});
}
