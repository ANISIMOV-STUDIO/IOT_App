/// Фабрика для создания AnalyticsDataSource
///
/// Abstract Factory Pattern: создает нужную реализацию в зависимости от платформы.
/// - Web: HTTP (gRPC не поддерживается браузерами)
/// - Mobile/Desktop: gRPC (лучшая производительность)
library;

import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/datasources/analytics/analytics_data_source.dart';

// Conditional imports - выбор реализации в зависимости от платформы
import 'package:hvac_control/data/datasources/analytics/analytics_data_source_mobile.dart'
    if (dart.library.html) 'analytics_data_source_web.dart';

/// Фабрика для создания platform-specific AnalyticsDataSource
class AnalyticsDataSourceFactory {
  /// Создает AnalyticsDataSource для текущей платформы
  ///
  /// [apiClient] - клиент API с gRPC channel (mobile) или HTTP client (web)
  static AnalyticsDataSource create(ApiClient apiClient) => createPlatformAnalyticsDataSource(apiClient);
}
