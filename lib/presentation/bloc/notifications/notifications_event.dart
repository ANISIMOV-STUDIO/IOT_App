part of 'notifications_bloc.dart';

/// События для NotificationsBloc
///
/// Именование по конвенции flutter_bloc:
/// - sealed class для базового события
/// - final class для конкретных событий
/// - Префикс Notifications + существительное + прошедшее время
sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

// ============================================
// СОБЫТИЯ ЖИЗНЕННОГО ЦИКЛА
// ============================================

/// Запрос на подписку к уведомлениям (инициализация)
final class NotificationsSubscriptionRequested extends NotificationsEvent {
  const NotificationsSubscriptionRequested();
}

/// Смена текущего устройства — перезагрузить уведомления
final class NotificationsDeviceChanged extends NotificationsEvent {
  final String? deviceId;

  const NotificationsDeviceChanged(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

/// Список уведомлений обновлён (из стрима)
final class NotificationsListUpdated extends NotificationsEvent {
  final List<UnitNotification> notifications;

  const NotificationsListUpdated(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

// ============================================
// ДЕЙСТВИЯ С УВЕДОМЛЕНИЯМИ
// ============================================

/// Запрос на отметку уведомления как прочитанного
final class NotificationsMarkAsReadRequested extends NotificationsEvent {
  final String notificationId;

  const NotificationsMarkAsReadRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Запрос на отметку всех уведомлений как прочитанных
final class NotificationsMarkAllAsReadRequested extends NotificationsEvent {
  const NotificationsMarkAllAsReadRequested();
}

/// Запрос на удаление уведомления
final class NotificationsDismissRequested extends NotificationsEvent {
  final String notificationId;

  const NotificationsDismissRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
