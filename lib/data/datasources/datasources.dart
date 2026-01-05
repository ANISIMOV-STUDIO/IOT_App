/// Data Sources - абстракции источников данных
///
/// Strategy Pattern для переключения между HTTP и gRPC
/// в зависимости от платформы.
library;

// Analytics
export 'analytics/analytics_data_source.dart';
export 'analytics/analytics_data_source_factory.dart';

// Notifications
export 'notification/notification_data_source.dart';
export 'notification/notification_data_source_factory.dart';
