// This is a generated file - do not edit.
//
// Generated from climate.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references, prefer_constructors_over_static_methods, do_not_use_environment
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:hvac_control/generated/protos/common.pbenum.dart' as $1;
import 'package:hvac_control/generated/protos/google/protobuf/timestamp.pb.dart'
    as $0;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Климатическое состояние
class ClimateState extends $pb.GeneratedMessage {
  factory ClimateState({
    $core.String? deviceId,
    $core.int? indoorTemp,
    $core.int? outdoorTemp,
    $core.int? humidity,
    $core.int? co2,
    $1.AirQuality? airQuality,
    $0.Timestamp? timestamp,
    $core.int? outdoorHumidity,
    $core.double? pressure,
    $core.int? pm25,
    $core.int? pm10,
  }) {
    final result = create();
    if (deviceId != null) {
      result.deviceId = deviceId;
    }
    if (indoorTemp != null) {
      result.indoorTemp = indoorTemp;
    }
    if (outdoorTemp != null) {
      result.outdoorTemp = outdoorTemp;
    }
    if (humidity != null) {
      result.humidity = humidity;
    }
    if (co2 != null) {
      result.co2 = co2;
    }
    if (airQuality != null) {
      result.airQuality = airQuality;
    }
    if (timestamp != null) {
      result.timestamp = timestamp;
    }
    if (outdoorHumidity != null) {
      result.outdoorHumidity = outdoorHumidity;
    }
    if (pressure != null) {
      result.pressure = pressure;
    }
    if (pm25 != null) {
      result.pm25 = pm25;
    }
    if (pm10 != null) {
      result.pm10 = pm10;
    }
    return result;
  }

  ClimateState._();

  factory ClimateState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClimateState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClimateState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aI(2, _omitFieldNames ? '' : 'indoorTemp')
    ..aI(3, _omitFieldNames ? '' : 'outdoorTemp')
    ..aI(4, _omitFieldNames ? '' : 'humidity')
    ..aI(5, _omitFieldNames ? '' : 'co2')
    ..aE<$1.AirQuality>(6, _omitFieldNames ? '' : 'airQuality',
        enumValues: $1.AirQuality.values,)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $0.Timestamp.create,)
    ..aI(8, _omitFieldNames ? '' : 'outdoorHumidity')
    ..aD(9, _omitFieldNames ? '' : 'pressure')
    ..aI(10, _omitFieldNames ? '' : 'pm25')
    ..aI(11, _omitFieldNames ? '' : 'pm10')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClimateState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClimateState copyWith(void Function(ClimateState) updates) =>
      super.copyWith((message) => updates(message as ClimateState))
          as ClimateState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClimateState create() => ClimateState._();
  @$core.override
  ClimateState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClimateState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClimateState>(create);
  static ClimateState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get indoorTemp => $_getIZ(1);
  @$pb.TagNumber(2)
  set indoorTemp($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndoorTemp() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndoorTemp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get outdoorTemp => $_getIZ(2);
  @$pb.TagNumber(3)
  set outdoorTemp($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOutdoorTemp() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutdoorTemp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get humidity => $_getIZ(3);
  @$pb.TagNumber(4)
  set humidity($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHumidity() => $_has(3);
  @$pb.TagNumber(4)
  void clearHumidity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get co2 => $_getIZ(4);
  @$pb.TagNumber(5)
  set co2($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCo2() => $_has(4);
  @$pb.TagNumber(5)
  void clearCo2() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.AirQuality get airQuality => $_getN(5);
  @$pb.TagNumber(6)
  set airQuality($1.AirQuality value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAirQuality() => $_has(5);
  @$pb.TagNumber(6)
  void clearAirQuality() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get timestamp => $_getN(6);
  @$pb.TagNumber(7)
  set timestamp($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTimestamp() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimestamp() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureTimestamp() => $_ensure(6);

  /// Дополнительные климатические данные
  @$pb.TagNumber(8)
  $core.int get outdoorHumidity => $_getIZ(7);
  @$pb.TagNumber(8)
  set outdoorHumidity($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOutdoorHumidity() => $_has(7);
  @$pb.TagNumber(8)
  void clearOutdoorHumidity() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get pressure => $_getN(8);
  @$pb.TagNumber(9)
  set pressure($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPressure() => $_has(8);
  @$pb.TagNumber(9)
  void clearPressure() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get pm25 => $_getIZ(9);
  @$pb.TagNumber(10)
  set pm25($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPm25() => $_has(9);
  @$pb.TagNumber(10)
  void clearPm25() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get pm10 => $_getIZ(10);
  @$pb.TagNumber(11)
  set pm10($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPm10() => $_has(10);
  @$pb.TagNumber(11)
  void clearPm10() => $_clearField(11);
}

/// Запрос на получение климатического состояния
class GetClimateStateRequest extends $pb.GeneratedMessage {
  factory GetClimateStateRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) {
      result.deviceId = deviceId;
    }
    return result;
  }

  GetClimateStateRequest._();

  factory GetClimateStateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetClimateStateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetClimateStateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClimateStateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClimateStateRequest copyWith(
          void Function(GetClimateStateRequest) updates,) =>
      super.copyWith((message) => updates(message as GetClimateStateRequest))
          as GetClimateStateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetClimateStateRequest create() => GetClimateStateRequest._();
  @$core.override
  GetClimateStateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetClimateStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetClimateStateRequest>(create);
  static GetClimateStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

/// Запрос истории климата
class ClimateHistoryRequest extends $pb.GeneratedMessage {
  factory ClimateHistoryRequest({
    $core.String? deviceId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (deviceId != null) {
      result.deviceId = deviceId;
    }
    if (from != null) {
      result.from = from;
    }
    if (to != null) {
      result.to = to;
    }
    return result;
  }

  ClimateHistoryRequest._();

  factory ClimateHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClimateHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClimateHistoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create,)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create,)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClimateHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClimateHistoryRequest copyWith(
          void Function(ClimateHistoryRequest) updates,) =>
      super.copyWith((message) => updates(message as ClimateHistoryRequest))
          as ClimateHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClimateHistoryRequest create() => ClimateHistoryRequest._();
  @$core.override
  ClimateHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClimateHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClimateHistoryRequest>(create);
  static ClimateHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get from => $_getN(1);
  @$pb.TagNumber(2)
  set from($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureFrom() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get to => $_getN(2);
  @$pb.TagNumber(3)
  set to($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTo() => $_ensure(2);
}

/// Ответ с историей климата
class ClimateHistoryResponse extends $pb.GeneratedMessage {
  factory ClimateHistoryResponse({
    $core.Iterable<ClimateState>? history,
  }) {
    final result = create();
    if (history != null) {
      result.history.addAll(history);
    }
    return result;
  }

  ClimateHistoryResponse._();

  factory ClimateHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClimateHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClimateHistoryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..pPM<ClimateState>(1, _omitFieldNames ? '' : 'history',
        subBuilder: ClimateState.create,)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClimateHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClimateHistoryResponse copyWith(
          void Function(ClimateHistoryResponse) updates,) =>
      super.copyWith((message) => updates(message as ClimateHistoryResponse))
          as ClimateHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClimateHistoryResponse create() => ClimateHistoryResponse._();
  @$core.override
  ClimateHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClimateHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClimateHistoryResponse>(create);
  static ClimateHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ClimateState> get history => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
