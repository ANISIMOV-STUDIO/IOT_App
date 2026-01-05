/// gRPC реализация NotificationDataSource
///
/// Используется на Mobile/Desktop платформах.
/// Real-time обновления через gRPC server-side streaming.
library;

import 'dart:async';

import 'package:grpc/grpc.dart';

import '../../../generated/protos/protos.dart' as proto;
import '../../../generated/protos/google/protobuf/timestamp.pb.dart' as ts;
import '../../api/grpc/grpc_interceptor.dart';
import 'notification_data_source.dart';

class NotificationGrpcDataSource implements NotificationDataSource {
  final ClientChannel _channel;
  final Future<String?> Function() _getToken;
  late final proto.NotificationServiceClient _client;

  StreamSubscription<proto.Notification>? _streamSubscription;
  final _notificationController = StreamController<NotificationDto>.broadcast();

  NotificationGrpcDataSource(this._channel, this._getToken) {
    _client = proto.NotificationServiceClient(
      _channel,
      interceptors: [AuthGrpcInterceptor(_getToken)],
    );
  }

  @override
  Future<List<NotificationDto>> getNotifications({String? deviceId}) async {
    final request = proto.GetNotificationsRequest()..limit = 50;
    if (deviceId != null) {
      request.deviceId = deviceId;
    }

    final response = await _client.getNotifications(request);

    return response.notifications.map(_protoToDto).toList();
  }

  @override
  Future<void> markAsRead(List<String> notificationIds) async {
    final request = proto.MarkAsReadRequest()..notificationIds.addAll(notificationIds);
    await _client.markAsRead(request);
  }

  @override
  Future<void> dismiss(String notificationId) async {
    final request = proto.DeleteNotificationRequest()..id = notificationId;
    await _client.deleteNotification(request);
  }

  @override
  Stream<NotificationDto> watchNotifications({String? deviceId}) {
    // Отменяем предыдущую подписку
    _streamSubscription?.cancel();

    final request = proto.StreamNotificationsRequest();
    if (deviceId != null) {
      request.deviceId = deviceId;
    }

    // Подключаемся к gRPC стриму
    _streamSubscription = _client.streamNotifications(request).listen(
      (notification) {
        _notificationController.add(_protoToDto(notification));
      },
      onError: (error) {
        _notificationController.addError(error);
      },
    );

    return _notificationController.stream;
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _notificationController.close();
  }

  // ============================================
  // ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
  // ============================================

  NotificationDto _protoToDto(proto.Notification protoNotification) {
    return NotificationDto(
      id: protoNotification.id,
      deviceId: protoNotification.deviceId,
      title: protoNotification.title,
      message: protoNotification.message,
      type: _protoTypeToString(protoNotification.type),
      timestamp: _fromTimestamp(protoNotification.timestamp),
      isRead: protoNotification.isRead,
    );
  }

  String _protoTypeToString(proto.NotificationType type) {
    switch (type) {
      case proto.NotificationType.NOTIFICATION_TYPE_INFO:
        return 'info';
      case proto.NotificationType.NOTIFICATION_TYPE_WARNING:
        return 'warning';
      case proto.NotificationType.NOTIFICATION_TYPE_ERROR:
        return 'error';
      default:
        return 'info';
    }
  }

  DateTime _fromTimestamp(ts.Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds.toInt() * 1000 + timestamp.nanos ~/ 1000000,
    );
  }
}
