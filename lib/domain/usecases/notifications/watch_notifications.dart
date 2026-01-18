/// Use Case: Подписка на обновления уведомлений
library;

import 'package:hvac_control/domain/entities/unit_notification.dart';
import 'package:hvac_control/domain/repositories/notification_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для подписки на уведомления
class WatchNotificationsParams {

  const WatchNotificationsParams({this.deviceId});
  final String? deviceId;
}

/// Подписаться на обновления уведомлений
class WatchNotifications extends StreamUseCaseWithParams<List<UnitNotification>,
    WatchNotificationsParams> {

  WatchNotifications(this._repository);
  final NotificationRepository _repository;

  @override
  Stream<List<UnitNotification>> call(WatchNotificationsParams params) => _repository.watchNotifications(deviceId: params.deviceId);
}
