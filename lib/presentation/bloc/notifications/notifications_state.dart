part of 'notifications_bloc.dart';

/// Статус загрузки NotificationsBloc
enum NotificationsStatus {
  /// Начальное состояние
  initial,

  /// Загрузка уведомлений
  loading,

  /// Успешная загрузка
  success,

  /// Ошибка загрузки
  failure,
}

/// Состояние списка уведомлений
final class NotificationsState extends Equatable {

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.currentDeviceId,
    this.errorMessage,
  });
  /// Статус загрузки
  final NotificationsStatus status;

  /// Список уведомлений
  final List<UnitNotification> notifications;

  /// ID текущего устройства (null = все устройства)
  final String? currentDeviceId;

  /// Сообщение об ошибке
  final String? errorMessage;

  // ============================================
  // ГЕТТЕРЫ ДЛЯ УДОБСТВА
  // ============================================

  /// Есть ли непрочитанные уведомления
  bool get hasUnread => notifications.any((n) => !n.isRead);

  /// Количество непрочитанных уведомлений
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  /// Пустой ли список
  bool get isEmpty => notifications.isEmpty;

  /// Количество уведомлений
  int get count => notifications.length;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<UnitNotification>? notifications,
    String? currentDeviceId,
    String? errorMessage,
  }) => NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      currentDeviceId: currentDeviceId ?? this.currentDeviceId,
      errorMessage: errorMessage,
    );

  @override
  List<Object?> get props => [
        status,
        notifications,
        currentDeviceId,
        errorMessage,
      ];
}
