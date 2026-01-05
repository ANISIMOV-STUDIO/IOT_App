/// Notifications BLoC — управление уведомлениями устройств
///
/// Отвечает за:
/// - Загрузку списка уведомлений
/// - Отметку уведомлений как прочитанных
/// - Удаление уведомлений
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/unit_notification.dart';
import '../../../domain/usecases/usecases.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// BLoC для управления уведомлениями
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotifications _getNotifications;
  final WatchNotifications _watchNotifications;
  final MarkNotificationAsRead _markNotificationAsRead;
  final DismissNotification _dismissNotification;

  StreamSubscription<List<UnitNotification>>? _notificationsSubscription;

  NotificationsBloc({
    required GetNotifications getNotifications,
    required WatchNotifications watchNotifications,
    required MarkNotificationAsRead markNotificationAsRead,
    required DismissNotification dismissNotification,
  })  : _getNotifications = getNotifications,
        _watchNotifications = watchNotifications,
        _markNotificationAsRead = markNotificationAsRead,
        _dismissNotification = dismissNotification,
        super(const NotificationsState()) {
    // События жизненного цикла
    on<NotificationsSubscriptionRequested>(_onSubscriptionRequested);
    on<NotificationsDeviceChanged>(_onDeviceChanged);
    on<NotificationsListUpdated>(_onListUpdated);

    // Действия с уведомлениями
    on<NotificationsMarkAsReadRequested>(_onMarkAsReadRequested);
    on<NotificationsMarkAllAsReadRequested>(_onMarkAllAsReadRequested);
    on<NotificationsDismissRequested>(_onDismissRequested);
  }

  /// Запрос на подписку к уведомлениям
  Future<void> _onSubscriptionRequested(
    NotificationsSubscriptionRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    try {
      // Загружаем уведомления для всех устройств через Use Case
      final notifications = await _getNotifications(
        const GetNotificationsParams(),
      );

      emit(state.copyWith(
        status: NotificationsStatus.success,
        notifications: notifications,
      ));

      // Подписываемся на обновления через Use Case
      await _notificationsSubscription?.cancel();
      _notificationsSubscription = _watchNotifications(
        const WatchNotificationsParams(),
      ).listen((notifications) => add(NotificationsListUpdated(notifications)));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Смена устройства — перезагружаем уведомления для него
  Future<void> _onDeviceChanged(
    NotificationsDeviceChanged event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    try {
      final notifications = await _getNotifications(
        GetNotificationsParams(deviceId: event.deviceId),
      );

      emit(state.copyWith(
        status: NotificationsStatus.success,
        notifications: notifications,
        currentDeviceId: event.deviceId,
      ));

      // Переподписываемся для нового устройства
      await _notificationsSubscription?.cancel();
      _notificationsSubscription = _watchNotifications(
        WatchNotificationsParams(deviceId: event.deviceId),
      ).listen((notifications) => add(NotificationsListUpdated(notifications)));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Обновление списка уведомлений из стрима
  void _onListUpdated(
    NotificationsListUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(notifications: event.notifications));
  }

  /// Отметить уведомление как прочитанное
  Future<void> _onMarkAsReadRequested(
    NotificationsMarkAsReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _markNotificationAsRead(
        MarkNotificationAsReadParams(notificationId: event.notificationId),
      );

      // Обновляем локальный список
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == event.notificationId) {
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

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Mark notification error: $e'));
    }
  }

  /// Отметить все уведомления как прочитанные
  Future<void> _onMarkAllAsReadRequested(
    NotificationsMarkAllAsReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      // Отмечаем все непрочитанные
      for (final n in state.notifications) {
        if (!n.isRead) {
          await _markNotificationAsRead(
            MarkNotificationAsReadParams(notificationId: n.id),
          );
        }
      }

      // Обновляем локальный список
      final updatedNotifications = state.notifications.map((n) {
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

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Mark all notifications error: $e'));
    }
  }

  /// Удалить уведомление
  Future<void> _onDismissRequested(
    NotificationsDismissRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _dismissNotification(
        DismissNotificationParams(notificationId: event.notificationId),
      );

      // Удаляем из локального списка
      final updatedNotifications = state.notifications
          .where((n) => n.id != event.notificationId)
          .toList();

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Delete notification error: $e'));
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
