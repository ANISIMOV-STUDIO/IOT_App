/// Use Case: Подписка на обновления уведомлений
library;

import '../../entities/unit_notification.dart';
import '../../repositories/notification_repository.dart';
import '../usecase.dart';

/// Параметры для подписки на уведомления
class WatchNotificationsParams {
  final String? deviceId;

  const WatchNotificationsParams({this.deviceId});
}

/// Подписаться на обновления уведомлений
class WatchNotifications extends StreamUseCaseWithParams<List<UnitNotification>,
    WatchNotificationsParams> {
  final NotificationRepository _repository;

  WatchNotifications(this._repository);

  @override
  Stream<List<UnitNotification>> call(WatchNotificationsParams params) {
    return _repository.watchNotifications(deviceId: params.deviceId);
  }
}
