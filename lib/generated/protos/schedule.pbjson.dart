// This is a generated file - do not edit.
//
// Generated from schedule.proto.

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

@$core.Deprecated('Use scheduleEntryDescriptor instead')
const ScheduleEntry$json = {
  '1': 'ScheduleEntry',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'device_id', '3': 2, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'time', '3': 3, '4': 1, '5': 9, '10': 'time'},
    {'1': 'days', '3': 4, '4': 3, '5': 5, '10': 'days'},
    {
      '1': 'action',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.breez.ScheduleAction',
      '10': 'action',
    },
    {'1': 'enabled', '3': 6, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'created_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt',
    },
  ],
};

/// Descriptor for `ScheduleEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleEntryDescriptor = $convert.base64Decode(
    'Cg1TY2hlZHVsZUVudHJ5Eg4KAmlkGAEgASgJUgJpZBIbCglkZXZpY2VfaWQYAiABKAlSCGRldm'
    'ljZUlkEhIKBHRpbWUYAyABKAlSBHRpbWUSEgoEZGF5cxgEIAMoBVIEZGF5cxItCgZhY3Rpb24Y'
    'BSABKAsyFS5icmVlei5TY2hlZHVsZUFjdGlvblIGYWN0aW9uEhgKB2VuYWJsZWQYBiABKAhSB2'
    'VuYWJsZWQSOQoKY3JlYXRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CWNyZWF0ZWRBdA==');

@$core.Deprecated('Use scheduleActionDescriptor instead')
const ScheduleAction$json = {
  '1': 'ScheduleAction',
  '2': [
    {'1': 'power', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'power', '17': true},
    {'1': 'temp', '3': 2, '4': 1, '5': 5, '9': 1, '10': 'temp', '17': true},
    {
      '1': 'mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.breez.OperationMode',
      '9': 2,
      '10': 'mode',
      '17': true,
    },
    {
      '1': 'supply_fan',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '9': 3,
      '10': 'supplyFan',
      '17': true,
    },
    {
      '1': 'exhaust_fan',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.breez.FanSpeed',
      '9': 4,
      '10': 'exhaustFan',
      '17': true,
    },
    {
      '1': 'preset_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'presetId',
      '17': true,
    },
  ],
  '8': [
    {'1': '_power'},
    {'1': '_temp'},
    {'1': '_mode'},
    {'1': '_supply_fan'},
    {'1': '_exhaust_fan'},
    {'1': '_preset_id'},
  ],
};

/// Descriptor for `ScheduleAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleActionDescriptor = $convert.base64Decode(
    'Cg5TY2hlZHVsZUFjdGlvbhIZCgVwb3dlchgBIAEoCEgAUgVwb3dlcogBARIXCgR0ZW1wGAIgAS'
    'gFSAFSBHRlbXCIAQESLQoEbW9kZRgDIAEoDjIULmJyZWV6Lk9wZXJhdGlvbk1vZGVIAlIEbW9k'
    'ZYgBARIzCgpzdXBwbHlfZmFuGAQgASgOMg8uYnJlZXouRmFuU3BlZWRIA1IJc3VwcGx5RmFuiA'
    'EBEjUKC2V4aGF1c3RfZmFuGAUgASgOMg8uYnJlZXouRmFuU3BlZWRIBFIKZXhoYXVzdEZhbogB'
    'ARIgCglwcmVzZXRfaWQYBiABKAlIBVIIcHJlc2V0SWSIAQFCCAoGX3Bvd2VyQgcKBV90ZW1wQg'
    'cKBV9tb2RlQg0KC19zdXBwbHlfZmFuQg4KDF9leGhhdXN0X2ZhbkIMCgpfcHJlc2V0X2lk');

@$core.Deprecated('Use getScheduleRequestDescriptor instead')
const GetScheduleRequest$json = {
  '1': 'GetScheduleRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `GetScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getScheduleRequestDescriptor =
    $convert.base64Decode(
        'ChJHZXRTY2hlZHVsZVJlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZA==',);

@$core.Deprecated('Use listScheduleResponseDescriptor instead')
const ListScheduleResponse$json = {
  '1': 'ListScheduleResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.breez.ScheduleEntry',
      '10': 'entries',
    },
  ],
};

/// Descriptor for `ListScheduleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listScheduleResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0U2NoZWR1bGVSZXNwb25zZRIuCgdlbnRyaWVzGAEgAygLMhQuYnJlZXouU2NoZWR1bG'
    'VFbnRyeVIHZW50cmllcw==');

@$core.Deprecated('Use createScheduleRequestDescriptor instead')
const CreateScheduleRequest$json = {
  '1': 'CreateScheduleRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'time', '3': 2, '4': 1, '5': 9, '10': 'time'},
    {'1': 'days', '3': 3, '4': 3, '5': 5, '10': 'days'},
    {
      '1': 'action',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.breez.ScheduleAction',
      '10': 'action',
    },
    {'1': 'enabled', '3': 5, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `CreateScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createScheduleRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVTY2hlZHVsZVJlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBISCg'
    'R0aW1lGAIgASgJUgR0aW1lEhIKBGRheXMYAyADKAVSBGRheXMSLQoGYWN0aW9uGAQgASgLMhUu'
    'YnJlZXouU2NoZWR1bGVBY3Rpb25SBmFjdGlvbhIYCgdlbmFibGVkGAUgASgIUgdlbmFibGVk');

@$core.Deprecated('Use updateScheduleRequestDescriptor instead')
const UpdateScheduleRequest$json = {
  '1': 'UpdateScheduleRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'time', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'time', '17': true},
    {'1': 'days', '3': 3, '4': 3, '5': 5, '10': 'days'},
    {
      '1': 'action',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.breez.ScheduleAction',
      '9': 1,
      '10': 'action',
      '17': true,
    },
    {
      '1': 'enabled',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'enabled',
      '17': true,
    },
  ],
  '8': [
    {'1': '_time'},
    {'1': '_action'},
    {'1': '_enabled'},
  ],
};

/// Descriptor for `UpdateScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateScheduleRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTY2hlZHVsZVJlcXVlc3QSDgoCaWQYASABKAlSAmlkEhcKBHRpbWUYAiABKAlIAF'
    'IEdGltZYgBARISCgRkYXlzGAMgAygFUgRkYXlzEjIKBmFjdGlvbhgEIAEoCzIVLmJyZWV6LlNj'
    'aGVkdWxlQWN0aW9uSAFSBmFjdGlvbogBARIdCgdlbmFibGVkGAUgASgISAJSB2VuYWJsZWSIAQ'
    'FCBwoFX3RpbWVCCQoHX2FjdGlvbkIKCghfZW5hYmxlZA==');

@$core.Deprecated('Use deleteScheduleRequestDescriptor instead')
const DeleteScheduleRequest$json = {
  '1': 'DeleteScheduleRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteScheduleRequestDescriptor = $convert
    .base64Decode('ChVEZWxldGVTY2hlZHVsZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');
