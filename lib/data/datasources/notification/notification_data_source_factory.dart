/// Фабрика для создания NotificationDataSource
///
/// Abstract Factory Pattern: создает нужную реализацию в зависимости от платформы.
/// - Web: HTTP (real-time через SignalR в repository)
/// - Mobile/Desktop: gRPC (real-time через gRPC streaming)
library;

import '../../api/platform/api_client.dart';
import 'notification_data_source.dart';

// Conditional imports - выбор реализации в зависимости от платформы
import 'notification_data_source_mobile.dart'
    if (dart.library.html) 'notification_data_source_web.dart';

/// Фабрика для создания platform-specific NotificationDataSource
class NotificationDataSourceFactory {
  /// Создает NotificationDataSource для текущей платформы
  static NotificationDataSource create(ApiClient apiClient) {
    return createPlatformNotificationDataSource(apiClient);
  }
}
