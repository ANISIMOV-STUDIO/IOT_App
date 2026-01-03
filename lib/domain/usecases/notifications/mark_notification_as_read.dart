/// Use Case: Отметить уведомление как прочитанное
library;

import '../../repositories/notification_repository.dart';
import '../usecase.dart';

/// Параметры для отметки уведомления
class MarkNotificationAsReadParams {
  final String notificationId;

  const MarkNotificationAsReadParams({required this.notificationId});
}

/// Отметить уведомление как прочитанное
class MarkNotificationAsRead
    extends UseCaseWithParams<void, MarkNotificationAsReadParams> {
  final NotificationRepository _repository;

  MarkNotificationAsRead(this._repository);

  @override
  Future<void> call(MarkNotificationAsReadParams params) async {
    return _repository.markAsRead(params.notificationId);
  }
}
