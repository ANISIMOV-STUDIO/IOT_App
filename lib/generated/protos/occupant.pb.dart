// This is a generated file - do not edit.
//
// Generated from occupant.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references, prefer_constructors_over_static_methods, do_not_use_environment
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:hvac_control/generated/protos/google/protobuf/timestamp.pb.dart'
    as $0;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Жилец/пользователь
class Occupant extends $pb.GeneratedMessage {
  factory Occupant({
    $core.String? id,
    $core.String? name,
    $core.String? avatarUrl,
    $core.bool? isHome,
    $0.Timestamp? lastSeen,
    $core.Iterable<$core.String>? deviceIds,
  }) {
    final result = create();
    if (id != null) {
      result.id = id;
    }
    if (name != null) {
      result.name = name;
    }
    if (avatarUrl != null) {
      result.avatarUrl = avatarUrl;
    }
    if (isHome != null) {
      result.isHome = isHome;
    }
    if (lastSeen != null) {
      result.lastSeen = lastSeen;
    }
    if (deviceIds != null) {
      result.deviceIds.addAll(deviceIds);
    }
    return result;
  }

  Occupant._();

  factory Occupant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory Occupant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Occupant',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'avatarUrl')
    ..aOB(4, _omitFieldNames ? '' : 'isHome')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'lastSeen',
        subBuilder: $0.Timestamp.create,)
    ..pPS(6, _omitFieldNames ? '' : 'deviceIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Occupant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Occupant copyWith(void Function(Occupant) updates) =>
      super.copyWith((message) => updates(message as Occupant)) as Occupant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Occupant create() => Occupant._();
  @$core.override
  Occupant createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Occupant getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Occupant>(create);
  static Occupant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get avatarUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatarUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatarUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatarUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isHome => $_getBF(3);
  @$pb.TagNumber(4)
  set isHome($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsHome() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsHome() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get lastSeen => $_getN(4);
  @$pb.TagNumber(5)
  set lastSeen($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLastSeen() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastSeen() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureLastSeen() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get deviceIds => $_getList(5);
}

/// Запрос на получение списка жильцов
class GetOccupantsRequest extends $pb.GeneratedMessage {
  factory GetOccupantsRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) {
      result.deviceId = deviceId;
    }
    return result;
  }

  GetOccupantsRequest._();

  factory GetOccupantsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOccupantsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOccupantsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOccupantsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOccupantsRequest copyWith(void Function(GetOccupantsRequest) updates) =>
      super.copyWith((message) => updates(message as GetOccupantsRequest))
          as GetOccupantsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOccupantsRequest create() => GetOccupantsRequest._();
  @$core.override
  GetOccupantsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOccupantsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOccupantsRequest>(create);
  static GetOccupantsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

/// Ответ со списком жильцов
class ListOccupantsResponse extends $pb.GeneratedMessage {
  factory ListOccupantsResponse({
    $core.Iterable<Occupant>? occupants,
    $core.int? homeCount,
  }) {
    final result = create();
    if (occupants != null) {
      result.occupants.addAll(occupants);
    }
    if (homeCount != null) {
      result.homeCount = homeCount;
    }
    return result;
  }

  ListOccupantsResponse._();

  factory ListOccupantsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOccupantsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOccupantsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..pPM<Occupant>(1, _omitFieldNames ? '' : 'occupants',
        subBuilder: Occupant.create,)
    ..aI(2, _omitFieldNames ? '' : 'homeCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOccupantsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOccupantsResponse copyWith(
          void Function(ListOccupantsResponse) updates,) =>
      super.copyWith((message) => updates(message as ListOccupantsResponse))
          as ListOccupantsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOccupantsResponse create() => ListOccupantsResponse._();
  @$core.override
  ListOccupantsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOccupantsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOccupantsResponse>(create);
  static ListOccupantsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Occupant> get occupants => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get homeCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set homeCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHomeCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearHomeCount() => $_clearField(2);
}

/// Запрос на создание жильца
class CreateOccupantRequest extends $pb.GeneratedMessage {
  factory CreateOccupantRequest({
    $core.String? name,
    $core.String? avatarUrl,
    $core.Iterable<$core.String>? deviceIds,
  }) {
    final result = create();
    if (name != null) {
      result.name = name;
    }
    if (avatarUrl != null) {
      result.avatarUrl = avatarUrl;
    }
    if (deviceIds != null) {
      result.deviceIds.addAll(deviceIds);
    }
    return result;
  }

  CreateOccupantRequest._();

  factory CreateOccupantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateOccupantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateOccupantRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'avatarUrl')
    ..pPS(3, _omitFieldNames ? '' : 'deviceIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateOccupantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateOccupantRequest copyWith(
          void Function(CreateOccupantRequest) updates,) =>
      super.copyWith((message) => updates(message as CreateOccupantRequest))
          as CreateOccupantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateOccupantRequest create() => CreateOccupantRequest._();
  @$core.override
  CreateOccupantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateOccupantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateOccupantRequest>(create);
  static CreateOccupantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get avatarUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set avatarUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAvatarUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvatarUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get deviceIds => $_getList(2);
}

