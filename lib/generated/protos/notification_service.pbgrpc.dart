// This is a generated file - do not edit.
//
// Generated from notification_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:hvac_control/generated/protos/common.pb.dart' as $1;
import 'package:hvac_control/generated/protos/notification.pb.dart' as $0;
import 'package:protobuf/protobuf.dart' as $pb;

export 'notification_service.pb.dart';

/// Сервис уведомлений
@$pb.GrpcServiceName('breez.NotificationService')
class NotificationServiceClient extends $grpc.Client {

  NotificationServiceClient(super.channel, {super.options, super.interceptors});
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  $grpc.ResponseFuture<$0.ListNotificationsResponse> getNotifications(
    $0.GetNotificationsRequest request, {
    $grpc.CallOptions? options,
  }) => $createUnaryCall(_$getNotifications, request, options: options);

  $grpc.ResponseFuture<$1.Empty> markAsRead(
    $0.MarkAsReadRequest request, {
    $grpc.CallOptions? options,
  }) => $createUnaryCall(_$markAsRead, request, options: options);

  $grpc.ResponseFuture<$1.Empty> deleteNotification(
    $0.DeleteNotificationRequest request, {
    $grpc.CallOptions? options,
  }) => $createUnaryCall(_$deleteNotification, request, options: options);

  /// Стриминг уведомлений в реальном времени
  $grpc.ResponseStream<$0.Notification> streamNotifications(
    $0.StreamNotificationsRequest request, {
    $grpc.CallOptions? options,
  }) => $createStreamingCall(
        _$streamNotifications, $async.Stream.fromIterable([request]),
        options: options,);

  // method descriptors

  static final _$getNotifications = $grpc.ClientMethod<
          $0.GetNotificationsRequest, $0.ListNotificationsResponse>(
      '/breez.NotificationService/GetNotifications',
      ($0.GetNotificationsRequest value) => value.writeToBuffer(),
      $0.ListNotificationsResponse.fromBuffer,);
  static final _$markAsRead =
      $grpc.ClientMethod<$0.MarkAsReadRequest, $1.Empty>(
          '/breez.NotificationService/MarkAsRead',
          ($0.MarkAsReadRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer,);
  static final _$deleteNotification =
      $grpc.ClientMethod<$0.DeleteNotificationRequest, $1.Empty>(
          '/breez.NotificationService/DeleteNotification',
          ($0.DeleteNotificationRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer,);
  static final _$streamNotifications =
      $grpc.ClientMethod<$0.StreamNotificationsRequest, $0.Notification>(
          '/breez.NotificationService/StreamNotifications',
          ($0.StreamNotificationsRequest value) => value.writeToBuffer(),
          $0.Notification.fromBuffer,);
}

@$pb.GrpcServiceName('breez.NotificationService')
abstract class NotificationServiceBase extends $grpc.Service {

  NotificationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetNotificationsRequest,
            $0.ListNotificationsResponse>(
        'GetNotifications',
        getNotifications_Pre,
        false,
        false,
        $0.GetNotificationsRequest.fromBuffer,
        ($0.ListNotificationsResponse value) => value.writeToBuffer(),),);
    $addMethod($grpc.ServiceMethod<$0.MarkAsReadRequest, $1.Empty>(
        'MarkAsRead',
        markAsRead_Pre,
        false,
        false,
        $0.MarkAsReadRequest.fromBuffer,
        ($1.Empty value) => value.writeToBuffer(),),);
    $addMethod($grpc.ServiceMethod<$0.DeleteNotificationRequest, $1.Empty>(
        'DeleteNotification',
        deleteNotification_Pre,
        false,
        false,
        $0.DeleteNotificationRequest.fromBuffer,
        ($1.Empty value) => value.writeToBuffer(),),);
    $addMethod(
        $grpc.ServiceMethod<$0.StreamNotificationsRequest, $0.Notification>(
            'StreamNotifications',
            streamNotifications_Pre,
            false,
            true,
            $0.StreamNotificationsRequest.fromBuffer,
            ($0.Notification value) => value.writeToBuffer(),),);
  }
  $core.String get $name => 'breez.NotificationService';

  $async.Future<$0.ListNotificationsResponse> getNotifications_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetNotificationsRequest> $request,) async => getNotifications($call, await $request);

  $async.Future<$0.ListNotificationsResponse> getNotifications(
      $grpc.ServiceCall call, $0.GetNotificationsRequest request,);

  $async.Future<$1.Empty> markAsRead_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MarkAsReadRequest> $request,) async => markAsRead($call, await $request);

  $async.Future<$1.Empty> markAsRead(
      $grpc.ServiceCall call, $0.MarkAsReadRequest request,);

  $async.Future<$1.Empty> deleteNotification_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteNotificationRequest> $request,) async => deleteNotification($call, await $request);

  $async.Future<$1.Empty> deleteNotification(
      $grpc.ServiceCall call, $0.DeleteNotificationRequest request,);

  $async.Stream<$0.Notification> streamNotifications_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StreamNotificationsRequest> $request,) async* {
    yield* streamNotifications($call, await $request);
  }

  $async.Stream<$0.Notification> streamNotifications(
      $grpc.ServiceCall call, $0.StreamNotificationsRequest request,);
}
