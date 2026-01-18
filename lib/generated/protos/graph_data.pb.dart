// This is a generated file - do not edit.
//
// Generated from graph_data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references, do_not_use_environment, prefer_constructors_over_static_methods
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

/// Точка данных для графика
class GraphDataPoint extends $pb.GeneratedMessage {
  factory GraphDataPoint({
    $0.Timestamp? timestamp,
    $core.double? value,
  }) {
    final result = create();
    if (timestamp != null) {
      result.timestamp = timestamp;
    }
    if (value != null) {
      result.value = value;
    }
    return result;
  }

  GraphDataPoint._();

  factory GraphDataPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory GraphDataPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GraphDataPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $0.Timestamp.create,)
    ..aD(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphDataPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphDataPoint copyWith(void Function(GraphDataPoint) updates) =>
      super.copyWith((message) => updates(message as GraphDataPoint))
          as GraphDataPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GraphDataPoint create() => GraphDataPoint._();
  @$core.override
  GraphDataPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GraphDataPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GraphDataPoint>(create);
  static GraphDataPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get timestamp => $_getN(0);
  @$pb.TagNumber(1)
  set timestamp($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureTimestamp() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

/// Запрос данных для графика
class GraphDataRequest extends $pb.GeneratedMessage {
  factory GraphDataRequest({
    $core.String? deviceId,
    $1.GraphMetric? metric,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? resolution,
  }) {
    final result = create();
    if (deviceId != null) {
      result.deviceId = deviceId;
    }
    if (metric != null) {
      result.metric = metric;
    }
    if (from != null) {
      result.from = from;
    }
    if (to != null) {
      result.to = to;
    }
    if (resolution != null) {
      result.resolution = resolution;
    }
    return result;
  }

  GraphDataRequest._();

  factory GraphDataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory GraphDataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GraphDataRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aE<$1.GraphMetric>(2, _omitFieldNames ? '' : 'metric',
        enumValues: $1.GraphMetric.values,)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create,)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create,)
    ..aI(5, _omitFieldNames ? '' : 'resolution')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphDataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphDataRequest copyWith(void Function(GraphDataRequest) updates) =>
      super.copyWith((message) => updates(message as GraphDataRequest))
          as GraphDataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GraphDataRequest create() => GraphDataRequest._();
  @$core.override
  GraphDataRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GraphDataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GraphDataRequest>(create);
  static GraphDataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.GraphMetric get metric => $_getN(1);
  @$pb.TagNumber(2)
  set metric($1.GraphMetric value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetric() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetric() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get from => $_getN(2);
  @$pb.TagNumber(3)
  set from($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureFrom() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get to => $_getN(3);
  @$pb.TagNumber(4)
  set to($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearTo() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureTo() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get resolution => $_getIZ(4);
  @$pb.TagNumber(5)
  set resolution($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasResolution() => $_has(4);
  @$pb.TagNumber(5)
  void clearResolution() => $_clearField(5);
}

/// Ответ с данными для графика
class GraphDataResponse extends $pb.GeneratedMessage {
  factory GraphDataResponse({
    $core.Iterable<GraphDataPoint>? dataPoints,
    $1.GraphMetric? metric,
    GraphStats? stats,
  }) {
    final result = create();
    if (dataPoints != null) {
      result.dataPoints.addAll(dataPoints);
    }
    if (metric != null) {
      result.metric = metric;
    }
    if (stats != null) {
      result.stats = stats;
    }
    return result;
  }

  GraphDataResponse._();

  factory GraphDataResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory GraphDataResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GraphDataResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..pPM<GraphDataPoint>(1, _omitFieldNames ? '' : 'dataPoints',
        subBuilder: GraphDataPoint.create,)
    ..aE<$1.GraphMetric>(2, _omitFieldNames ? '' : 'metric',
        enumValues: $1.GraphMetric.values,)
    ..aOM<GraphStats>(3, _omitFieldNames ? '' : 'stats',
        subBuilder: GraphStats.create,)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphDataResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphDataResponse copyWith(void Function(GraphDataResponse) updates) =>
      super.copyWith((message) => updates(message as GraphDataResponse))
          as GraphDataResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GraphDataResponse create() => GraphDataResponse._();
  @$core.override
  GraphDataResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GraphDataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GraphDataResponse>(create);
  static GraphDataResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<GraphDataPoint> get dataPoints => $_getList(0);

  @$pb.TagNumber(2)
  $1.GraphMetric get metric => $_getN(1);
  @$pb.TagNumber(2)
  set metric($1.GraphMetric value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetric() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetric() => $_clearField(2);

  @$pb.TagNumber(3)
  GraphStats get stats => $_getN(2);
  @$pb.TagNumber(3)
  set stats(GraphStats value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStats() => $_has(2);
  @$pb.TagNumber(3)
  void clearStats() => $_clearField(3);
  @$pb.TagNumber(3)
  GraphStats ensureStats() => $_ensure(2);
}

/// Статистика по данным графика
class GraphStats extends $pb.GeneratedMessage {
  factory GraphStats({
    $core.double? min,
    $core.double? max,
    $core.double? avg,
    $core.double? current,
  }) {
    final result = create();
    if (min != null) {
      result.min = min;
    }
    if (max != null) {
      result.max = max;
    }
    if (avg != null) {
      result.avg = avg;
    }
    if (current != null) {
      result.current = current;
    }
    return result;
  }

  GraphStats._();

  factory GraphStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory GraphStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GraphStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aD(1, _omitFieldNames ? '' : 'min')
    ..aD(2, _omitFieldNames ? '' : 'max')
    ..aD(3, _omitFieldNames ? '' : 'avg')
    ..aD(4, _omitFieldNames ? '' : 'current')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphStats copyWith(void Function(GraphStats) updates) =>
      super.copyWith((message) => updates(message as GraphStats)) as GraphStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GraphStats create() => GraphStats._();
  @$core.override
  GraphStats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GraphStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GraphStats>(create);
  static GraphStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get min => $_getN(0);
  @$pb.TagNumber(1)
  set min($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get max => $_getN(1);
  @$pb.TagNumber(2)
  set max($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get avg => $_getN(2);
  @$pb.TagNumber(3)
  set avg($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvg() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get current => $_getN(3);
  @$pb.TagNumber(4)
  set current($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrent() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrent() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
