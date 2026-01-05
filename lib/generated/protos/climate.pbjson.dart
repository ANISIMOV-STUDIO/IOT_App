// This is a generated file - do not edit.
//
// Generated from climate.proto.

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

@$core.Deprecated('Use climateStateDescriptor instead')
const ClimateState$json = {
  '1': 'ClimateState',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'indoor_temp', '3': 2, '4': 1, '5': 5, '10': 'indoorTemp'},
    {'1': 'outdoor_temp', '3': 3, '4': 1, '5': 5, '10': 'outdoorTemp'},
    {'1': 'humidity', '3': 4, '4': 1, '5': 5, '10': 'humidity'},
    {'1': 'co2', '3': 5, '4': 1, '5': 5, '10': 'co2'},
    {
      '1': 'air_quality',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.breez.AirQuality',
      '10': 'airQuality'
    },
    {
      '1': 'timestamp',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {
      '1': 'outdoor_humidity',
      '3': 8,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'outdoorHumidity',
      '17': true
    },
    {
      '1': 'pressure',
      '3': 9,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'pressure',
      '17': true
    },
    {'1': 'pm25', '3': 10, '4': 1, '5': 5, '9': 2, '10': 'pm25', '17': true},
    {'1': 'pm10', '3': 11, '4': 1, '5': 5, '9': 3, '10': 'pm10', '17': true},
  ],
  '8': [
    {'1': '_outdoor_humidity'},
    {'1': '_pressure'},
    {'1': '_pm25'},
    {'1': '_pm10'},
  ],
};

/// Descriptor for `ClimateState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List climateStateDescriptor = $convert.base64Decode(
    'CgxDbGltYXRlU3RhdGUSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIfCgtpbmRvb3JfdG'
    'VtcBgCIAEoBVIKaW5kb29yVGVtcBIhCgxvdXRkb29yX3RlbXAYAyABKAVSC291dGRvb3JUZW1w'
    'EhoKCGh1bWlkaXR5GAQgASgFUghodW1pZGl0eRIQCgNjbzIYBSABKAVSA2NvMhIyCgthaXJfcX'
    'VhbGl0eRgGIAEoDjIRLmJyZWV6LkFpclF1YWxpdHlSCmFpclF1YWxpdHkSOAoJdGltZXN0YW1w'
    'GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdGltZXN0YW1wEi4KEG91dGRvb3'
    'JfaHVtaWRpdHkYCCABKAVIAFIPb3V0ZG9vckh1bWlkaXR5iAEBEh8KCHByZXNzdXJlGAkgASgB'
    'SAFSCHByZXNzdXJliAEBEhcKBHBtMjUYCiABKAVIAlIEcG0yNYgBARIXCgRwbTEwGAsgASgFSA'
    'NSBHBtMTCIAQFCEwoRX291dGRvb3JfaHVtaWRpdHlCCwoJX3ByZXNzdXJlQgcKBV9wbTI1QgcK'
    'BV9wbTEw');

@$core.Deprecated('Use getClimateStateRequestDescriptor instead')
const GetClimateStateRequest$json = {
  '1': 'GetClimateStateRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `GetClimateStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getClimateStateRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRDbGltYXRlU3RhdGVSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQ=');

@$core.Deprecated('Use climateHistoryRequestDescriptor instead')
const ClimateHistoryRequest$json = {
  '1': 'ClimateHistoryRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
  ],
};

/// Descriptor for `ClimateHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List climateHistoryRequestDescriptor = $convert.base64Decode(
    'ChVDbGltYXRlSGlzdG9yeVJlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIuCg'
    'Rmcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgDIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRv');

@$core.Deprecated('Use climateHistoryResponseDescriptor instead')
const ClimateHistoryResponse$json = {
  '1': 'ClimateHistoryResponse',
  '2': [
    {
      '1': 'history',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.breez.ClimateState',
      '10': 'history'
    },
  ],
};

/// Descriptor for `ClimateHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List climateHistoryResponseDescriptor =
    $convert.base64Decode(
        'ChZDbGltYXRlSGlzdG9yeVJlc3BvbnNlEi0KB2hpc3RvcnkYASADKAsyEy5icmVlei5DbGltYX'
        'RlU3RhdGVSB2hpc3Rvcnk=');
