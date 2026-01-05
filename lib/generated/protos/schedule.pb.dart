// This is a generated file - do not edit.
//
// Generated from schedule.proto.

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

import 'common.pbenum.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Запись расписания
class ScheduleEntry extends $pb.GeneratedMessage {
  factory ScheduleEntry({
    $core.String? id,
    $core.String? deviceId,
    $core.String? time,
    $core.Iterable<$core.int>? days,
    ScheduleAction? action,
    $core.bool? enabled,
    $0.Timestamp? createdAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (deviceId != null) result.deviceId = deviceId;
    if (time != null) result.time = time;
    if (days != null) result.days.addAll(days);
    if (action != null) result.action = action;
    if (enabled != null) result.enabled = enabled;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ScheduleEntry._();

  factory ScheduleEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'deviceId')
    ..aOS(3, _omitFieldNames ? '' : 'time')
    ..p<$core.int>(4, _omitFieldNames ? '' : 'days', $pb.PbFieldType.K3)
    ..aOM<ScheduleAction>(5, _omitFieldNames ? '' : 'action',
        subBuilder: ScheduleAction.create)
    ..aOB(6, _omitFieldNames ? '' : 'enabled')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleEntry copyWith(void Function(ScheduleEntry) updates) =>
      super.copyWith((message) => updates(message as ScheduleEntry))
          as ScheduleEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleEntry create() => ScheduleEntry._();
  @$core.override
  ScheduleEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleEntry>(create);
  static ScheduleEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get time => $_getSZ(2);
  @$pb.TagNumber(3)
  set time($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.int> get days => $_getList(3);

  @$pb.TagNumber(5)
  ScheduleAction get action => $_getN(4);
  @$pb.TagNumber(5)
  set action(ScheduleAction value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAction() => $_has(4);
  @$pb.TagNumber(5)
  void clearAction() => $_clearField(5);
  @$pb.TagNumber(5)
  ScheduleAction ensureAction() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get enabled => $_getBF(5);
  @$pb.TagNumber(6)
  set enabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearEnabled() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get createdAt => $_getN(6);
  @$pb.TagNumber(7)
  set createdAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCreatedAt() => $_ensure(6);
}

/// Действие расписания
class ScheduleAction extends $pb.GeneratedMessage {
  factory ScheduleAction({
    $core.bool? power,
    $core.int? temp,
    $1.OperationMode? mode,
    $1.FanSpeed? supplyFan,
    $1.FanSpeed? exhaustFan,
    $core.String? presetId,
  }) {
    final result = create();
    if (power != null) result.power = power;
    if (temp != null) result.temp = temp;
    if (mode != null) result.mode = mode;
    if (supplyFan != null) result.supplyFan = supplyFan;
    if (exhaustFan != null) result.exhaustFan = exhaustFan;
    if (presetId != null) result.presetId = presetId;
    return result;
  }

  ScheduleAction._();

  factory ScheduleAction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleAction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleAction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'power')
    ..aI(2, _omitFieldNames ? '' : 'temp')
    ..aE<$1.OperationMode>(3, _omitFieldNames ? '' : 'mode',
        enumValues: $1.OperationMode.values)
    ..aE<$1.FanSpeed>(4, _omitFieldNames ? '' : 'supplyFan',
        enumValues: $1.FanSpeed.values)
    ..aE<$1.FanSpeed>(5, _omitFieldNames ? '' : 'exhaustFan',
        enumValues: $1.FanSpeed.values)
    ..aOS(6, _omitFieldNames ? '' : 'presetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleAction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleAction copyWith(void Function(ScheduleAction) updates) =>
      super.copyWith((message) => updates(message as ScheduleAction))
          as ScheduleAction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleAction create() => ScheduleAction._();
  @$core.override
  ScheduleAction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleAction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleAction>(create);
  static ScheduleAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get power => $_getBF(0);
  @$pb.TagNumber(1)
  set power($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPower() => $_has(0);
  @$pb.TagNumber(1)
  void clearPower() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get temp => $_getIZ(1);
  @$pb.TagNumber(2)
  set temp($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTemp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTemp() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.OperationMode get mode => $_getN(2);
  @$pb.TagNumber(3)
  set mode($1.OperationMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.FanSpeed get supplyFan => $_getN(3);
  @$pb.TagNumber(4)
  set supplyFan($1.FanSpeed value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSupplyFan() => $_has(3);
  @$pb.TagNumber(4)
  void clearSupplyFan() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.FanSpeed get exhaustFan => $_getN(4);
  @$pb.TagNumber(5)
  set exhaustFan($1.FanSpeed value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExhaustFan() => $_has(4);
  @$pb.TagNumber(5)
  void clearExhaustFan() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get presetId => $_getSZ(5);
  @$pb.TagNumber(6)
  set presetId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPresetId() => $_has(5);
  @$pb.TagNumber(6)
  void clearPresetId() => $_clearField(6);
}

/// Запрос на получение расписания
class GetScheduleRequest extends $pb.GeneratedMessage {
  factory GetScheduleRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  GetScheduleRequest._();

  factory GetScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetScheduleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetScheduleRequest copyWith(void Function(GetScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as GetScheduleRequest))
          as GetScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetScheduleRequest create() => GetScheduleRequest._();
  @$core.override
  GetScheduleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetScheduleRequest>(create);
  static GetScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

/// Ответ со списком расписаний
class ListScheduleResponse extends $pb.GeneratedMessage {
  factory ListScheduleResponse({
    $core.Iterable<ScheduleEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  ListScheduleResponse._();

  factory ListScheduleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListScheduleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListScheduleResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..pPM<ScheduleEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: ScheduleEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScheduleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScheduleResponse copyWith(void Function(ListScheduleResponse) updates) =>
      super.copyWith((message) => updates(message as ListScheduleResponse))
          as ListScheduleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListScheduleResponse create() => ListScheduleResponse._();
  @$core.override
  ListScheduleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListScheduleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListScheduleResponse>(create);
  static ListScheduleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ScheduleEntry> get entries => $_getList(0);
}

/// Запрос на создание записи расписания
class CreateScheduleRequest extends $pb.GeneratedMessage {
  factory CreateScheduleRequest({
    $core.String? deviceId,
    $core.String? time,
    $core.Iterable<$core.int>? days,
    ScheduleAction? action,
    $core.bool? enabled,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (time != null) result.time = time;
    if (days != null) result.days.addAll(days);
    if (action != null) result.action = action;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  CreateScheduleRequest._();

  factory CreateScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateScheduleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'time')
    ..p<$core.int>(3, _omitFieldNames ? '' : 'days', $pb.PbFieldType.K3)
    ..aOM<ScheduleAction>(4, _omitFieldNames ? '' : 'action',
        subBuilder: ScheduleAction.create)
    ..aOB(5, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateScheduleRequest copyWith(
          void Function(CreateScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as CreateScheduleRequest))
          as CreateScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateScheduleRequest create() => CreateScheduleRequest._();
  @$core.override
  CreateScheduleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateScheduleRequest>(create);
  static CreateScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get time => $_getSZ(1);
  @$pb.TagNumber(2)
  set time($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get days => $_getList(2);

  @$pb.TagNumber(4)
  ScheduleAction get action => $_getN(3);
  @$pb.TagNumber(4)
  set action(ScheduleAction value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);
  @$pb.TagNumber(4)
  ScheduleAction ensureAction() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get enabled => $_getBF(4);
  @$pb.TagNumber(5)
  set enabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnabled() => $_clearField(5);
}

/// Запрос на обновление записи расписания
class UpdateScheduleRequest extends $pb.GeneratedMessage {
  factory UpdateScheduleRequest({
    $core.String? id,
    $core.String? time,
    $core.Iterable<$core.int>? days,
    ScheduleAction? action,
    $core.bool? enabled,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (time != null) result.time = time;
    if (days != null) result.days.addAll(days);
    if (action != null) result.action = action;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  UpdateScheduleRequest._();

  factory UpdateScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateScheduleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'time')
    ..p<$core.int>(3, _omitFieldNames ? '' : 'days', $pb.PbFieldType.K3)
    ..aOM<ScheduleAction>(4, _omitFieldNames ? '' : 'action',
        subBuilder: ScheduleAction.create)
    ..aOB(5, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateScheduleRequest copyWith(
          void Function(UpdateScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateScheduleRequest))
          as UpdateScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateScheduleRequest create() => UpdateScheduleRequest._();
  @$core.override
  UpdateScheduleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateScheduleRequest>(create);
  static UpdateScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get time => $_getSZ(1);
  @$pb.TagNumber(2)
  set time($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get days => $_getList(2);

  @$pb.TagNumber(4)
  ScheduleAction get action => $_getN(3);
  @$pb.TagNumber(4)
  set action(ScheduleAction value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);
  @$pb.TagNumber(4)
  ScheduleAction ensureAction() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get enabled => $_getBF(4);
  @$pb.TagNumber(5)
  set enabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnabled() => $_clearField(5);
}

/// Запрос на удаление записи расписания
class DeleteScheduleRequest extends $pb.GeneratedMessage {
  factory DeleteScheduleRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  DeleteScheduleRequest._();

  factory DeleteScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteScheduleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteScheduleRequest copyWith(
          void Function(DeleteScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteScheduleRequest))
          as DeleteScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteScheduleRequest create() => DeleteScheduleRequest._();
  @$core.override
  DeleteScheduleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteScheduleRequest>(create);
  static DeleteScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
