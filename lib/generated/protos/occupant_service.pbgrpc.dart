// This is a generated file - do not edit.
//
// Generated from occupant_service.proto.

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
import 'package:hvac_control/generated/protos/occupant.pb.dart' as $0;
import 'package:protobuf/protobuf.dart' as $pb;

export 'occupant_service.pb.dart';

/// Сервис управления жильцами
@$pb.GrpcServiceName('breez.OccupantService')
class OccupantServiceClient extends $grpc.Client {

  OccupantServiceClient(super.channel, {super.options, super.interceptors});
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  $grpc.ResponseFuture<$0.ListOccupantsResponse> getOccupants(
    $0.GetOccupantsRequest request, {
    $grpc.CallOptions? options,
  }) => $createUnaryCall(_$getOccupants, request, options: options);

  $grpc.ResponseFuture<$0.Occupant> createOccupant(
    $0.CreateOccupantRequest request, {
    $grpc.CallOptions? options,
  }) => $createUnaryCall(_$createOccupant, request, options: options);

  $grpc.ResponseFuture<$0.Occupant> updateOccupant(
    $0.UpdateOccupantRequest request, {
    $grpc.CallOptions? options,
  }) => $createUnaryCall(_$updateOccupant, request, options: options);

  $grpc.ResponseFuture<$1.Empty> deleteOccupant(
    $0.DeleteOccupantRequest request, {
    $grpc.CallOptions? options,
  }) => $createUnaryCall(_$deleteOccupant, request, options: options);

  $grpc.ResponseFuture<$0.Occupant> updatePresence(
    $0.UpdatePresenceRequest request, {
    $grpc.CallOptions? options,
  }) => $createUnaryCall(_$updatePresence, request, options: options);

  // method descriptors

  static final _$getOccupants =
      $grpc.ClientMethod<$0.GetOccupantsRequest, $0.ListOccupantsResponse>(
          '/breez.OccupantService/GetOccupants',
          ($0.GetOccupantsRequest value) => value.writeToBuffer(),
          $0.ListOccupantsResponse.fromBuffer,);
  static final _$createOccupant =
      $grpc.ClientMethod<$0.CreateOccupantRequest, $0.Occupant>(
          '/breez.OccupantService/CreateOccupant',
          ($0.CreateOccupantRequest value) => value.writeToBuffer(),
          $0.Occupant.fromBuffer,);
  static final _$updateOccupant =
      $grpc.ClientMethod<$0.UpdateOccupantRequest, $0.Occupant>(
          '/breez.OccupantService/UpdateOccupant',
          ($0.UpdateOccupantRequest value) => value.writeToBuffer(),
          $0.Occupant.fromBuffer,);
  static final _$deleteOccupant =
      $grpc.ClientMethod<$0.DeleteOccupantRequest, $1.Empty>(
          '/breez.OccupantService/DeleteOccupant',
          ($0.DeleteOccupantRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer,);
  static final _$updatePresence =
      $grpc.ClientMethod<$0.UpdatePresenceRequest, $0.Occupant>(
          '/breez.OccupantService/UpdatePresence',
          ($0.UpdatePresenceRequest value) => value.writeToBuffer(),
          $0.Occupant.fromBuffer,);
}

@$pb.GrpcServiceName('breez.OccupantService')
abstract class OccupantServiceBase extends $grpc.Service {

  OccupantServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetOccupantsRequest, $0.ListOccupantsResponse>(
            'GetOccupants',
            getOccupants_Pre,
            false,
            false,
            $0.GetOccupantsRequest.fromBuffer,
            ($0.ListOccupantsResponse value) => value.writeToBuffer(),),);
    $addMethod($grpc.ServiceMethod<$0.CreateOccupantRequest, $0.Occupant>(
        'CreateOccupant',
        createOccupant_Pre,
        false,
        false,
        $0.CreateOccupantRequest.fromBuffer,
        ($0.Occupant value) => value.writeToBuffer(),),);
    $addMethod($grpc.ServiceMethod<$0.UpdateOccupantRequest, $0.Occupant>(
        'UpdateOccupant',
        updateOccupant_Pre,
        false,
        false,
        $0.UpdateOccupantRequest.fromBuffer,
        ($0.Occupant value) => value.writeToBuffer(),),);
    $addMethod($grpc.ServiceMethod<$0.DeleteOccupantRequest, $1.Empty>(
        'DeleteOccupant',
        deleteOccupant_Pre,
        false,
        false,
        $0.DeleteOccupantRequest.fromBuffer,
        ($1.Empty value) => value.writeToBuffer(),),);
    $addMethod($grpc.ServiceMethod<$0.UpdatePresenceRequest, $0.Occupant>(
        'UpdatePresence',
        updatePresence_Pre,
        false,
        false,
        $0.UpdatePresenceRequest.fromBuffer,
        ($0.Occupant value) => value.writeToBuffer(),),);
  }
  $core.String get $name => 'breez.OccupantService';

  $async.Future<$0.ListOccupantsResponse> getOccupants_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetOccupantsRequest> $request,) async => getOccupants($call, await $request);

  $async.Future<$0.ListOccupantsResponse> getOccupants(
      $grpc.ServiceCall call, $0.GetOccupantsRequest request,);

  $async.Future<$0.Occupant> createOccupant_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateOccupantRequest> $request,) async => createOccupant($call, await $request);

  $async.Future<$0.Occupant> createOccupant(
      $grpc.ServiceCall call, $0.CreateOccupantRequest request,);

  $async.Future<$0.Occupant> updateOccupant_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateOccupantRequest> $request,) async => updateOccupant($call, await $request);

  $async.Future<$0.Occupant> updateOccupant(
      $grpc.ServiceCall call, $0.UpdateOccupantRequest request,);

  $async.Future<$1.Empty> deleteOccupant_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteOccupantRequest> $request,) async => deleteOccupant($call, await $request);

  $async.Future<$1.Empty> deleteOccupant(
      $grpc.ServiceCall call, $0.DeleteOccupantRequest request,);

  $async.Future<$0.Occupant> updatePresence_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdatePresenceRequest> $request,) async => updatePresence($call, await $request);

  $async.Future<$0.Occupant> updatePresence(
      $grpc.ServiceCall call, $0.UpdatePresenceRequest request,);
}
