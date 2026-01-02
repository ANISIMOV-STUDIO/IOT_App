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
import '../../../domain/repositories/notification_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// BLoC для управления уведомлениями
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _notificationRepository;

  StreamSubscription<List<UnitNotification>>? _notificationsSubscription;

  NotificationsBloc({
    required NotificationRepository notificationRepository,
  })  : _notificationRepository = notificationRepository,
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
      // Загружаем уведомления для всех устройств
      final notifications = await _notificationRepository.getNotifications();

      emit(state.copyWith(
        status: NotificationsStatus.success,
        notifications: notifications,
      ));

      // Подписываемся на обновления
      await _notificationsSubscription?.cancel();
      _notificationsSubscription = _notificationRepository
          .watchNotifications()
          .listen((notifications) => add(NotificationsListUpdated(notifications)));
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
      final notifications = await _notificationRepository.getNotifications(
        deviceId: event.deviceId,
      );

      emit(state.copyWith(
        status: NotificationsStatus.success,
        notifications: notifications,
        currentDeviceId: event.deviceId,
      ));

      // Переподписываемся для нового устройства
      await _notificationsSubscription?.cancel();
      _notificationsSubscription = _notificationRepository
          .watchNotifications(deviceId: event.deviceId)
          .listen((notifications) => add(NotificationsListUpdated(notifications)));
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
      await _notificationRepository.markAsRead(event.notificationId);

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
      emit(state.copyWith(errorMessage: 'Ошибка отметки уведомления: $e'));
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
          await _notificationRepository.markAsRead(n.id);
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
      emit(state.copyWith(errorMessage: 'Ошибка отметки уведомлений: $e'));
    }
  }

  /// Удалить уведомление
  Future<void> _onDismissRequested(
    NotificationsDismissRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _notificationRepository.dismiss(event.notificationId);

      // Удаляем из локального списка
      final updatedNotifications = state.notifications
          .where((n) => n.id != event.notificationId)
          .toList();

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка удаления уведомления: $e'));
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
