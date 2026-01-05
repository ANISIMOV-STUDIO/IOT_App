/// Web реализация фабрики NotificationDataSource
///
/// Использует HTTP. Real-time через SignalR (обрабатывается в repository).
library;

import '../../api/platform/api_client.dart';
import 'notification_data_source.dart';
import 'notification_http_data_source.dart';

/// Создает HTTP-based NotificationDataSource для web
NotificationDataSource createPlatformNotificationDataSource(ApiClient apiClient) {
  return NotificationHttpDataSource(apiClient);
}
