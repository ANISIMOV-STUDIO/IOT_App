/// Реальная реализация NotificationRepository
///
/// Использует NotificationDataSource для получения уведомлений.
/// Real-time обновления:
/// - Mobile/Desktop: gRPC streaming (через DataSource)
/// - Web: SignalR (передается отдельно)
// ignore_for_file: join_return_with_assignment

library;

import 'dart:async';

import 'package:hvac_control/data/api/websocket/signalr_hub_connection.dart';
import 'package:hvac_control/data/datasources/notification/notification_data_source.dart';
import 'package:hvac_control/domain/entities/unit_notification.dart';
import 'package:hvac_control/domain/repositories/notification_repository.dart';

class RealNotificationRepository implements NotificationRepository {

  RealNotificationRepository(this._dataSource, [this._signalR]) {
    _setupRealTimeUpdates();
  }
  final NotificationDataSource _dataSource;
  final SignalRHubConnection? _signalR;

  /// Максимальное количество уведомлений в кеше (защита от утечки памяти)
  static const int _maxCachedNotifications = 500;

  final _notificationsController =
      StreamController<List<UnitNotification>>.broadcast();

  StreamSubscription<NotificationDto>? _dataSourceSubscription;
  StreamSubscription<Map<String, dynamic>>? _signalRSubscription;
  List<UnitNotification> _cachedNotifications = [];

  /// Флаг для предотвращения race condition при dispose
  bool _isDisposed = false;

  /// Настройка real-time обновлений
  void _setupRealTimeUpdates() {
    // Пробуем использовать gRPC streaming из DataSource
    final dataSourceStream = _dataSource.watchNotifications();
    if (dataSourceStream != null) {
      _dataSourceSubscription = dataSourceStream.listen((dto) {
        if (_isDisposed) {
          return;
        }
        final notification = dto.toEntity();
        _addNotificationToCache(notification);
      });
    } else if (_signalR != null) {
      // Fallback на SignalR для web
      _signalRSubscription = _signalR.notifications.listen((data) {
        if (_isDisposed) {
          return;
        }
        try {
          final notification = _parseNotificationFromJson(data);
          _addNotificationToCache(notification);
        } catch (e) {
          // Логируем ошибку парсинга, но не прерываем стрим
        }
      });
    }
  }

  /// Добавляет уведомление в кеш с ограничением размера
  void _addNotificationToCache(UnitNotification notification) {
    if (_isDisposed) {
      return;
    }

    // Snapshot + update для избежания race condition
    final currentNotifications = List<UnitNotification>.from(_cachedNotifications);
    var updatedNotifications = [notification, ...currentNotifications];

    // Ограничиваем размер списка для предотвращения утечки памяти
    if (updatedNotifications.length > _maxCachedNotifications) {
      updatedNotifications = updatedNotifications.sublist(0, _maxCachedNotifications);
    }

    _cachedNotifications = updatedNotifications;

    if (!_notificationsController.isClosed) {
      _notificationsController.add(updatedNotifications);
    }
  }

  /// Парсинг уведомления из JSON (для SignalR)
  UnitNotification _parseNotificationFromJson(Map<String, dynamic> json) =>
    UnitNotification(
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
        if (_isDisposed) {
          return;
        }
        _cachedNotifications = notifications;
        if (!_notificationsController.isClosed) {
          _notificationsController.add(notifications);
        }
      },
      onError: (Object error) {
        if (!_isDisposed && !_notificationsController.isClosed) {
          _notificationsController.addError(error);
        }
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
    if (type == null) {
      return NotificationType.info;
    }

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
    // Сначала помечаем как disposed чтобы остановить все операции
    _isDisposed = true;

    _dataSourceSubscription?.cancel();
    _signalRSubscription?.cancel();
    _notificationsController.close();
    _dataSource.dispose();
  }
}
