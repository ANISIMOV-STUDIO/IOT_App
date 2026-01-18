// This is a generated file - do not edit.
//
// Generated from hvac_device.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use hvacDeviceDescriptor instead')
const HvacDevice$json = {
  '1': 'HvacDevice',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'power', '3': 3, '4': 1, '5': 8, '10': 'power'},
    {'1': 'temp', '3': 4, '4': 1, '5': 5, '10': 'temp'},
    {
      '1': 'mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.breez.OperationMode',
      '10': 'mode',
    },
    {
      '1': 'supply_fan',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '10': 'supplyFan',
    },
    {
      '1': 'exhaust_fan',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '10': 'exhaustFan',
    },
    {'1': 'current_temp', '3': 8, '4': 1, '5': 5, '10': 'currentTemp'},
    {'1': 'humidity', '3': 9, '4': 1, '5': 5, '10': 'humidity'},
    {'1': 'co2', '3': 10, '4': 1, '5': 5, '10': 'co2'},
    {'1': 'airflow', '3': 11, '4': 1, '5': 5, '10': 'airflow'},
    {
      '1': 'alerts',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.breez.Alert',
      '10': 'alerts',
    },
    {
      '1': 'status',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.breez.DeviceStatus',
      '10': 'status',
    },
    {
      '1': 'last_update',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastUpdate',
    },
    {'1': 'mqtt_topic', '3': 15, '4': 1, '5': 9, '10': 'mqttTopic'},
    {
      '1': 'presets',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.breez.Preset',
      '10': 'presets',
    },
  ],
};

/// Descriptor for `HvacDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hvacDeviceDescriptor = $convert.base64Decode(
    'CgpIdmFjRGV2aWNlEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhQKBXBvd2'
    'VyGAMgASgIUgVwb3dlchISCgR0ZW1wGAQgASgFUgR0ZW1wEigKBG1vZGUYBSABKA4yFC5icmVl'
    'ei5PcGVyYXRpb25Nb2RlUgRtb2RlEi4KCnN1cHBseV9mYW4YBiABKA4yDy5icmVlei5GYW5TcG'
    'VlZFIJc3VwcGx5RmFuEjAKC2V4aGF1c3RfZmFuGAcgASgOMg8uYnJlZXouRmFuU3BlZWRSCmV4'
    'aGF1c3RGYW4SIQoMY3VycmVudF90ZW1wGAggASgFUgtjdXJyZW50VGVtcBIaCghodW1pZGl0eR'
    'gJIAEoBVIIaHVtaWRpdHkSEAoDY28yGAogASgFUgNjbzISGAoHYWlyZmxvdxgLIAEoBVIHYWly'
    'ZmxvdxIkCgZhbGVydHMYDCADKAsyDC5icmVlei5BbGVydFIGYWxlcnRzEisKBnN0YXR1cxgNIA'
    'EoDjITLmJyZWV6LkRldmljZVN0YXR1c1IGc3RhdHVzEjsKC2xhc3RfdXBkYXRlGA4gASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKbGFzdFVwZGF0ZRIdCgptcXR0X3RvcGljGA8gAS'
    'gJUgltcXR0VG9waWMSJwoHcHJlc2V0cxgQIAMoCzINLmJyZWV6LlByZXNldFIHcHJlc2V0cw==');

@$core.Deprecated('Use presetDescriptor instead')
const Preset$json = {
  '1': 'Preset',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'temp', '3': 3, '4': 1, '5': 5, '10': 'temp'},
    {
      '1': 'mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.breez.OperationMode',
      '10': 'mode',
    },
    {
      '1': 'supply_fan',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '10': 'supplyFan',
    },
    {
      '1': 'exhaust_fan',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '10': 'exhaustFan',
    },
    {'1': 'icon', '3': 7, '4': 1, '5': 9, '10': 'icon'},
  ],
};

