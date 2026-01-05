/// Web реализация фабрики AnalyticsDataSource
///
/// Использует HTTP, так как gRPC не поддерживается в браузерах.
library;

import '../../api/platform/api_client.dart';
import 'analytics_data_source.dart';
import 'analytics_http_data_source.dart';

/// Создает HTTP-based AnalyticsDataSource для web
AnalyticsDataSource createPlatformAnalyticsDataSource(ApiClient apiClient) {
  return AnalyticsHttpDataSource(apiClient);
}
