/// Абстрактный интерфейс для операций с уведомлениями
///
/// Strategy Pattern: позволяет переключаться между:
/// - HTTP + SignalR (web) - SignalR для real-time
/// - gRPC + streaming (mobile/desktop) - gRPC streaming для real-time
library;

import 'package:hvac_control/domain/entities/unit_notification.dart';

/// DTO для уведомления (platform-agnostic)
class NotificationDto {

  const NotificationDto({
    required this.id,
    required this.deviceId,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });
  final String id;
  final String deviceId;
  final String title;
  final String message;
  final String type;
  final DateTime timestamp;
  final bool isRead;

  /// Конвертация в domain entity
  UnitNotification toEntity() => UnitNotification(
      id: id,
      deviceId: deviceId,
      title: title,
      message: message,
      type: _parseType(type),
      timestamp: timestamp,
      isRead: isRead,
    );

  static NotificationType _parseType(String type) {
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
}

/// Абстрактный источник данных для уведомлений
///
/// Реализации:
/// - [NotificationHttpDataSource] для Web (HTTP + SignalR)
/// - [NotificationGrpcDataSource] для Mobile/Desktop (gRPC + streaming)
abstract class NotificationDataSource {
  /// Получить список уведомлений
  Future<List<NotificationDto>> getNotifications({String? deviceId});

  /// Отметить уведомления как прочитанные
  Future<void> markAsRead(List<String> notificationIds);

  /// Удалить уведомление
  Future<void> dismiss(String notificationId);

  /// Стрим новых уведомлений в реальном времени
  ///
  /// На mobile/desktop использует gRPC streaming.
  /// На web использует SignalR (передается отдельно в repository).
  Stream<NotificationDto>? watchNotifications({String? deviceId});

  /// Освободить ресурсы
  void dispose();
}
