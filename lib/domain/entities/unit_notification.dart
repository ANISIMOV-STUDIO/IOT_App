/// Unit Notification Entity - Represents a notification for HVAC unit
library;

import 'package:equatable/equatable.dart';

/// Notification type
enum NotificationType { info, warning, error, success }

/// Notification item for HVAC unit
class UnitNotification extends Equatable {

  const UnitNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.deviceId,
    this.isRead = false,
  });
  final String id;
  final String? deviceId;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  UnitNotification copyWith({
    String? id,
    String? deviceId,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
  }) => UnitNotification(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );

  /// Mark notification as read
  UnitNotification markAsRead() => copyWith(isRead: true);

  @override
  List<Object?> get props => [id, deviceId, title, message, type, timestamp, isRead];
}
