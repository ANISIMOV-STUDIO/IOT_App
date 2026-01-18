/// Use Case: Получить список уведомлений
library;

import 'package:hvac_control/domain/entities/unit_notification.dart';
import 'package:hvac_control/domain/repositories/notification_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для получения уведомлений
class GetNotificationsParams {

  const GetNotificationsParams({this.deviceId});
  final String? deviceId;
}

/// Получить список уведомлений
class GetNotifications
    extends UseCaseWithParams<List<UnitNotification>, GetNotificationsParams> {

  GetNotifications(this._repository);
  final NotificationRepository _repository;

  @override
  Future<List<UnitNotification>> call(GetNotificationsParams params) async => _repository.getNotifications(deviceId: params.deviceId);
}
