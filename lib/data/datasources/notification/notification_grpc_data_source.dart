/// gRPC реализация NotificationDataSource
///
/// Используется на Mobile/Desktop платформах.
/// Real-time обновления через gRPC server-side streaming.
// ignore_for_file: no_default_cases

library;

import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:hvac_control/data/api/grpc/grpc_interceptor.dart';
import 'package:hvac_control/data/datasources/notification/notification_data_source.dart';
import 'package:hvac_control/generated/protos/google/protobuf/timestamp.pb.dart' as ts;
import 'package:hvac_control/generated/protos/protos.dart' as proto;

class NotificationGrpcDataSource implements NotificationDataSource {

  NotificationGrpcDataSource(this._channel, this._getToken) {
    _client = proto.NotificationServiceClient(
      _channel,
      interceptors: [AuthGrpcInterceptor(_getToken)],
    );
  }
  final ClientChannel _channel;
  final Future<String?> Function() _getToken;
  late final proto.NotificationServiceClient _client;

  StreamSubscription<proto.Notification>? _streamSubscription;
  final _notificationController = StreamController<NotificationDto>.broadcast();

  /// Флаг для предотвращения race condition при dispose
  bool _isDisposed = false;

  @override
  Future<List<NotificationDto>> getNotifications({String? deviceId}) async {
    if (_isDisposed) {
      return [];
    }

    final request = proto.GetNotificationsRequest()..limit = 50;
    if (deviceId != null) {
      request.deviceId = deviceId;
    }

    final response = await _client.getNotifications(request);

    return response.notifications.map(_protoToDto).toList();
  }

  @override
  Future<void> markAsRead(List<String> notificationIds) async {
    if (_isDisposed) {
      return;
    }

    final request = proto.MarkAsReadRequest()..notificationIds.addAll(notificationIds);
    await _client.markAsRead(request);
  }

  @override
  Future<void> dismiss(String notificationId) async {
    if (_isDisposed) {
      return;
    }

    final request = proto.DeleteNotificationRequest()..id = notificationId;
    await _client.deleteNotification(request);
  }

  @override
  Stream<NotificationDto> watchNotifications({String? deviceId}) {
    if (_isDisposed) {
      return const Stream.empty();
    }

    // Отменяем предыдущую подписку
    _streamSubscription?.cancel();

    final request = proto.StreamNotificationsRequest();
    if (deviceId != null) {
      request.deviceId = deviceId;
    }

    // Подключаемся к gRPC стриму
    _streamSubscription = _client.streamNotifications(request).listen(
      (notification) {
        if (_isDisposed) {
          return;
        }
        if (!_notificationController.isClosed) {
          _notificationController.add(_protoToDto(notification));
        }
      },
      onError: (Object error) {
        if (_isDisposed) {
          return;
        }
        if (!_notificationController.isClosed) {
          _notificationController.addError(error);
        }
      },
    );

    return _notificationController.stream;
  }

  @override
  void dispose() {
    // Сначала помечаем как disposed чтобы остановить все операции
    _isDisposed = true;

    _streamSubscription?.cancel();
    _notificationController.close();
  }

  // ============================================
  // ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
  // ============================================

  NotificationDto _protoToDto(proto.Notification protoNotification) => NotificationDto(
      id: protoNotification.id,
      deviceId: protoNotification.deviceId,
      title: protoNotification.title,
      message: protoNotification.message,
      type: _protoTypeToString(protoNotification.type),
      timestamp: _fromTimestamp(protoNotification.timestamp),
      isRead: protoNotification.isRead,
    );

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

  DateTime _fromTimestamp(ts.Timestamp timestamp) => DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds.toInt() * 1000 + timestamp.nanos ~/ 1000000,
    );
}
