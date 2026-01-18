// This is a generated file - do not edit.
//
// Generated from energy.proto.

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

@$core.Deprecated('Use energyPeriodDescriptor instead')
const EnergyPeriod$json = {
  '1': 'EnergyPeriod',
  '2': [
    {'1': 'ENERGY_PERIOD_UNSPECIFIED', '2': 0},
    {'1': 'ENERGY_PERIOD_HOURLY', '2': 1},
    {'1': 'ENERGY_PERIOD_DAILY', '2': 2},
    {'1': 'ENERGY_PERIOD_WEEKLY', '2': 3},
    {'1': 'ENERGY_PERIOD_MONTHLY', '2': 4},
  ],
};

/// Descriptor for `EnergyPeriod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List energyPeriodDescriptor = $convert.base64Decode(
    'CgxFbmVyZ3lQZXJpb2QSHQoZRU5FUkdZX1BFUklPRF9VTlNQRUNJRklFRBAAEhgKFEVORVJHWV'
    '9QRVJJT0RfSE9VUkxZEAESFwoTRU5FUkdZX1BFUklPRF9EQUlMWRACEhgKFEVORVJHWV9QRVJJ'
    'T0RfV0VFS0xZEAMSGQoVRU5FUkdZX1BFUklPRF9NT05USExZEAQ=');

@$core.Deprecated('Use energyStatsDescriptor instead')
const EnergyStats$json = {
  '1': 'EnergyStats',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'current_consumption',
      '3': 2,
      '4': 1,
      '5': 1,
      '10': 'currentConsumption',
    },
    {
      '1': 'daily_consumption',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'dailyConsumption',
    },
    {
      '1': 'weekly_consumption',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'weeklyConsumption',
    },
    {
      '1': 'monthly_consumption',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'monthlyConsumption',
    },
    {'1': 'cost_per_hour', '3': 6, '4': 1, '5': 1, '10': 'costPerHour'},
    {'1': 'daily_cost', '3': 7, '4': 1, '5': 1, '10': 'dailyCost'},
    {'1': 'monthly_cost', '3': 8, '4': 1, '5': 1, '10': 'monthlyCost'},
    {
      '1': 'last_update',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastUpdate',
    },
  ],
};

/// Descriptor for `EnergyStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List energyStatsDescriptor = $convert.base64Decode(
    'CgtFbmVyZ3lTdGF0cxIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEi8KE2N1cnJlbnRfY2'
    '9uc3VtcHRpb24YAiABKAFSEmN1cnJlbnRDb25zdW1wdGlvbhIrChFkYWlseV9jb25zdW1wdGlv'
    'bhgDIAEoAVIQZGFpbHlDb25zdW1wdGlvbhItChJ3ZWVrbHlfY29uc3VtcHRpb24YBCABKAFSEX'
    'dlZWtseUNvbnN1bXB0aW9uEi8KE21vbnRobHlfY29uc3VtcHRpb24YBSABKAFSEm1vbnRobHlD'
    'b25zdW1wdGlvbhIiCg1jb3N0X3Blcl9ob3VyGAYgASgBUgtjb3N0UGVySG91chIdCgpkYWlseV'
    '9jb3N0GAcgASgBUglkYWlseUNvc3QSIQoMbW9udGhseV9jb3N0GAggASgBUgttb250aGx5Q29z'
    'dBI7CgtsYXN0X3VwZGF0ZRgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmxhc3'
    'RVcGRhdGU=');

@$core.Deprecated('Use getEnergyStatsRequestDescriptor instead')
const GetEnergyStatsRequest$json = {
  '1': 'GetEnergyStatsRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `GetEnergyStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEnergyStatsRequestDescriptor = $convert.base64Decode(
    'ChVHZXRFbmVyZ3lTdGF0c1JlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZA==',);

@$core.Deprecated('Use energyHistoryRequestDescriptor instead')
const EnergyHistoryRequest$json = {
  '1': 'EnergyHistoryRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from',
    },
    {
      '1': 'to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to',
    },
    {
      '1': 'period',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.breez.EnergyPeriod',
      '10': 'period',
    },
  ],
};

/// Descriptor for `EnergyHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List energyHistoryRequestDescriptor = $convert.base64Decode(
    'ChRFbmVyZ3lIaXN0b3J5UmVxdWVzdBIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEi4KBG'
    'Zyb20YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAMgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8SKwoGcGVyaW9kGAQgASgOMhMuYnJlZX'
    'ouRW5lcmd5UGVyaW9kUgZwZXJpb2Q=');

@$core.Deprecated('Use energyHistoryResponseDescriptor instead')
const EnergyHistoryResponse$json = {
  '1': 'EnergyHistoryResponse',
  '2': [
    {
      '1': 'data_points',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.breez.EnergyDataPoint',
      '10': 'dataPoints',
    },
    {
      '1': 'total_consumption',
      '3': 2,
      '4': 1,
      '5': 1,
      '10': 'totalConsumption',
    },
    {'1': 'total_cost', '3': 3, '4': 1, '5': 1, '10': 'totalCost'},
  ],
};

/// Descriptor for `EnergyHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List energyHistoryResponseDescriptor = $convert.base64Decode(
    'ChVFbmVyZ3lIaXN0b3J5UmVzcG9uc2USNwoLZGF0YV9wb2ludHMYASADKAsyFi5icmVlei5Fbm'
    'VyZ3lEYXRhUG9pbnRSCmRhdGFQb2ludHMSKwoRdG90YWxfY29uc3VtcHRpb24YAiABKAFSEHRv'
    'dGFsQ29uc3VtcHRpb24SHQoKdG90YWxfY29zdBgDIAEoAVIJdG90YWxDb3N0');

@$core.Deprecated('Use energyDataPointDescriptor instead')
const EnergyDataPoint$json = {
  '1': 'EnergyDataPoint',
  '2': [
    {
      '1': 'timestamp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp',
    },
    {'1': 'consumption', '3': 2, '4': 1, '5': 1, '10': 'consumption'},
    {'1': 'cost', '3': 3, '4': 1, '5': 1, '10': 'cost'},
  ],
};

/// Descriptor for `EnergyDataPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List energyDataPointDescriptor = $convert.base64Decode(
    'Cg9FbmVyZ3lEYXRhUG9pbnQSOAoJdGltZXN0YW1wGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIJdGltZXN0YW1wEiAKC2NvbnN1bXB0aW9uGAIgASgBUgtjb25zdW1wdGlvbhIS'
    'CgRjb3N0GAMgASgBUgRjb3N0');
