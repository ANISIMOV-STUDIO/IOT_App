/// gRPC API clients for Mobile/Desktop platforms
///
/// Backend implements gRPC for:
/// - AnalyticsService (graphs, energy, climate history)
/// - NotificationService (notifications with streaming)
///
/// HVAC devices use HTTP REST API (DeviceController)
library;

export 'clients/analytics_grpc_client.dart';
export 'clients/notification_grpc_client.dart';
export 'grpc_interceptor.dart';
