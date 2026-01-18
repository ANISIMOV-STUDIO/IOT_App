/// Web реализация фабрики NotificationDataSource
///
/// Использует HTTP. Real-time через SignalR (обрабатывается в repository).
library;

import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/datasources/notification/notification_data_source.dart';
import 'package:hvac_control/data/datasources/notification/notification_http_data_source.dart';

/// Создает HTTP-based NotificationDataSource для web
NotificationDataSource createPlatformNotificationDataSource(ApiClient apiClient) => NotificationHttpDataSource(apiClient);
