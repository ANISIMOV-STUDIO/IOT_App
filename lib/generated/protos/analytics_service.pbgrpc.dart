// This is a generated file - do not edit.
//
// Generated from analytics_service.proto.

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

import 'climate.pb.dart' as $2;
import 'energy.pb.dart' as $1;
import 'graph_data.pb.dart' as $0;

export 'analytics_service.pb.dart';

/// Сервис аналитики
@$pb.GrpcServiceName('breez.AnalyticsService')
class AnalyticsServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AnalyticsServiceClient(super.channel, {super.options, super.interceptors});

  /// Данные графиков
  $grpc.ResponseFuture<$0.GraphDataResponse> getGraphData(
    $0.GraphDataRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getGraphData, request, options: options);
  }

  /// Статистика энергопотребления
  $grpc.ResponseFuture<$1.EnergyStats> getEnergyStats(
    $1.GetEnergyStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getEnergyStats, request, options: options);
  }

  $grpc.ResponseFuture<$1.EnergyHistoryResponse> getEnergyHistory(
    $1.EnergyHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getEnergyHistory, request, options: options);
  }

  /// Климатические данные
  $grpc.ResponseFuture<$2.ClimateState> getClimateState(
    $2.GetClimateStateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getClimateState, request, options: options);
  }

  $grpc.ResponseFuture<$2.ClimateHistoryResponse> getClimateHistory(
    $2.ClimateHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getClimateHistory, request, options: options);
  }

  // method descriptors

  static final _$getGraphData =
      $grpc.ClientMethod<$0.GraphDataRequest, $0.GraphDataResponse>(
          '/breez.AnalyticsService/GetGraphData',
          ($0.GraphDataRequest value) => value.writeToBuffer(),
          $0.GraphDataResponse.fromBuffer);
  static final _$getEnergyStats =
      $grpc.ClientMethod<$1.GetEnergyStatsRequest, $1.EnergyStats>(
          '/breez.AnalyticsService/GetEnergyStats',
          ($1.GetEnergyStatsRequest value) => value.writeToBuffer(),
          $1.EnergyStats.fromBuffer);
  static final _$getEnergyHistory =
      $grpc.ClientMethod<$1.EnergyHistoryRequest, $1.EnergyHistoryResponse>(
          '/breez.AnalyticsService/GetEnergyHistory',
          ($1.EnergyHistoryRequest value) => value.writeToBuffer(),
          $1.EnergyHistoryResponse.fromBuffer);
  static final _$getClimateState =
      $grpc.ClientMethod<$2.GetClimateStateRequest, $2.ClimateState>(
          '/breez.AnalyticsService/GetClimateState',
          ($2.GetClimateStateRequest value) => value.writeToBuffer(),
          $2.ClimateState.fromBuffer);
  static final _$getClimateHistory =
      $grpc.ClientMethod<$2.ClimateHistoryRequest, $2.ClimateHistoryResponse>(
          '/breez.AnalyticsService/GetClimateHistory',
          ($2.ClimateHistoryRequest value) => value.writeToBuffer(),
          $2.ClimateHistoryResponse.fromBuffer);
}

@$pb.GrpcServiceName('breez.AnalyticsService')
abstract class AnalyticsServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.AnalyticsService';

  AnalyticsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GraphDataRequest, $0.GraphDataResponse>(
        'GetGraphData',
        getGraphData_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GraphDataRequest.fromBuffer(value),
        ($0.GraphDataResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.GetEnergyStatsRequest, $1.EnergyStats>(
        'GetEnergyStats',
        getEnergyStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.GetEnergyStatsRequest.fromBuffer(value),
        ($1.EnergyStats value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.EnergyHistoryRequest, $1.EnergyHistoryResponse>(
            'GetEnergyHistory',
            getEnergyHistory_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.EnergyHistoryRequest.fromBuffer(value),
            ($1.EnergyHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.GetClimateStateRequest, $2.ClimateState>(
        'GetClimateState',
        getClimateState_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $2.GetClimateStateRequest.fromBuffer(value),
        ($2.ClimateState value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.ClimateHistoryRequest,
            $2.ClimateHistoryResponse>(
        'GetClimateHistory',
        getClimateHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $2.ClimateHistoryRequest.fromBuffer(value),
        ($2.ClimateHistoryResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GraphDataResponse> getGraphData_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GraphDataRequest> $request) async {
    return getGraphData($call, await $request);
  }

  $async.Future<$0.GraphDataResponse> getGraphData(
      $grpc.ServiceCall call, $0.GraphDataRequest request);

  $async.Future<$1.EnergyStats> getEnergyStats_Pre($grpc.ServiceCall $call,
      $async.Future<$1.GetEnergyStatsRequest> $request) async {
    return getEnergyStats($call, await $request);
  }

  $async.Future<$1.EnergyStats> getEnergyStats(
      $grpc.ServiceCall call, $1.GetEnergyStatsRequest request);

  $async.Future<$1.EnergyHistoryResponse> getEnergyHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.EnergyHistoryRequest> $request) async {
    return getEnergyHistory($call, await $request);
  }

  $async.Future<$1.EnergyHistoryResponse> getEnergyHistory(
      $grpc.ServiceCall call, $1.EnergyHistoryRequest request);

  $async.Future<$2.ClimateState> getClimateState_Pre($grpc.ServiceCall $call,
      $async.Future<$2.GetClimateStateRequest> $request) async {
    return getClimateState($call, await $request);
  }

  $async.Future<$2.ClimateState> getClimateState(
      $grpc.ServiceCall call, $2.GetClimateStateRequest request);

  $async.Future<$2.ClimateHistoryResponse> getClimateHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$2.ClimateHistoryRequest> $request) async {
    return getClimateHistory($call, await $request);
  }

  $async.Future<$2.ClimateHistoryResponse> getClimateHistory(
      $grpc.ServiceCall call, $2.ClimateHistoryRequest request);
}
