/// Кеширующая обёртка для NotificationRepository
///
/// Уведомления: чтение кешируется, изменения статуса требуют сети.
library;

import '../../core/error/offline_exception.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/unit_notification.dart';
import '../../domain/repositories/notification_repository.dart';

/// Кеширующий декоратор для NotificationRepository
class CachedNotificationRepository implements NotificationRepository {
  final NotificationRepository _inner;
  final CacheService _cacheService;
  final ConnectivityService _connectivity;

  CachedNotificationRepository({
    required NotificationRepository inner,
    required CacheService cacheService,
    required ConnectivityService connectivity,
  })  : _inner = inner,
        _cacheService = cacheService,
        _connectivity = connectivity;

  // ============================================
  // READ OPERATIONS (кешируемые)
  // ============================================

  @override
  Future<List<UnitNotification>> getNotifications({String? deviceId}) async {
    if (_connectivity.isOnline) {
      try {
        final notifications = await _inner.getNotifications(deviceId: deviceId);
        await _cacheService.cacheNotifications(notifications, deviceId: deviceId);
        return notifications;
      } catch (e) {
        final cached = _cacheService.getCachedNotifications(deviceId: deviceId);
        if (cached != null) return cached;
        rethrow;
      }
    }

    final cached = _cacheService.getCachedNotifications(deviceId: deviceId);
    if (cached != null) return cached;

    throw const OfflineException(
      'Нет сохранённых уведомлений',
      operation: 'getNotifications',
    );
  }

  @override
  Stream<List<UnitNotification>> watchNotifications({String? deviceId}) {
    return _inner.watchNotifications(deviceId: deviceId);
  }

  @override
  Future<int> getUnreadCount({String? deviceId}) async {
    // Считаем из кешированного списка
    final notifications = await getNotifications(deviceId: deviceId);
    return notifications.where((n) => !n.isRead).length;
  }

  // ============================================
  // WRITE OPERATIONS (требуют сети)
  // ============================================

  @override
  Future<void> markAsRead(String notificationId) async {
    _ensureOnline('markAsRead');
    await _inner.markAsRead(notificationId);
    // Обновляем локальный кеш
    await _markAsReadInCache(notificationId);
  }

  @override
  Future<void> markAllAsRead({String? deviceId}) async {
    _ensureOnline('markAllAsRead');
    await _inner.markAllAsRead(deviceId: deviceId);
    // Обновляем локальный кеш
    await _markAllAsReadInCache(deviceId: deviceId);
  }

  @override
  Future<void> dismiss(String notificationId) async {
    _ensureOnline('dismiss');
    await _inner.dismiss(notificationId);
    // Удаляем из кеша
    await _removeFromCache(notificationId);
  }

  // ============================================
  // HELPERS
  // ============================================

  void _ensureOnline(String operation) {
    if (!_connectivity.isOnline) {
      throw OfflineException(
        'Изменение уведомлений недоступно без сети',
        operation: operation,
      );
    }
  }

  /// Отметить уведомление прочитанным в кеше
  Future<void> _markAsReadInCache(String notificationId) async {
    final cached = _cacheService.getCachedNotifications();
    if (cached == null) return;

    final updated = cached.map((n) {
      if (n.id == notificationId) {
        return UnitNotification(
          id: n.id,
          deviceId: n.deviceId,
          title: n.title,
          message: n.message,
          type: n.type,
          timestamp: n.timestamp,
          isRead: true,
        );
      }
      return n;
    }).toList();

    await _cacheService.cacheNotifications(updated);
  }

  /// Отметить все уведомления прочитанными в кеше
  Future<void> _markAllAsReadInCache({String? deviceId}) async {
    final cached = _cacheService.getCachedNotifications(deviceId: deviceId);
    if (cached == null) return;

    final updated = cached.map((n) {
      return UnitNotification(
        id: n.id,
        deviceId: n.deviceId,
        title: n.title,
        message: n.message,
        type: n.type,
        timestamp: n.timestamp,
        isRead: true,
      );
    }).toList();

    await _cacheService.cacheNotifications(updated, deviceId: deviceId);
  }

  /// Удалить уведомление из кеша
  Future<void> _removeFromCache(String notificationId) async {
    final cached = _cacheService.getCachedNotifications();
    if (cached == null) return;

    final updated = cached.where((n) => n.id != notificationId).toList();
    await _cacheService.cacheNotifications(updated);
  }
}
