// This is a generated file - do not edit.
//
// Generated from notification.proto.

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

@$core.Deprecated('Use notificationDescriptor instead')
const Notification$json = {
  '1': 'Notification',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'device_id', '3': 2, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.breez.NotificationType',
      '10': 'type'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'message', '3': 5, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'timestamp',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {'1': 'is_read', '3': 7, '4': 1, '5': 8, '10': 'isRead'},
    {
      '1': 'action_url',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'actionUrl',
      '17': true
    },
  ],
  '8': [
    {'1': '_action_url'},
  ],
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode(
    'CgxOb3RpZmljYXRpb24SDgoCaWQYASABKAlSAmlkEhsKCWRldmljZV9pZBgCIAEoCVIIZGV2aW'
    'NlSWQSKwoEdHlwZRgDIAEoDjIXLmJyZWV6Lk5vdGlmaWNhdGlvblR5cGVSBHR5cGUSFAoFdGl0'
    'bGUYBCABKAlSBXRpdGxlEhgKB21lc3NhZ2UYBSABKAlSB21lc3NhZ2USOAoJdGltZXN0YW1wGA'
    'YgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdGltZXN0YW1wEhcKB2lzX3JlYWQY'
    'ByABKAhSBmlzUmVhZBIiCgphY3Rpb25fdXJsGAggASgJSABSCWFjdGlvblVybIgBAUINCgtfYW'
    'N0aW9uX3VybA==');

@$core.Deprecated('Use getNotificationsRequestDescriptor instead')
const GetNotificationsRequest$json = {
  '1': 'GetNotificationsRequest',
  '2': [
    {
      '1': 'device_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'deviceId',
      '17': true
    },
    {
      '1': 'unread_only',
      '3': 2,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'unreadOnly',
      '17': true
    },
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '9': 2, '10': 'limit', '17': true},
  ],
  '8': [
    {'1': '_device_id'},
    {'1': '_unread_only'},
    {'1': '_limit'},
  ],
};

/// Descriptor for `GetNotificationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNotificationsRequestDescriptor = $convert.base64Decode(
    'ChdHZXROb3RpZmljYXRpb25zUmVxdWVzdBIgCglkZXZpY2VfaWQYASABKAlIAFIIZGV2aWNlSW'
    'SIAQESJAoLdW5yZWFkX29ubHkYAiABKAhIAVIKdW5yZWFkT25seYgBARIZCgVsaW1pdBgDIAEo'
    'BUgCUgVsaW1pdIgBAUIMCgpfZGV2aWNlX2lkQg4KDF91bnJlYWRfb25seUIICgZfbGltaXQ=');

@$core.Deprecated('Use listNotificationsResponseDescriptor instead')
const ListNotificationsResponse$json = {
  '1': 'ListNotificationsResponse',
  '2': [
    {
      '1': 'notifications',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.breez.Notification',
      '10': 'notifications'
    },
    {'1': 'unread_count', '3': 2, '4': 1, '5': 5, '10': 'unreadCount'},
  ],
};

/// Descriptor for `ListNotificationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotificationsResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0Tm90aWZpY2F0aW9uc1Jlc3BvbnNlEjkKDW5vdGlmaWNhdGlvbnMYASADKAsyEy5icm'
    'Vlei5Ob3RpZmljYXRpb25SDW5vdGlmaWNhdGlvbnMSIQoMdW5yZWFkX2NvdW50GAIgASgFUgt1'
    'bnJlYWRDb3VudA==');

@$core.Deprecated('Use markAsReadRequestDescriptor instead')
const MarkAsReadRequest$json = {
  '1': 'MarkAsReadRequest',
  '2': [
    {'1': 'notification_ids', '3': 1, '4': 3, '5': 9, '10': 'notificationIds'},
  ],
};

/// Descriptor for `MarkAsReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAsReadRequestDescriptor = $convert.base64Decode(
    'ChFNYXJrQXNSZWFkUmVxdWVzdBIpChBub3RpZmljYXRpb25faWRzGAEgAygJUg9ub3RpZmljYX'
    'Rpb25JZHM=');

@$core.Deprecated('Use streamNotificationsRequestDescriptor instead')
const StreamNotificationsRequest$json = {
  '1': 'StreamNotificationsRequest',
  '2': [
    {
      '1': 'device_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'deviceId',
      '17': true
    },
  ],
  '8': [
    {'1': '_device_id'},
  ],
};

/// Descriptor for `StreamNotificationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamNotificationsRequestDescriptor =
    $convert.base64Decode(
        'ChpTdHJlYW1Ob3RpZmljYXRpb25zUmVxdWVzdBIgCglkZXZpY2VfaWQYASABKAlIAFIIZGV2aW'
        'NlSWSIAQFCDAoKX2RldmljZV9pZA==');

@$core.Deprecated('Use deleteNotificationRequestDescriptor instead')
const DeleteNotificationRequest$json = {
  '1': 'DeleteNotificationRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteNotificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNotificationRequestDescriptor =
    $convert.base64Decode(
        'ChlEZWxldGVOb3RpZmljYXRpb25SZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');