/// Запрос на обновление жильца
class UpdateOccupantRequest extends $pb.GeneratedMessage {
  factory UpdateOccupantRequest({
    $core.String? id,
    $core.String? name,
    $core.String? avatarUrl,
    $core.bool? isHome,
    $core.Iterable<$core.String>? deviceIds,
  }) {
    final result = create();
    if (id != null) {
      result.id = id;
    }
    if (name != null) {
      result.name = name;
    }
    if (avatarUrl != null) {
      result.avatarUrl = avatarUrl;
    }
    if (isHome != null) {
      result.isHome = isHome;
    }
    if (deviceIds != null) {
      result.deviceIds.addAll(deviceIds);
    }
    return result;
  }

  UpdateOccupantRequest._();

  factory UpdateOccupantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateOccupantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateOccupantRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'avatarUrl')
    ..aOB(4, _omitFieldNames ? '' : 'isHome')
    ..pPS(5, _omitFieldNames ? '' : 'deviceIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateOccupantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateOccupantRequest copyWith(
          void Function(UpdateOccupantRequest) updates,) =>
      super.copyWith((message) => updates(message as UpdateOccupantRequest))
          as UpdateOccupantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateOccupantRequest create() => UpdateOccupantRequest._();
  @$core.override
  UpdateOccupantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateOccupantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateOccupantRequest>(create);
  static UpdateOccupantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get avatarUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatarUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatarUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatarUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isHome => $_getBF(3);
  @$pb.TagNumber(4)
  set isHome($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsHome() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsHome() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get deviceIds => $_getList(4);
}

/// Запрос на удаление жильца
class DeleteOccupantRequest extends $pb.GeneratedMessage {
  factory DeleteOccupantRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) {
      result.id = id;
    }
    return result;
  }

  DeleteOccupantRequest._();

  factory DeleteOccupantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteOccupantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteOccupantRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteOccupantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteOccupantRequest copyWith(
          void Function(DeleteOccupantRequest) updates,) =>
      super.copyWith((message) => updates(message as DeleteOccupantRequest))
          as DeleteOccupantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteOccupantRequest create() => DeleteOccupantRequest._();
  @$core.override
  DeleteOccupantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteOccupantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteOccupantRequest>(create);
  static DeleteOccupantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

/// Запрос на обновление присутствия
class UpdatePresenceRequest extends $pb.GeneratedMessage {
  factory UpdatePresenceRequest({
    $core.String? occupantId,
    $core.bool? isHome,
  }) {
    final result = create();
    if (occupantId != null) {
      result.occupantId = occupantId;
    }
    if (isHome != null) {
      result.isHome = isHome;
    }
    return result;
  }

  UpdatePresenceRequest._();

  factory UpdatePresenceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdatePresenceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePresenceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create,)
    ..aOS(1, _omitFieldNames ? '' : 'occupantId')
    ..aOB(2, _omitFieldNames ? '' : 'isHome')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePresenceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePresenceRequest copyWith(
          void Function(UpdatePresenceRequest) updates,) =>
      super.copyWith((message) => updates(message as UpdatePresenceRequest))
          as UpdatePresenceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePresenceRequest create() => UpdatePresenceRequest._();
  @$core.override
  UpdatePresenceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdatePresenceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePresenceRequest>(create);
  static UpdatePresenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get occupantId => $_getSZ(0);
  @$pb.TagNumber(1)
  set occupantId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOccupantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOccupantId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isHome => $_getBF(1);
  @$pb.TagNumber(2)
  set isHome($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsHome() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsHome() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
