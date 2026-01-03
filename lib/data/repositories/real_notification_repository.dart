/// Реальная реализация NotificationRepository
///
/// Использует HTTP API для CRUD операций и SignalR для real-time обновлений
library;

import 'dart:async';
import '../../domain/entities/unit_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../api/platform/api_client.dart';
import '../api/http/clients/notification_http_client.dart';
import '../api/websocket/signalr_hub_connection.dart';

class RealNotificationRepository implements NotificationRepository {
  final ApiClient _apiClient;
  final SignalRHubConnection? _signalR;
  late final NotificationHttpClient _httpClient;

  final _notificationsController =
      StreamController<List<UnitNotification>>.broadcast();

  StreamSubscription<Map<String, dynamic>>? _signalRSubscription;
  List<UnitNotification> _cachedNotifications = [];

  RealNotificationRepository(this._apiClient, [this._signalR]) {
    _httpClient = NotificationHttpClient(_apiClient);
    _setupSignalRSubscription();
  }

  /// Настройка подписки на SignalR уведомления
  void _setupSignalRSubscription() {
    if (_signalR == null) return;

    _signalRSubscription = _signalR.notifications.listen((data) {
      try {
        final notification = _parseNotification(data);
        // Добавляем новое уведомление в начало списка
        _cachedNotifications = [notification, ..._cachedNotifications];
        _notificationsController.add(_cachedNotifications);
      } catch (e) {
        // Логируем ошибку парсинга, но не прерываем стрим
      }
    });
  }

  /// Парсинг уведомления из JSON
  UnitNotification _parseNotification(Map<String, dynamic> json) {
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
    final jsonNotifications = await _httpClient.getNotifications(deviceId: deviceId);

    _cachedNotifications = jsonNotifications.map(_parseNotification).toList();
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
    // SignalR будет автоматически добавлять новые уведомления в стрим
    return _notificationsController.stream;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _httpClient.markAsRead([notificationId]);
  }

  @override
  Future<void> markAllAsRead({String? deviceId}) async {
    // Получаем все уведомления и отмечаем непрочитанные
    final notifications = await getNotifications(deviceId: deviceId);
    final unreadIds = notifications
        .where((n) => !n.isRead)
        .map((n) => n.id)
        .toList();

    if (unreadIds.isNotEmpty) {
      await _httpClient.markAsRead(unreadIds);
    }
  }

  @override
  Future<void> dismiss(String notificationId) async {
    await _httpClient.dismiss(notificationId);
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
    _signalRSubscription?.cancel();
    _notificationsController.close();
  }
}
