// This is a generated file - do not edit.
//
// Generated from schedule_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;
import 'schedule.pb.dart' as $0;

export 'schedule_service.pb.dart';

/// Сервис управления расписаниями
@$pb.GrpcServiceName('breez.ScheduleService')
class ScheduleServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ScheduleServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListScheduleResponse> getSchedule(
    $0.GetScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSchedule, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScheduleEntry> createScheduleEntry(
    $0.CreateScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createScheduleEntry, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScheduleEntry> updateScheduleEntry(
    $0.UpdateScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateScheduleEntry, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteScheduleEntry(
    $0.DeleteScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteScheduleEntry, request, options: options);
  }

  // method descriptors

  static final _$getSchedule =
      $grpc.ClientMethod<$0.GetScheduleRequest, $0.ListScheduleResponse>(
          '/breez.ScheduleService/GetSchedule',
          ($0.GetScheduleRequest value) => value.writeToBuffer(),
          $0.ListScheduleResponse.fromBuffer);
  static final _$createScheduleEntry =
      $grpc.ClientMethod<$0.CreateScheduleRequest, $0.ScheduleEntry>(
          '/breez.ScheduleService/CreateScheduleEntry',
          ($0.CreateScheduleRequest value) => value.writeToBuffer(),
          $0.ScheduleEntry.fromBuffer);
  static final _$updateScheduleEntry =
      $grpc.ClientMethod<$0.UpdateScheduleRequest, $0.ScheduleEntry>(
          '/breez.ScheduleService/UpdateScheduleEntry',
          ($0.UpdateScheduleRequest value) => value.writeToBuffer(),
          $0.ScheduleEntry.fromBuffer);
  static final _$deleteScheduleEntry =
      $grpc.ClientMethod<$0.DeleteScheduleRequest, $1.Empty>(
          '/breez.ScheduleService/DeleteScheduleEntry',
          ($0.DeleteScheduleRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
}

@$pb.GrpcServiceName('breez.ScheduleService')
abstract class ScheduleServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.ScheduleService';

  ScheduleServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetScheduleRequest, $0.ListScheduleResponse>(
            'GetSchedule',
            getSchedule_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetScheduleRequest.fromBuffer(value),
            ($0.ListScheduleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateScheduleRequest, $0.ScheduleEntry>(
        'CreateScheduleEntry',
        createScheduleEntry_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateScheduleRequest.fromBuffer(value),
        ($0.ScheduleEntry value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateScheduleRequest, $0.ScheduleEntry>(
        'UpdateScheduleEntry',
        updateScheduleEntry_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateScheduleRequest.fromBuffer(value),
        ($0.ScheduleEntry value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteScheduleRequest, $1.Empty>(
        'DeleteScheduleEntry',
        deleteScheduleEntry_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteScheduleRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListScheduleResponse> getSchedule_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetScheduleRequest> $request) async {
    return getSchedule($call, await $request);
  }

  $async.Future<$0.ListScheduleResponse> getSchedule(
      $grpc.ServiceCall call, $0.GetScheduleRequest request);

  $async.Future<$0.ScheduleEntry> createScheduleEntry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateScheduleRequest> $request) async {
    return createScheduleEntry($call, await $request);
  }

  $async.Future<$0.ScheduleEntry> createScheduleEntry(
      $grpc.ServiceCall call, $0.CreateScheduleRequest request);

  $async.Future<$0.ScheduleEntry> updateScheduleEntry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateScheduleRequest> $request) async {
    return updateScheduleEntry($call, await $request);
  }

  $async.Future<$0.ScheduleEntry> updateScheduleEntry(
      $grpc.ServiceCall call, $0.UpdateScheduleRequest request);

  $async.Future<$1.Empty> deleteScheduleEntry_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteScheduleRequest> $request) async {
    return deleteScheduleEntry($call, await $request);
  }

  $async.Future<$1.Empty> deleteScheduleEntry(
      $grpc.ServiceCall call, $0.DeleteScheduleRequest request);
}