/// Descriptor for `Preset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presetDescriptor = $convert.base64Decode(
    'CgZQcmVzZXQSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEdGVtcBgDIA'
    'EoBVIEdGVtcBIoCgRtb2RlGAQgASgOMhQuYnJlZXouT3BlcmF0aW9uTW9kZVIEbW9kZRIuCgpz'
    'dXBwbHlfZmFuGAUgASgOMg8uYnJlZXouRmFuU3BlZWRSCXN1cHBseUZhbhIwCgtleGhhdXN0X2'
    'ZhbhgGIAEoDjIPLmJyZWV6LkZhblNwZWVkUgpleGhhdXN0RmFuEhIKBGljb24YByABKAlSBGlj'
    'b24=');

@$core.Deprecated('Use createDeviceRequestDescriptor instead')
const CreateDeviceRequest$json = {
  '1': 'CreateDeviceRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'mqtt_topic', '3': 2, '4': 1, '5': 9, '10': 'mqttTopic'},
  ],
};

/// Descriptor for `CreateDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDeviceRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVEZXZpY2VSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWUSHQoKbXF0dF90b3BpYx'
    'gCIAEoCVIJbXF0dFRvcGlj');

@$core.Deprecated('Use getDeviceRequestDescriptor instead')
const GetDeviceRequest$json = {
  '1': 'GetDeviceRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDeviceRequestDescriptor =
    $convert.base64Decode('ChBHZXREZXZpY2VSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use listDevicesResponseDescriptor instead')
const ListDevicesResponse$json = {
  '1': 'ListDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.breez.HvacDevice',
      '10': 'devices',
    },
  ],
};

/// Descriptor for `ListDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0RGV2aWNlc1Jlc3BvbnNlEisKB2RldmljZXMYASADKAsyES5icmVlei5IdmFjRGV2aW'
    'NlUgdkZXZpY2Vz');

@$core.Deprecated('Use updateDeviceRequestDescriptor instead')
const UpdateDeviceRequest$json = {
  '1': 'UpdateDeviceRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
    {'1': 'power', '3': 3, '4': 1, '5': 8, '9': 1, '10': 'power', '17': true},
    {'1': 'temp', '3': 4, '4': 1, '5': 5, '9': 2, '10': 'temp', '17': true},
    {
      '1': 'mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.breez.OperationMode',
      '9': 3,
      '10': 'mode',
      '17': true,
    },
    {
      '1': 'supply_fan',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '9': 4,
      '10': 'supplyFan',
      '17': true,
    },
    {
      '1': 'exhaust_fan',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '9': 5,
      '10': 'exhaustFan',
      '17': true,
    },
  ],
  '8': [
    {'1': '_name'},
    {'1': '_power'},
    {'1': '_temp'},
    {'1': '_mode'},
    {'1': '_supply_fan'},
    {'1': '_exhaust_fan'},
  ],
};

/// Descriptor for `UpdateDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDeviceRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVEZXZpY2VSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIXCgRuYW1lGAIgASgJSABSBG'
    '5hbWWIAQESGQoFcG93ZXIYAyABKAhIAVIFcG93ZXKIAQESFwoEdGVtcBgEIAEoBUgCUgR0ZW1w'
    'iAEBEi0KBG1vZGUYBSABKA4yFC5icmVlei5PcGVyYXRpb25Nb2RlSANSBG1vZGWIAQESMwoKc3'
    'VwcGx5X2ZhbhgGIAEoDjIPLmJyZWV6LkZhblNwZWVkSARSCXN1cHBseUZhbogBARI1CgtleGhh'
    'dXN0X2ZhbhgHIAEoDjIPLmJyZWV6LkZhblNwZWVkSAVSCmV4aGF1c3RGYW6IAQFCBwoFX25hbW'
    'VCCAoGX3Bvd2VyQgcKBV90ZW1wQgcKBV9tb2RlQg0KC19zdXBwbHlfZmFuQg4KDF9leGhhdXN0'
    'X2Zhbg==');

