// This is a generated file - do not edit.
//
// Generated from energy.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'google/protobuf/timestamp.pb.dart'
    as $0;

import 'energy.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'energy.pbenum.dart';

/// Статистика энергопотребления
class EnergyStats extends $pb.GeneratedMessage {
  factory EnergyStats({
    $core.String? deviceId,
    $core.double? currentConsumption,
    $core.double? dailyConsumption,
    $core.double? weeklyConsumption,
    $core.double? monthlyConsumption,
    $core.double? costPerHour,
    $core.double? dailyCost,
    $core.double? monthlyCost,
    $0.Timestamp? lastUpdate,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (currentConsumption != null)
      result.currentConsumption = currentConsumption;
    if (dailyConsumption != null) result.dailyConsumption = dailyConsumption;
    if (weeklyConsumption != null) result.weeklyConsumption = weeklyConsumption;
    if (monthlyConsumption != null)
      result.monthlyConsumption = monthlyConsumption;
    if (costPerHour != null) result.costPerHour = costPerHour;
    if (dailyCost != null) result.dailyCost = dailyCost;
    if (monthlyCost != null) result.monthlyCost = monthlyCost;
    if (lastUpdate != null) result.lastUpdate = lastUpdate;
    return result;
  }

  EnergyStats._();

  factory EnergyStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnergyStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnergyStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aD(2, _omitFieldNames ? '' : 'currentConsumption')
    ..aD(3, _omitFieldNames ? '' : 'dailyConsumption')
    ..aD(4, _omitFieldNames ? '' : 'weeklyConsumption')
    ..aD(5, _omitFieldNames ? '' : 'monthlyConsumption')
    ..aD(6, _omitFieldNames ? '' : 'costPerHour')
    ..aD(7, _omitFieldNames ? '' : 'dailyCost')
    ..aD(8, _omitFieldNames ? '' : 'monthlyCost')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'lastUpdate',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnergyStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnergyStats copyWith(void Function(EnergyStats) updates) =>
      super.copyWith((message) => updates(message as EnergyStats))
          as EnergyStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnergyStats create() => EnergyStats._();
  @$core.override
  EnergyStats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnergyStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnergyStats>(create);
  static EnergyStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get currentConsumption => $_getN(1);
  @$pb.TagNumber(2)
  set currentConsumption($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentConsumption() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentConsumption() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get dailyConsumption => $_getN(2);
  @$pb.TagNumber(3)
  set dailyConsumption($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDailyConsumption() => $_has(2);
  @$pb.TagNumber(3)
  void clearDailyConsumption() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get weeklyConsumption => $_getN(3);
  @$pb.TagNumber(4)
  set weeklyConsumption($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWeeklyConsumption() => $_has(3);
  @$pb.TagNumber(4)
  void clearWeeklyConsumption() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get monthlyConsumption => $_getN(4);
  @$pb.TagNumber(5)
  set monthlyConsumption($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMonthlyConsumption() => $_has(4);
  @$pb.TagNumber(5)
  void clearMonthlyConsumption() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get costPerHour => $_getN(5);
  @$pb.TagNumber(6)
  set costPerHour($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCostPerHour() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostPerHour() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get dailyCost => $_getN(6);
  @$pb.TagNumber(7)
  set dailyCost($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDailyCost() => $_has(6);
  @$pb.TagNumber(7)
  void clearDailyCost() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get monthlyCost => $_getN(7);
  @$pb.TagNumber(8)
  set monthlyCost($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMonthlyCost() => $_has(7);
  @$pb.TagNumber(8)
  void clearMonthlyCost() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get lastUpdate => $_getN(8);
  @$pb.TagNumber(9)
  set lastUpdate($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLastUpdate() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastUpdate() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureLastUpdate() => $_ensure(8);
}

/// Запрос на получение статистики энергопотребления
class GetEnergyStatsRequest extends $pb.GeneratedMessage {
  factory GetEnergyStatsRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  GetEnergyStatsRequest._();

  factory GetEnergyStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEnergyStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEnergyStatsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEnergyStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEnergyStatsRequest copyWith(
          void Function(GetEnergyStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetEnergyStatsRequest))
          as GetEnergyStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEnergyStatsRequest create() => GetEnergyStatsRequest._();
  @$core.override
  GetEnergyStatsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEnergyStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEnergyStatsRequest>(create);
  static GetEnergyStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

/// Запрос истории энергопотребления
class EnergyHistoryRequest extends $pb.GeneratedMessage {
  factory EnergyHistoryRequest({
    $core.String? deviceId,
    $0.Timestamp? from,
    $0.Timestamp? to,
    EnergyPeriod? period,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (period != null) result.period = period;
    return result;
  }

  EnergyHistoryRequest._();

  factory EnergyHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnergyHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnergyHistoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aE<EnergyPeriod>(4, _omitFieldNames ? '' : 'period',
        enumValues: EnergyPeriod.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnergyHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnergyHistoryRequest copyWith(void Function(EnergyHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as EnergyHistoryRequest))
          as EnergyHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnergyHistoryRequest create() => EnergyHistoryRequest._();
  @$core.override
  EnergyHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnergyHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnergyHistoryRequest>(create);
  static EnergyHistoryRequest? _defaultInstance;

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

  @$pb.TagNumber(4)
  EnergyPeriod get period => $_getN(3);
  @$pb.TagNumber(4)
  set period(EnergyPeriod value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriod() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriod() => $_clearField(4);
}

/// Ответ с историей энергопотребления
class EnergyHistoryResponse extends $pb.GeneratedMessage {
  factory EnergyHistoryResponse({
    $core.Iterable<EnergyDataPoint>? dataPoints,
    $core.double? totalConsumption,
    $core.double? totalCost,
  }) {
    final result = create();
    if (dataPoints != null) result.dataPoints.addAll(dataPoints);
    if (totalConsumption != null) result.totalConsumption = totalConsumption;
    if (totalCost != null) result.totalCost = totalCost;
    return result;
  }

  EnergyHistoryResponse._();

  factory EnergyHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnergyHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnergyHistoryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..pPM<EnergyDataPoint>(1, _omitFieldNames ? '' : 'dataPoints',
        subBuilder: EnergyDataPoint.create)
    ..aD(2, _omitFieldNames ? '' : 'totalConsumption')
    ..aD(3, _omitFieldNames ? '' : 'totalCost')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnergyHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnergyHistoryResponse copyWith(
          void Function(EnergyHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as EnergyHistoryResponse))
          as EnergyHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnergyHistoryResponse create() => EnergyHistoryResponse._();
  @$core.override
  EnergyHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnergyHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnergyHistoryResponse>(create);
  static EnergyHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<EnergyDataPoint> get dataPoints => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get totalConsumption => $_getN(1);
  @$pb.TagNumber(2)
  set totalConsumption($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalConsumption() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalConsumption() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalCost => $_getN(2);
  @$pb.TagNumber(3)
  set totalCost($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCost() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCost() => $_clearField(3);
}

/// Точка данных энергопотребления
class EnergyDataPoint extends $pb.GeneratedMessage {
  factory EnergyDataPoint({
    $0.Timestamp? timestamp,
    $core.double? consumption,
    $core.double? cost,
  }) {
    final result = create();
    if (timestamp != null) result.timestamp = timestamp;
    if (consumption != null) result.consumption = consumption;
    if (cost != null) result.cost = cost;
    return result;
  }

  EnergyDataPoint._();

  factory EnergyDataPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnergyDataPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnergyDataPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $0.Timestamp.create)
    ..aD(2, _omitFieldNames ? '' : 'consumption')
    ..aD(3, _omitFieldNames ? '' : 'cost')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnergyDataPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnergyDataPoint copyWith(void Function(EnergyDataPoint) updates) =>
      super.copyWith((message) => updates(message as EnergyDataPoint))
          as EnergyDataPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnergyDataPoint create() => EnergyDataPoint._();
  @$core.override
  EnergyDataPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnergyDataPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnergyDataPoint>(create);
  static EnergyDataPoint? _defaultInstance;

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
  $core.double get consumption => $_getN(1);
  @$pb.TagNumber(2)
  set consumption($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConsumption() => $_has(1);
  @$pb.TagNumber(2)
  void clearConsumption() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get cost => $_getN(2);
  @$pb.TagNumber(3)
  set cost($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCost() => $_has(2);
  @$pb.TagNumber(3)
  void clearCost() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
