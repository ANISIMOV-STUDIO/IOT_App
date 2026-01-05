/// Реальная реализация NotificationRepository
///
/// Использует NotificationDataSource для получения уведомлений.
/// Real-time обновления:
/// - Mobile/Desktop: gRPC streaming (через DataSource)
/// - Web: SignalR (передается отдельно)
library;

import 'dart:async';
import '../../domain/entities/unit_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../api/websocket/signalr_hub_connection.dart';
import '../datasources/notification/notification_data_source.dart';

class RealNotificationRepository implements NotificationRepository {
  final NotificationDataSource _dataSource;
  final SignalRHubConnection? _signalR;

  final _notificationsController =
      StreamController<List<UnitNotification>>.broadcast();

  StreamSubscription<NotificationDto>? _dataSourceSubscription;
  StreamSubscription<Map<String, dynamic>>? _signalRSubscription;
  List<UnitNotification> _cachedNotifications = [];

  RealNotificationRepository(this._dataSource, [this._signalR]) {
    _setupRealTimeUpdates();
  }

  /// Настройка real-time обновлений
  void _setupRealTimeUpdates() {
    // Пробуем использовать gRPC streaming из DataSource
    final dataSourceStream = _dataSource.watchNotifications();
    if (dataSourceStream != null) {
      _dataSourceSubscription = dataSourceStream.listen((dto) {
        final notification = dto.toEntity();
        _cachedNotifications = [notification, ..._cachedNotifications];
        _notificationsController.add(_cachedNotifications);
      });
    } else if (_signalR != null) {
      // Fallback на SignalR для web
      _signalRSubscription = _signalR.notifications.listen((data) {
        try {
          final notification = _parseNotificationFromJson(data);
          _cachedNotifications = [notification, ..._cachedNotifications];
          _notificationsController.add(_cachedNotifications);
        } catch (e) {
          // Логируем ошибку парсинга, но не прерываем стрим
        }
      });
    }
  }

  /// Парсинг уведомления из JSON (для SignalR)
  UnitNotification _parseNotificationFromJson(Map<String, dynamic> json) {
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
  }

  @override
  Future<List<UnitNotification>> getNotifications({String? deviceId}) async {
    final dtos = await _dataSource.getNotifications(deviceId: deviceId);
    _cachedNotifications = dtos.map((dto) => dto.toEntity()).toList();
    return _cachedNotifications;
  }

  @override
  Stream<List<UnitNotification>> watchNotifications({String? deviceId}) {
    // Загружаем начальные данные
    getNotifications(deviceId: deviceId).then(
      (notifications) {
        _cachedNotifications = notifications;
        _notificationsController.add(notifications);
      },
      onError: (error) {
        _notificationsController.addError(error);
      },
    );
    return _notificationsController.stream;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _dataSource.markAsRead([notificationId]);
  }

  @override
  Future<void> markAllAsRead({String? deviceId}) async {
    final notifications = await getNotifications(deviceId: deviceId);
    final unreadIds = notifications
        .where((n) => !n.isRead)
        .map((n) => n.id)
        .toList();

    if (unreadIds.isNotEmpty) {
      await _dataSource.markAsRead(unreadIds);
    }
  }

  @override
  Future<void> dismiss(String notificationId) async {
    await _dataSource.dismiss(notificationId);
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
    _dataSourceSubscription?.cancel();
    _signalRSubscription?.cancel();
    _notificationsController.close();
    _dataSource.dispose();
  }
}
