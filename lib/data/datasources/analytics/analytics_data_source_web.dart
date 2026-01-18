/// Web реализация фабрики AnalyticsDataSource
///
/// Использует HTTP, так как gRPC не поддерживается в браузерах.
library;

import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/datasources/analytics/analytics_data_source.dart';
import 'package:hvac_control/data/datasources/analytics/analytics_http_data_source.dart';

/// Создает HTTP-based AnalyticsDataSource для web
AnalyticsDataSource createPlatformAnalyticsDataSource(ApiClient apiClient) => AnalyticsHttpDataSource(apiClient);
