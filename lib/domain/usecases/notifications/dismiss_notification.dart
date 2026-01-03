/// Use Case: Удалить уведомление
library;

import '../../repositories/notification_repository.dart';
import '../usecase.dart';

/// Параметры для удаления уведомления
class DismissNotificationParams {
  final String notificationId;

  const DismissNotificationParams({required this.notificationId});
}

/// Удалить уведомление
class DismissNotification
    extends UseCaseWithParams<void, DismissNotificationParams> {
  final NotificationRepository _repository;

  DismissNotification(this._repository);

  @override
  Future<void> call(DismissNotificationParams params) async {
    return _repository.dismiss(params.notificationId);
  }
}
