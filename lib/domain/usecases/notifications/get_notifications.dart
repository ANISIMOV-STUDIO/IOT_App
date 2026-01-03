/// Use Case: Получить список уведомлений
library;

import '../../entities/unit_notification.dart';
import '../../repositories/notification_repository.dart';
import '../usecase.dart';

/// Параметры для получения уведомлений
class GetNotificationsParams {
  final String? deviceId;

  const GetNotificationsParams({this.deviceId});
}

/// Получить список уведомлений
class GetNotifications
    extends UseCaseWithParams<List<UnitNotification>, GetNotificationsParams> {
  final NotificationRepository _repository;

  GetNotifications(this._repository);

  @override
  Future<List<UnitNotification>> call(GetNotificationsParams params) async {
    return _repository.getNotifications(deviceId: params.deviceId);
  }
}
