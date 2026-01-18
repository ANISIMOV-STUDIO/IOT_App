/// Use Case: Удалить уведомление
library;

import 'package:hvac_control/domain/repositories/notification_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для удаления уведомления
class DismissNotificationParams {

  const DismissNotificationParams({required this.notificationId});
  final String notificationId;
}

/// Удалить уведомление
class DismissNotification
    extends UseCaseWithParams<void, DismissNotificationParams> {

  DismissNotification(this._repository);
  final NotificationRepository _repository;

  @override
  Future<void> call(DismissNotificationParams params) async {
    await _repository.dismiss(params.notificationId);
  }
}
