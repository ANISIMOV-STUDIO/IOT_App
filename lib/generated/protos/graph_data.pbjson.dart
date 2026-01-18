// This is a generated file - do not edit.
//
// Generated from graph_data.proto.

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

@$core.Deprecated('Use graphDataPointDescriptor instead')
const GraphDataPoint$json = {
  '1': 'GraphDataPoint',
  '2': [
    {
      '1': 'timestamp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp',
    },
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `GraphDataPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List graphDataPointDescriptor = $convert.base64Decode(
    'Cg5HcmFwaERhdGFQb2ludBI4Cgl0aW1lc3RhbXAYASABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgl0aW1lc3RhbXASFAoFdmFsdWUYAiABKAFSBXZhbHVl');

@$core.Deprecated('Use graphDataRequestDescriptor instead')
const GraphDataRequest$json = {
  '1': 'GraphDataRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'metric',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.breez.GraphMetric',
      '10': 'metric',
    },
    {
      '1': 'from',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from',
    },
    {
      '1': 'to',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to',
    },
    {
      '1': 'resolution',
      '3': 5,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'resolution',
      '17': true,
    },
  ],
  '8': [
    {'1': '_resolution'},
  ],
};

/// Descriptor for `GraphDataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List graphDataRequestDescriptor = $convert.base64Decode(
    'ChBHcmFwaERhdGFSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSKgoGbWV0cm'
    'ljGAIgASgOMhIuYnJlZXouR3JhcGhNZXRyaWNSBm1ldHJpYxIuCgRmcm9tGAMgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgEIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSAnRvEiMKCnJlc29sdXRpb24YBSABKAVIAFIKcmVzb2x1dGlvbogBAUIN'
    'CgtfcmVzb2x1dGlvbg==');

@$core.Deprecated('Use graphDataResponseDescriptor instead')
const GraphDataResponse$json = {
  '1': 'GraphDataResponse',
  '2': [
    {
      '1': 'data_points',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.breez.GraphDataPoint',
      '10': 'dataPoints',
    },
    {
      '1': 'metric',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.breez.GraphMetric',
      '10': 'metric',
    },
    {
      '1': 'stats',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.breez.GraphStats',
      '10': 'stats',
    },
  ],
};

/// Descriptor for `GraphDataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List graphDataResponseDescriptor = $convert.base64Decode(
    'ChFHcmFwaERhdGFSZXNwb25zZRI2CgtkYXRhX3BvaW50cxgBIAMoCzIVLmJyZWV6LkdyYXBoRG'
    'F0YVBvaW50UgpkYXRhUG9pbnRzEioKBm1ldHJpYxgCIAEoDjISLmJyZWV6LkdyYXBoTWV0cmlj'
    'UgZtZXRyaWMSJwoFc3RhdHMYAyABKAsyES5icmVlei5HcmFwaFN0YXRzUgVzdGF0cw==');

@$core.Deprecated('Use graphStatsDescriptor instead')
const GraphStats$json = {
  '1': 'GraphStats',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 1, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 1, '10': 'max'},
    {'1': 'avg', '3': 3, '4': 1, '5': 1, '10': 'avg'},
    {'1': 'current', '3': 4, '4': 1, '5': 1, '10': 'current'},
  ],
};

/// Descriptor for `GraphStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List graphStatsDescriptor = $convert.base64Decode(
    'CgpHcmFwaFN0YXRzEhAKA21pbhgBIAEoAVIDbWluEhAKA21heBgCIAEoAVIDbWF4EhAKA2F2Zx'
    'gDIAEoAVIDYXZnEhgKB2N1cnJlbnQYBCABKAFSB2N1cnJlbnQ=');
