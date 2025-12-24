/// Unit Notification Entity - Represents a notification for HVAC unit
library;

import 'package:equatable/equatable.dart';

/// Notification type
enum NotificationType { info, warning, error, success }

/// Notification item for HVAC unit
class UnitNotification extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  const UnitNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  UnitNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return UnitNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  /// Mark notification as read
  UnitNotification markAsRead() => copyWith(isRead: true);

  @override
  List<Object?> get props => [id, title, message, type, timestamp, isRead];
}
