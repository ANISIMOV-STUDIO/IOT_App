/// Mobile/Desktop реализация фабрики NotificationDataSource
///
/// Использует gRPC для лучшей производительности + gRPC streaming для real-time.
library;

import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/datasources/notification/notification_data_source.dart';
import 'package:hvac_control/data/datasources/notification/notification_grpc_data_source.dart';

/// Создает gRPC-based NotificationDataSource для mobile/desktop
NotificationDataSource createPlatformNotificationDataSource(ApiClient apiClient) {
  final channel = apiClient.getGrpcChannel();
  if (channel == null) {
    throw StateError(
      'gRPC channel не доступен. '
      'Убедитесь, что приложение запущено на mobile/desktop платформе.',
    );
  }
  return NotificationGrpcDataSource(channel, apiClient.getAuthToken);
}
