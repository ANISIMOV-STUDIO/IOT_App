// This is a generated file - do not edit.
//
// Generated from hvac_device.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'google/protobuf/timestamp.pb.dart'
    as $1;

import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// HVAC устройство
class HvacDevice extends $pb.GeneratedMessage {
  factory HvacDevice({
    $core.String? id,
    $core.String? name,
    $core.bool? power,
    $core.int? temp,
    $0.OperationMode? mode,
    $0.FanSpeed? supplyFan,
    $0.FanSpeed? exhaustFan,
    $core.int? currentTemp,
    $core.int? humidity,
    $core.int? co2,
    $core.int? airflow,
    $core.Iterable<$0.Alert>? alerts,
    $0.DeviceStatus? status,
    $1.Timestamp? lastUpdate,
    $core.String? mqttTopic,
    $core.Iterable<Preset>? presets,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (power != null) result.power = power;
    if (temp != null) result.temp = temp;
    if (mode != null) result.mode = mode;
    if (supplyFan != null) result.supplyFan = supplyFan;
    if (exhaustFan != null) result.exhaustFan = exhaustFan;
    if (currentTemp != null) result.currentTemp = currentTemp;
    if (humidity != null) result.humidity = humidity;
    if (co2 != null) result.co2 = co2;
    if (airflow != null) result.airflow = airflow;
    if (alerts != null) result.alerts.addAll(alerts);
    if (status != null) result.status = status;
    if (lastUpdate != null) result.lastUpdate = lastUpdate;
    if (mqttTopic != null) result.mqttTopic = mqttTopic;
    if (presets != null) result.presets.addAll(presets);
    return result;
  }

  HvacDevice._();

  factory HvacDevice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HvacDevice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HvacDevice',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'power')
    ..aI(4, _omitFieldNames ? '' : 'temp')
    ..aE<$0.OperationMode>(5, _omitFieldNames ? '' : 'mode',
        enumValues: $0.OperationMode.values)
    ..aE<$0.FanSpeed>(6, _omitFieldNames ? '' : 'supplyFan',
        enumValues: $0.FanSpeed.values)
    ..aE<$0.FanSpeed>(7, _omitFieldNames ? '' : 'exhaustFan',
        enumValues: $0.FanSpeed.values)
    ..aI(8, _omitFieldNames ? '' : 'currentTemp')
    ..aI(9, _omitFieldNames ? '' : 'humidity')
    ..aI(10, _omitFieldNames ? '' : 'co2')
    ..aI(11, _omitFieldNames ? '' : 'airflow')
    ..pPM<$0.Alert>(12, _omitFieldNames ? '' : 'alerts',
        subBuilder: $0.Alert.create)
    ..aE<$0.DeviceStatus>(13, _omitFieldNames ? '' : 'status',
        enumValues: $0.DeviceStatus.values)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'lastUpdate',
        subBuilder: $1.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'mqttTopic')
    ..pPM<Preset>(16, _omitFieldNames ? '' : 'presets',
        subBuilder: Preset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HvacDevice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HvacDevice copyWith(void Function(HvacDevice) updates) =>
      super.copyWith((message) => updates(message as HvacDevice)) as HvacDevice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HvacDevice create() => HvacDevice._();
  @$core.override
  HvacDevice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HvacDevice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HvacDevice>(create);
  static HvacDevice? _defaultInstance;

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
  $core.bool get power => $_getBF(2);
  @$pb.TagNumber(3)
  set power($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPower() => $_has(2);
  @$pb.TagNumber(3)
  void clearPower() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get temp => $_getIZ(3);
  @$pb.TagNumber(4)
  set temp($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTemp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemp() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.OperationMode get mode => $_getN(4);
  @$pb.TagNumber(5)
  set mode($0.OperationMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearMode() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.FanSpeed get supplyFan => $_getN(5);
  @$pb.TagNumber(6)
  set supplyFan($0.FanSpeed value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSupplyFan() => $_has(5);
  @$pb.TagNumber(6)
  void clearSupplyFan() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.FanSpeed get exhaustFan => $_getN(6);
  @$pb.TagNumber(7)
  set exhaustFan($0.FanSpeed value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExhaustFan() => $_has(6);
  @$pb.TagNumber(7)
  void clearExhaustFan() => $_clearField(7);

  /// Текущие показания
  @$pb.TagNumber(8)
  $core.int get currentTemp => $_getIZ(7);
  @$pb.TagNumber(8)
  set currentTemp($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrentTemp() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrentTemp() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get humidity => $_getIZ(8);
  @$pb.TagNumber(9)
  set humidity($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHumidity() => $_has(8);
  @$pb.TagNumber(9)
  void clearHumidity() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get co2 => $_getIZ(9);
  @$pb.TagNumber(10)
  set co2($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCo2() => $_has(9);
  @$pb.TagNumber(10)
  void clearCo2() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get airflow => $_getIZ(10);
  @$pb.TagNumber(11)
  set airflow($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAirflow() => $_has(10);
  @$pb.TagNumber(11)
  void clearAirflow() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$0.Alert> get alerts => $_getList(11);

  @$pb.TagNumber(13)
  $0.DeviceStatus get status => $_getN(12);
  @$pb.TagNumber(13)
  set status($0.DeviceStatus value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStatus() => $_has(12);
  @$pb.TagNumber(13)
  void clearStatus() => $_clearField(13);

  @$pb.TagNumber(14)
  $1.Timestamp get lastUpdate => $_getN(13);
  @$pb.TagNumber(14)
  set lastUpdate($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasLastUpdate() => $_has(13);
  @$pb.TagNumber(14)
  void clearLastUpdate() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureLastUpdate() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get mqttTopic => $_getSZ(14);
  @$pb.TagNumber(15)
  set mqttTopic($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasMqttTopic() => $_has(14);
  @$pb.TagNumber(15)
  void clearMqttTopic() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbList<Preset> get presets => $_getList(15);
}

/// Пресет (пользовательская конфигурация)
class Preset extends $pb.GeneratedMessage {
  factory Preset({
    $core.String? id,
    $core.String? name,
    $core.int? temp,
    $0.OperationMode? mode,
    $0.FanSpeed? supplyFan,
    $0.FanSpeed? exhaustFan,
    $core.String? icon,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (temp != null) result.temp = temp;
    if (mode != null) result.mode = mode;
    if (supplyFan != null) result.supplyFan = supplyFan;
    if (exhaustFan != null) result.exhaustFan = exhaustFan;
    if (icon != null) result.icon = icon;
    return result;
  }

  Preset._();

  factory Preset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Preset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Preset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'temp')
    ..aE<$0.OperationMode>(4, _omitFieldNames ? '' : 'mode',
        enumValues: $0.OperationMode.values)
    ..aE<$0.FanSpeed>(5, _omitFieldNames ? '' : 'supplyFan',
        enumValues: $0.FanSpeed.values)
    ..aE<$0.FanSpeed>(6, _omitFieldNames ? '' : 'exhaustFan',
        enumValues: $0.FanSpeed.values)
    ..aOS(7, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Preset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Preset copyWith(void Function(Preset) updates) =>
      super.copyWith((message) => updates(message as Preset)) as Preset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Preset create() => Preset._();
  @$core.override
  Preset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Preset getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Preset>(create);
  static Preset? _defaultInstance;

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
  $core.int get temp => $_getIZ(2);
  @$pb.TagNumber(3)
  set temp($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTemp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemp() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.OperationMode get mode => $_getN(3);
  @$pb.TagNumber(4)
  set mode($0.OperationMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.FanSpeed get supplyFan => $_getN(4);
  @$pb.TagNumber(5)
  set supplyFan($0.FanSpeed value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSupplyFan() => $_has(4);
  @$pb.TagNumber(5)
  void clearSupplyFan() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.FanSpeed get exhaustFan => $_getN(5);
  @$pb.TagNumber(6)
  set exhaustFan($0.FanSpeed value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasExhaustFan() => $_has(5);
  @$pb.TagNumber(6)
  void clearExhaustFan() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get icon => $_getSZ(6);
  @$pb.TagNumber(7)
  set icon($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIcon() => $_has(6);
  @$pb.TagNumber(7)
  void clearIcon() => $_clearField(7);
}

/// Запрос на создание устройства
class CreateDeviceRequest extends $pb.GeneratedMessage {
  factory CreateDeviceRequest({
    $core.String? name,
    $core.String? mqttTopic,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (mqttTopic != null) result.mqttTopic = mqttTopic;
    return result;
  }

  CreateDeviceRequest._();

  factory CreateDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateDeviceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'mqttTopic')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateDeviceRequest copyWith(void Function(CreateDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as CreateDeviceRequest))
          as CreateDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateDeviceRequest create() => CreateDeviceRequest._();
  @$core.override
  CreateDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateDeviceRequest>(create);
  static CreateDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mqttTopic => $_getSZ(1);
  @$pb.TagNumber(2)
  set mqttTopic($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMqttTopic() => $_has(1);
  @$pb.TagNumber(2)
  void clearMqttTopic() => $_clearField(2);
}

/// Запрос на получение устройства
class GetDeviceRequest extends $pb.GeneratedMessage {
  factory GetDeviceRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetDeviceRequest._();

  factory GetDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDeviceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDeviceRequest copyWith(void Function(GetDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as GetDeviceRequest))
          as GetDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDeviceRequest create() => GetDeviceRequest._();
  @$core.override
  GetDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDeviceRequest>(create);
  static GetDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

/// Ответ со списком устройств
class ListDevicesResponse extends $pb.GeneratedMessage {
  factory ListDevicesResponse({
    $core.Iterable<HvacDevice>? devices,
  }) {
    final result = create();
    if (devices != null) result.devices.addAll(devices);
    return result;
  }

  ListDevicesResponse._();

  factory ListDevicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDevicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDevicesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..pPM<HvacDevice>(1, _omitFieldNames ? '' : 'devices',
        subBuilder: HvacDevice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesResponse copyWith(void Function(ListDevicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListDevicesResponse))
          as ListDevicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDevicesResponse create() => ListDevicesResponse._();
  @$core.override
  ListDevicesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDevicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDevicesResponse>(create);
  static ListDevicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<HvacDevice> get devices => $_getList(0);
}

/// Запрос на обновление устройства
class UpdateDeviceRequest extends $pb.GeneratedMessage {
  factory UpdateDeviceRequest({
    $core.String? id,
    $core.String? name,
    $core.bool? power,
    $core.int? temp,
    $0.OperationMode? mode,
    $0.FanSpeed? supplyFan,
    $0.FanSpeed? exhaustFan,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (power != null) result.power = power;
    if (temp != null) result.temp = temp;
    if (mode != null) result.mode = mode;
    if (supplyFan != null) result.supplyFan = supplyFan;
    if (exhaustFan != null) result.exhaustFan = exhaustFan;
    return result;
  }

  UpdateDeviceRequest._();

  factory UpdateDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateDeviceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'power')
    ..aI(4, _omitFieldNames ? '' : 'temp')
    ..aE<$0.OperationMode>(5, _omitFieldNames ? '' : 'mode',
        enumValues: $0.OperationMode.values)
    ..aE<$0.FanSpeed>(6, _omitFieldNames ? '' : 'supplyFan',
        enumValues: $0.FanSpeed.values)
    ..aE<$0.FanSpeed>(7, _omitFieldNames ? '' : 'exhaustFan',
        enumValues: $0.FanSpeed.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeviceRequest copyWith(void Function(UpdateDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateDeviceRequest))
          as UpdateDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateDeviceRequest create() => UpdateDeviceRequest._();
  @$core.override
  UpdateDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateDeviceRequest>(create);
  static UpdateDeviceRequest? _defaultInstance;

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
  $core.bool get power => $_getBF(2);
  @$pb.TagNumber(3)
  set power($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPower() => $_has(2);
  @$pb.TagNumber(3)
  void clearPower() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get temp => $_getIZ(3);
  @$pb.TagNumber(4)
  set temp($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTemp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemp() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.OperationMode get mode => $_getN(4);
  @$pb.TagNumber(5)
  set mode($0.OperationMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearMode() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.FanSpeed get supplyFan => $_getN(5);
  @$pb.TagNumber(6)
  set supplyFan($0.FanSpeed value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSupplyFan() => $_has(5);
  @$pb.TagNumber(6)
  void clearSupplyFan() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.FanSpeed get exhaustFan => $_getN(6);
  @$pb.TagNumber(7)
  set exhaustFan($0.FanSpeed value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExhaustFan() => $_has(6);
  @$pb.TagNumber(7)
  void clearExhaustFan() => $_clearField(7);
}

/// Установить состояние питания
class SetPowerRequest extends $pb.GeneratedMessage {
  factory SetPowerRequest({
    $core.String? deviceId,
    $core.bool? power,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (power != null) result.power = power;
    return result;
  }

  SetPowerRequest._();

  factory SetPowerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetPowerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetPowerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOB(2, _omitFieldNames ? '' : 'power')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPowerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPowerRequest copyWith(void Function(SetPowerRequest) updates) =>
      super.copyWith((message) => updates(message as SetPowerRequest))
          as SetPowerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetPowerRequest create() => SetPowerRequest._();
  @$core.override
  SetPowerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetPowerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetPowerRequest>(create);
  static SetPowerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get power => $_getBF(1);
  @$pb.TagNumber(2)
  set power($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPower() => $_has(1);
  @$pb.TagNumber(2)
  void clearPower() => $_clearField(2);
}

/// Установить температуру
class SetTemperatureRequest extends $pb.GeneratedMessage {
  factory SetTemperatureRequest({
    $core.String? deviceId,
    $core.int? temperature,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (temperature != null) result.temperature = temperature;
    return result;
  }

  SetTemperatureRequest._();

  factory SetTemperatureRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTemperatureRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTemperatureRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aI(2, _omitFieldNames ? '' : 'temperature')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTemperatureRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTemperatureRequest copyWith(
          void Function(SetTemperatureRequest) updates) =>
      super.copyWith((message) => updates(message as SetTemperatureRequest))
          as SetTemperatureRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTemperatureRequest create() => SetTemperatureRequest._();
  @$core.override
  SetTemperatureRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetTemperatureRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTemperatureRequest>(create);
  static SetTemperatureRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get temperature => $_getIZ(1);
  @$pb.TagNumber(2)
  set temperature($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTemperature() => $_has(1);
  @$pb.TagNumber(2)
  void clearTemperature() => $_clearField(2);
}

/// Установить режим работы
class SetModeRequest extends $pb.GeneratedMessage {
  factory SetModeRequest({
    $core.String? deviceId,
    $0.OperationMode? mode,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (mode != null) result.mode = mode;
    return result;
  }

  SetModeRequest._();

  factory SetModeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetModeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetModeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aE<$0.OperationMode>(2, _omitFieldNames ? '' : 'mode',
        enumValues: $0.OperationMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetModeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetModeRequest copyWith(void Function(SetModeRequest) updates) =>
      super.copyWith((message) => updates(message as SetModeRequest))
          as SetModeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetModeRequest create() => SetModeRequest._();
  @$core.override
  SetModeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetModeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetModeRequest>(create);
  static SetModeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.OperationMode get mode => $_getN(1);
  @$pb.TagNumber(2)
  set mode($0.OperationMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);
}

/// Установить скорость вентиляторов
class SetFanSpeedRequest extends $pb.GeneratedMessage {
  factory SetFanSpeedRequest({
    $core.String? deviceId,
    $0.FanSpeed? supplyFan,
    $0.FanSpeed? exhaustFan,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (supplyFan != null) result.supplyFan = supplyFan;
    if (exhaustFan != null) result.exhaustFan = exhaustFan;
    return result;
  }

  SetFanSpeedRequest._();

  factory SetFanSpeedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetFanSpeedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetFanSpeedRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aE<$0.FanSpeed>(2, _omitFieldNames ? '' : 'supplyFan',
        enumValues: $0.FanSpeed.values)
    ..aE<$0.FanSpeed>(3, _omitFieldNames ? '' : 'exhaustFan',
        enumValues: $0.FanSpeed.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFanSpeedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFanSpeedRequest copyWith(void Function(SetFanSpeedRequest) updates) =>
      super.copyWith((message) => updates(message as SetFanSpeedRequest))
          as SetFanSpeedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetFanSpeedRequest create() => SetFanSpeedRequest._();
  @$core.override
  SetFanSpeedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetFanSpeedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetFanSpeedRequest>(create);
  static SetFanSpeedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.FanSpeed get supplyFan => $_getN(1);
  @$pb.TagNumber(2)
  set supplyFan($0.FanSpeed value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSupplyFan() => $_has(1);
  @$pb.TagNumber(2)
  void clearSupplyFan() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.FanSpeed get exhaustFan => $_getN(2);
  @$pb.TagNumber(3)
  set exhaustFan($0.FanSpeed value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExhaustFan() => $_has(2);
  @$pb.TagNumber(3)
  void clearExhaustFan() => $_clearField(3);
}

/// Применить пресет
class ApplyPresetRequest extends $pb.GeneratedMessage {
  factory ApplyPresetRequest({
    $core.String? deviceId,
    $core.String? presetId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (presetId != null) result.presetId = presetId;
    return result;
  }

  ApplyPresetRequest._();

  factory ApplyPresetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApplyPresetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyPresetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'presetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyPresetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyPresetRequest copyWith(void Function(ApplyPresetRequest) updates) =>
      super.copyWith((message) => updates(message as ApplyPresetRequest))
          as ApplyPresetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplyPresetRequest create() => ApplyPresetRequest._();
  @$core.override
  ApplyPresetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApplyPresetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyPresetRequest>(create);
  static ApplyPresetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get presetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set presetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPresetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPresetId() => $_clearField(2);
}

/// Удалить устройство
class DeleteDeviceRequest extends $pb.GeneratedMessage {
  factory DeleteDeviceRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  DeleteDeviceRequest._();

  factory DeleteDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteDeviceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteDeviceRequest copyWith(void Function(DeleteDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteDeviceRequest))
          as DeleteDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteDeviceRequest create() => DeleteDeviceRequest._();
  @$core.override
  DeleteDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteDeviceRequest>(create);
  static DeleteDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

/// Запрос на стриминг обновлений устройств
class StreamDeviceUpdatesRequest extends $pb.GeneratedMessage {
  factory StreamDeviceUpdatesRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  StreamDeviceUpdatesRequest._();

  factory StreamDeviceUpdatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamDeviceUpdatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamDeviceUpdatesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamDeviceUpdatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamDeviceUpdatesRequest copyWith(
          void Function(StreamDeviceUpdatesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StreamDeviceUpdatesRequest))
          as StreamDeviceUpdatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamDeviceUpdatesRequest create() => StreamDeviceUpdatesRequest._();
  @$core.override
  StreamDeviceUpdatesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamDeviceUpdatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamDeviceUpdatesRequest>(create);
  static StreamDeviceUpdatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