@$core.Deprecated('Use setPowerRequestDescriptor instead')
const SetPowerRequest$json = {
  '1': 'SetPowerRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'power', '3': 2, '4': 1, '5': 8, '10': 'power'},
  ],
};

/// Descriptor for `SetPowerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPowerRequestDescriptor = $convert.base64Decode(
    'Cg9TZXRQb3dlclJlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIUCgVwb3dlch'
    'gCIAEoCFIFcG93ZXI=');

@$core.Deprecated('Use setTemperatureRequestDescriptor instead')
const SetTemperatureRequest$json = {
  '1': 'SetTemperatureRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'temperature', '3': 2, '4': 1, '5': 5, '10': 'temperature'},
  ],
};

/// Descriptor for `SetTemperatureRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTemperatureRequestDescriptor = $convert.base64Decode(
    'ChVTZXRUZW1wZXJhdHVyZVJlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIgCg'
    't0ZW1wZXJhdHVyZRgCIAEoBVILdGVtcGVyYXR1cmU=');

@$core.Deprecated('Use setModeRequestDescriptor instead')
const SetModeRequest$json = {
  '1': 'SetModeRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.breez.OperationMode',
      '10': 'mode',
    },
  ],
};

/// Descriptor for `SetModeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setModeRequestDescriptor = $convert.base64Decode(
    'Cg5TZXRNb2RlUmVxdWVzdBIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEigKBG1vZGUYAi'
    'ABKA4yFC5icmVlei5PcGVyYXRpb25Nb2RlUgRtb2Rl');

@$core.Deprecated('Use setFanSpeedRequestDescriptor instead')
const SetFanSpeedRequest$json = {
  '1': 'SetFanSpeedRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'supply_fan',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '10': 'supplyFan',
    },
    {
      '1': 'exhaust_fan',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '10': 'exhaustFan',
    },
  ],
};

/// Descriptor for `SetFanSpeedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setFanSpeedRequestDescriptor = $convert.base64Decode(
    'ChJTZXRGYW5TcGVlZFJlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIuCgpzdX'
    'BwbHlfZmFuGAIgASgOMg8uYnJlZXouRmFuU3BlZWRSCXN1cHBseUZhbhIwCgtleGhhdXN0X2Zh'
    'bhgDIAEoDjIPLmJyZWV6LkZhblNwZWVkUgpleGhhdXN0RmFu');

@$core.Deprecated('Use applyPresetRequestDescriptor instead')
const ApplyPresetRequest$json = {
  '1': 'ApplyPresetRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'preset_id', '3': 2, '4': 1, '5': 9, '10': 'presetId'},
  ],
};

/// Descriptor for `ApplyPresetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyPresetRequestDescriptor = $convert.base64Decode(
    'ChJBcHBseVByZXNldFJlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIbCglwcm'
    'VzZXRfaWQYAiABKAlSCHByZXNldElk');

@$core.Deprecated('Use deleteDeviceRequestDescriptor instead')
const DeleteDeviceRequest$json = {
  '1': 'DeleteDeviceRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteDeviceRequestDescriptor = $convert
    .base64Decode('ChNEZWxldGVEZXZpY2VSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use streamDeviceUpdatesRequestDescriptor instead')
const StreamDeviceUpdatesRequest$json = {
  '1': 'StreamDeviceUpdatesRequest',
  '2': [
    {
      '1': 'device_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'deviceId',
      '17': true,
    },
  ],
  '8': [
    {'1': '_device_id'},
  ],
};

/// Descriptor for `StreamDeviceUpdatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamDeviceUpdatesRequestDescriptor =
    $convert.base64Decode(
        'ChpTdHJlYW1EZXZpY2VVcGRhdGVzUmVxdWVzdBIgCglkZXZpY2VfaWQYASABKAlIAFIIZGV2aW'
        'NlSWSIAQFCDAoKX2RldmljZV9pZA==');
