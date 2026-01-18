/// gRPC client for Notification Service (Mobile/Desktop)
/// Provides notifications with real-time streaming
library;

import 'package:grpc/grpc.dart';
import 'package:hvac_control/data/api/grpc/grpc_interceptor.dart';
import 'package:hvac_control/generated/protos/protos.dart';

/// gRPC client for notification operations
class NotificationGrpcClient {

  NotificationGrpcClient(this._channel, this._getToken) {
    _client = NotificationServiceClient(
      _channel,
      interceptors: [AuthGrpcInterceptor(_getToken)],
    );
  }
  final ClientChannel _channel;
  final Future<String?> Function() _getToken;
  late final NotificationServiceClient _client;

  /// Get notifications for user
  Future<List<Notification>> getNotifications({
    String? deviceId,
    int limit = 50,
    bool unreadOnly = false,
  }) async {
    final request = GetNotificationsRequest()
      ..limit = limit
      ..unreadOnly = unreadOnly;

    if (deviceId != null) {
      request.deviceId = deviceId;
    }

    final response = await _client.getNotifications(request);
    return response.notifications;
  }

  /// Mark notifications as read (by IDs)
  Future<void> markAsRead(List<String> notificationIds) async {
    final request = MarkAsReadRequest()..notificationIds.addAll(notificationIds);
    await _client.markAsRead(request);
  }

  /// Mark single notification as read
  Future<void> markOneAsRead(String notificationId) async {
    await markAsRead([notificationId]);
  }

  /// Delete notification
  Future<void> deleteNotification(String id) async {
    final request = DeleteNotificationRequest()..id = id;
    await _client.deleteNotification(request);
  }

  /// Stream notifications in real-time
  /// This provides live updates when new notifications arrive
  Stream<Notification> streamNotifications({String? deviceId}) {
    final request = StreamNotificationsRequest();
    if (deviceId != null) {
      request.deviceId = deviceId;
    }

    return _client.streamNotifications(request);
  }
}
