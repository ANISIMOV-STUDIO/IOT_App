/// Notification entities for BREEZ app
library;

/// Notification priority levels
enum NotificationPriority {
  low,
  normal,
  high,
  critical,
}

/// Device alert types
enum DeviceAlertType {
  filterChange,
  maintenance,
  error,
  offline,
  connectionLost,
  firmwareUpdate,
}

/// Company notification types
enum CompanyNotificationType {
  update,
  news,
  promo,
  tip,
  security,
}

/// Base notification class
sealed class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationPriority priority;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.priority = NotificationPriority.normal,
    this.isRead = false,
  });

  /// Time ago string
  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
    if (diff.inHours < 24) return '${diff.inHours} ч назад';
    if (diff.inDays < 7) return '${diff.inDays} дн назад';
    return '${timestamp.day}.${timestamp.month}.${timestamp.year}';
  }
}

/// Device-specific alert (filter, error, maintenance)
class DeviceAlert extends AppNotification {
  final String deviceId;
  final String deviceName;
  final DeviceAlertType type;
  final String? actionRequired;
  final DateTime? dueDate;

  const DeviceAlert({
    required super.id,
    required super.title,
    required super.message,
    required super.timestamp,
    super.priority,
    super.isRead,
    required this.deviceId,
    required this.deviceName,
    required this.type,
    this.actionRequired,
    this.dueDate,
  });

  /// Days until due date
  int? get daysUntilDue {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  /// Is urgent (due soon or critical)
  bool get isUrgent =>
      priority == NotificationPriority.critical ||
      (daysUntilDue != null && daysUntilDue! <= 7);

  DeviceAlert copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationPriority? priority,
    bool? isRead,
    String? deviceId,
    String? deviceName,
    DeviceAlertType? type,
    String? actionRequired,
    DateTime? dueDate,
  }) {
    return DeviceAlert(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      type: type ?? this.type,
      actionRequired: actionRequired ?? this.actionRequired,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

/// Company-wide notification (updates, news, promos)
class CompanyNotification extends AppNotification {
  final CompanyNotificationType type;
  final String? actionUrl;
  final String? imageUrl;

  const CompanyNotification({
    required super.id,
    required super.title,
    required super.message,
    required super.timestamp,
    super.priority,
    super.isRead,
    required this.type,
    this.actionUrl,
    this.imageUrl,
  });

  /// Has action button
  bool get hasAction => actionUrl != null;

  CompanyNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationPriority? priority,
    bool? isRead,
    CompanyNotificationType? type,
    String? actionUrl,
    String? imageUrl,
  }) {
    return CompanyNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      actionUrl: actionUrl ?? this.actionUrl,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
