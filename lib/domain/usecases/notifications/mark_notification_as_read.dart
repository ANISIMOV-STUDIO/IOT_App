/// Use Case: Отметить уведомление как прочитанное
library;

import 'package:hvac_control/domain/repositories/notification_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для отметки уведомления
class MarkNotificationAsReadParams {

  const MarkNotificationAsReadParams({required this.notificationId});
  final String notificationId;
}

/// Отметить уведомление как прочитанное
class MarkNotificationAsRead
    extends UseCaseWithParams<void, MarkNotificationAsReadParams> {

  MarkNotificationAsRead(this._repository);
  final NotificationRepository _repository;

  @override
  Future<void> call(MarkNotificationAsReadParams params) async {
    await _repository.markAsRead(params.notificationId);
  }
}
