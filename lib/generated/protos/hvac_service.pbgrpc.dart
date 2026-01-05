// This is a generated file - do not edit.
//
// Generated from hvac_service.proto.

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
import 'hvac_device.pb.dart' as $0;

export 'hvac_service.pb.dart';

/// Сервис управления HVAC устройствами
@$pb.GrpcServiceName('breez.HvacService')
class HvacServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  HvacServiceClient(super.channel, {super.options, super.interceptors});

  /// Управление устройствами
  $grpc.ResponseFuture<$0.HvacDevice> getDevice(
    $0.GetDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListDevicesResponse> listDevices(
    $1.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listDevices, request, options: options);
  }

  $grpc.ResponseFuture<$0.HvacDevice> createDevice(
    $0.CreateDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.HvacDevice> updateDevice(
    $0.UpdateDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateDevice, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteDevice(
    $0.DeleteDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteDevice, request, options: options);
  }

  /// Стриминг обновлений в реальном времени
  $grpc.ResponseStream<$0.HvacDevice> streamDeviceUpdates(
    $0.StreamDeviceUpdatesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$streamDeviceUpdates, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Управляющие операции
  $grpc.ResponseFuture<$0.HvacDevice> setPower(
    $0.SetPowerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setPower, request, options: options);
  }

  $grpc.ResponseFuture<$0.HvacDevice> setTemperature(
    $0.SetTemperatureRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setTemperature, request, options: options);
  }

  $grpc.ResponseFuture<$0.HvacDevice> setMode(
    $0.SetModeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setMode, request, options: options);
  }

  $grpc.ResponseFuture<$0.HvacDevice> setFanSpeed(
    $0.SetFanSpeedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setFanSpeed, request, options: options);
  }

  $grpc.ResponseFuture<$0.HvacDevice> applyPreset(
    $0.ApplyPresetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$applyPreset, request, options: options);
  }

  // method descriptors

  static final _$getDevice =
      $grpc.ClientMethod<$0.GetDeviceRequest, $0.HvacDevice>(
          '/breez.HvacService/GetDevice',
          ($0.GetDeviceRequest value) => value.writeToBuffer(),
          $0.HvacDevice.fromBuffer);
  static final _$listDevices =
      $grpc.ClientMethod<$1.Empty, $0.ListDevicesResponse>(
          '/breez.HvacService/ListDevices',
          ($1.Empty value) => value.writeToBuffer(),
          $0.ListDevicesResponse.fromBuffer);
  static final _$createDevice =
      $grpc.ClientMethod<$0.CreateDeviceRequest, $0.HvacDevice>(
          '/breez.HvacService/CreateDevice',
          ($0.CreateDeviceRequest value) => value.writeToBuffer(),
          $0.HvacDevice.fromBuffer);
  static final _$updateDevice =
      $grpc.ClientMethod<$0.UpdateDeviceRequest, $0.HvacDevice>(
          '/breez.HvacService/UpdateDevice',
          ($0.UpdateDeviceRequest value) => value.writeToBuffer(),
          $0.HvacDevice.fromBuffer);
  static final _$deleteDevice =
      $grpc.ClientMethod<$0.DeleteDeviceRequest, $1.Empty>(
          '/breez.HvacService/DeleteDevice',
          ($0.DeleteDeviceRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$streamDeviceUpdates =
      $grpc.ClientMethod<$0.StreamDeviceUpdatesRequest, $0.HvacDevice>(
          '/breez.HvacService/StreamDeviceUpdates',
          ($0.StreamDeviceUpdatesRequest value) => value.writeToBuffer(),
          $0.HvacDevice.fromBuffer);
  static final _$setPower =
      $grpc.ClientMethod<$0.SetPowerRequest, $0.HvacDevice>(
          '/breez.HvacService/SetPower',
          ($0.SetPowerRequest value) => value.writeToBuffer(),
          $0.HvacDevice.fromBuffer);
  static final _$setTemperature =
      $grpc.ClientMethod<$0.SetTemperatureRequest, $0.HvacDevice>(
          '/breez.HvacService/SetTemperature',
          ($0.SetTemperatureRequest value) => value.writeToBuffer(),
          $0.HvacDevice.fromBuffer);
  static final _$setMode = $grpc.ClientMethod<$0.SetModeRequest, $0.HvacDevice>(
      '/breez.HvacService/SetMode',
      ($0.SetModeRequest value) => value.writeToBuffer(),
      $0.HvacDevice.fromBuffer);
  static final _$setFanSpeed =
      $grpc.ClientMethod<$0.SetFanSpeedRequest, $0.HvacDevice>(
          '/breez.HvacService/SetFanSpeed',
          ($0.SetFanSpeedRequest value) => value.writeToBuffer(),
          $0.HvacDevice.fromBuffer);
  static final _$applyPreset =
      $grpc.ClientMethod<$0.ApplyPresetRequest, $0.HvacDevice>(
          '/breez.HvacService/ApplyPreset',
          ($0.ApplyPresetRequest value) => value.writeToBuffer(),
          $0.HvacDevice.fromBuffer);
}

@$pb.GrpcServiceName('breez.HvacService')
abstract class HvacServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.HvacService';

  HvacServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetDeviceRequest, $0.HvacDevice>(
        'GetDevice',
        getDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetDeviceRequest.fromBuffer(value),
        ($0.HvacDevice value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $0.ListDevicesResponse>(
        'ListDevices',
        listDevices_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($0.ListDevicesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateDeviceRequest, $0.HvacDevice>(
        'CreateDevice',
        createDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateDeviceRequest.fromBuffer(value),
        ($0.HvacDevice value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateDeviceRequest, $0.HvacDevice>(
        'UpdateDevice',
        updateDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateDeviceRequest.fromBuffer(value),
        ($0.HvacDevice value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteDeviceRequest, $1.Empty>(
        'DeleteDevice',
        deleteDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteDeviceRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.StreamDeviceUpdatesRequest, $0.HvacDevice>(
            'StreamDeviceUpdates',
            streamDeviceUpdates_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.StreamDeviceUpdatesRequest.fromBuffer(value),
            ($0.HvacDevice value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetPowerRequest, $0.HvacDevice>(
        'SetPower',
        setPower_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SetPowerRequest.fromBuffer(value),
        ($0.HvacDevice value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetTemperatureRequest, $0.HvacDevice>(
        'SetTemperature',
        setTemperature_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetTemperatureRequest.fromBuffer(value),
        ($0.HvacDevice value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetModeRequest, $0.HvacDevice>(
        'SetMode',
        setMode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SetModeRequest.fromBuffer(value),
        ($0.HvacDevice value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetFanSpeedRequest, $0.HvacDevice>(
        'SetFanSpeed',
        setFanSpeed_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetFanSpeedRequest.fromBuffer(value),
        ($0.HvacDevice value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApplyPresetRequest, $0.HvacDevice>(
        'ApplyPreset',
        applyPreset_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ApplyPresetRequest.fromBuffer(value),
        ($0.HvacDevice value) => value.writeToBuffer()));
  }

  $async.Future<$0.HvacDevice> getDevice_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetDeviceRequest> $request) async {
    return getDevice($call, await $request);
  }

  $async.Future<$0.HvacDevice> getDevice(
      $grpc.ServiceCall call, $0.GetDeviceRequest request);

  $async.Future<$0.ListDevicesResponse> listDevices_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.Empty> $request) async {
    return listDevices($call, await $request);
  }

  $async.Future<$0.ListDevicesResponse> listDevices(
      $grpc.ServiceCall call, $1.Empty request);

  $async.Future<$0.HvacDevice> createDevice_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateDeviceRequest> $request) async {
    return createDevice($call, await $request);
  }

  $async.Future<$0.HvacDevice> createDevice(
      $grpc.ServiceCall call, $0.CreateDeviceRequest request);

  $async.Future<$0.HvacDevice> updateDevice_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateDeviceRequest> $request) async {
    return updateDevice($call, await $request);
  }

  $async.Future<$0.HvacDevice> updateDevice(
      $grpc.ServiceCall call, $0.UpdateDeviceRequest request);

  $async.Future<$1.Empty> deleteDevice_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteDeviceRequest> $request) async {
    return deleteDevice($call, await $request);
  }

  $async.Future<$1.Empty> deleteDevice(
      $grpc.ServiceCall call, $0.DeleteDeviceRequest request);

  $async.Stream<$0.HvacDevice> streamDeviceUpdates_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StreamDeviceUpdatesRequest> $request) async* {
    yield* streamDeviceUpdates($call, await $request);
  }

  $async.Stream<$0.HvacDevice> streamDeviceUpdates(
      $grpc.ServiceCall call, $0.StreamDeviceUpdatesRequest request);

  $async.Future<$0.HvacDevice> setPower_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetPowerRequest> $request) async {
    return setPower($call, await $request);
  }

  $async.Future<$0.HvacDevice> setPower(
      $grpc.ServiceCall call, $0.SetPowerRequest request);

  $async.Future<$0.HvacDevice> setTemperature_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetTemperatureRequest> $request) async {
    return setTemperature($call, await $request);
  }

  $async.Future<$0.HvacDevice> setTemperature(
      $grpc.ServiceCall call, $0.SetTemperatureRequest request);

  $async.Future<$0.HvacDevice> setMode_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetModeRequest> $request) async {
    return setMode($call, await $request);
  }

  $async.Future<$0.HvacDevice> setMode(
      $grpc.ServiceCall call, $0.SetModeRequest request);

  $async.Future<$0.HvacDevice> setFanSpeed_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetFanSpeedRequest> $request) async {
    return setFanSpeed($call, await $request);
  }

  $async.Future<$0.HvacDevice> setFanSpeed(
      $grpc.ServiceCall call, $0.SetFanSpeedRequest request);

  $async.Future<$0.HvacDevice> applyPreset_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ApplyPresetRequest> $request) async {
    return applyPreset($call, await $request);
  }

  $async.Future<$0.HvacDevice> applyPreset(
      $grpc.ServiceCall call, $0.ApplyPresetRequest request);
}
