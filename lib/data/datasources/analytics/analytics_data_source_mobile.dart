/// Mobile/Desktop реализация фабрики AnalyticsDataSource
///
/// Использует gRPC для лучшей производительности на нативных платформах.
library;

import '../../api/platform/api_client.dart';
import 'analytics_data_source.dart';
import 'analytics_grpc_data_source.dart';

/// Создает gRPC-based AnalyticsDataSource для mobile/desktop
AnalyticsDataSource createPlatformAnalyticsDataSource(ApiClient apiClient) {
  final channel = apiClient.getGrpcChannel();
  if (channel == null) {
    throw StateError(
      'gRPC channel не доступен. '
      'Убедитесь, что приложение запущено на mobile/desktop платформе.',
    );
  }
  return AnalyticsGrpcDataSource(channel, apiClient.getAuthToken);
}
