// This is a generated file - do not edit.
//
// Generated from common.proto.

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

@$core.Deprecated('Use operationModeDescriptor instead')
const OperationMode$json = {
  '1': 'OperationMode',
  '2': [
    {'1': 'OPERATION_MODE_UNSPECIFIED', '2': 0},
    {'1': 'OPERATION_MODE_AUTO', '2': 1},
    {'1': 'OPERATION_MODE_HEAT', '2': 2},
    {'1': 'OPERATION_MODE_COOL', '2': 3},
    {'1': 'OPERATION_MODE_FAN_ONLY', '2': 4},
  ],
};

/// Descriptor for `OperationMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List operationModeDescriptor = $convert.base64Decode(
    'Cg1PcGVyYXRpb25Nb2RlEh4KGk9QRVJBVElPTl9NT0RFX1VOU1BFQ0lGSUVEEAASFwoTT1BFUk'
    'FUSU9OX01PREVfQVVUTxABEhcKE09QRVJBVElPTl9NT0RFX0hFQVQQAhIXChNPUEVSQVRJT05f'
    'TU9ERV9DT09MEAMSGwoXT1BFUkFUSU9OX01PREVfRkFOX09OTFkQBA==');

@$core.Deprecated('Use fanSpeedDescriptor instead')
const FanSpeed$json = {
  '1': 'FanSpeed',
  '2': [
    {'1': 'FAN_SPEED_UNSPECIFIED', '2': 0},
    {'1': 'FAN_SPEED_LOW', '2': 1},
    {'1': 'FAN_SPEED_MEDIUM', '2': 2},
    {'1': 'FAN_SPEED_HIGH', '2': 3},
    {'1': 'FAN_SPEED_AUTO', '2': 4},
  ],
};

/// Descriptor for `FanSpeed`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fanSpeedDescriptor = $convert.base64Decode(
    'CghGYW5TcGVlZBIZChVGQU5fU1BFRURfVU5TUEVDSUZJRUQQABIRCg1GQU5fU1BFRURfTE9XEA'
    'ESFAoQRkFOX1NQRUVEX01FRElVTRACEhIKDkZBTl9TUEVFRF9ISUdIEAMSEgoORkFOX1NQRUVE'
    'X0FVVE8QBA==');

@$core.Deprecated('Use deviceStatusDescriptor instead')
const DeviceStatus$json = {
  '1': 'DeviceStatus',
  '2': [
    {'1': 'DEVICE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DEVICE_STATUS_ONLINE', '2': 1},
    {'1': 'DEVICE_STATUS_OFFLINE', '2': 2},
    {'1': 'DEVICE_STATUS_ERROR', '2': 3},
    {'1': 'DEVICE_STATUS_MAINTENANCE', '2': 4},
  ],
};

/// Descriptor for `DeviceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deviceStatusDescriptor = $convert.base64Decode(
    'CgxEZXZpY2VTdGF0dXMSHQoZREVWSUNFX1NUQVRVU19VTlNQRUNJRklFRBAAEhgKFERFVklDRV'
    '9TVEFUVVNfT05MSU5FEAESGQoVREVWSUNFX1NUQVRVU19PRkZMSU5FEAISFwoTREVWSUNFX1NU'
    'QVRVU19FUlJPUhADEh0KGURFVklDRV9TVEFUVVNfTUFJTlRFTkFOQ0UQBA==');

@$core.Deprecated('Use alertTypeDescriptor instead')
const AlertType$json = {
  '1': 'AlertType',
  '2': [
    {'1': 'ALERT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ALERT_TYPE_FILTER_REPLACEMENT', '2': 1},
    {'1': 'ALERT_TYPE_MAINTENANCE_REQUIRED', '2': 2},
    {'1': 'ALERT_TYPE_HIGH_TEMPERATURE', '2': 3},
    {'1': 'ALERT_TYPE_LOW_TEMPERATURE', '2': 4},
    {'1': 'ALERT_TYPE_HIGH_HUMIDITY', '2': 5},
    {'1': 'ALERT_TYPE_HIGH_CO2', '2': 6},
    {'1': 'ALERT_TYPE_SYSTEM_ERROR', '2': 7},
  ],
};

/// Descriptor for `AlertType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List alertTypeDescriptor = $convert.base64Decode(
    'CglBbGVydFR5cGUSGgoWQUxFUlRfVFlQRV9VTlNQRUNJRklFRBAAEiEKHUFMRVJUX1RZUEVfRk'
    'lMVEVSX1JFUExBQ0VNRU5UEAESIwofQUxFUlRfVFlQRV9NQUlOVEVOQU5DRV9SRVFVSVJFRBAC'
    'Eh8KG0FMRVJUX1RZUEVfSElHSF9URU1QRVJBVFVSRRADEh4KGkFMRVJUX1RZUEVfTE9XX1RFTV'
    'BFUkFUVVJFEAQSHAoYQUxFUlRfVFlQRV9ISUdIX0hVTUlESVRZEAUSFwoTQUxFUlRfVFlQRV9I'
    'SUdIX0NPMhAGEhsKF0FMRVJUX1RZUEVfU1lTVEVNX0VSUk9SEAc=');

@$core.Deprecated('Use notificationTypeDescriptor instead')
const NotificationType$json = {
  '1': 'NotificationType',
  '2': [
    {'1': 'NOTIFICATION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'NOTIFICATION_TYPE_INFO', '2': 1},
    {'1': 'NOTIFICATION_TYPE_WARNING', '2': 2},
    {'1': 'NOTIFICATION_TYPE_ERROR', '2': 3},
  ],
};

/// Descriptor for `NotificationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List notificationTypeDescriptor = $convert.base64Decode(
    'ChBOb3RpZmljYXRpb25UeXBlEiEKHU5PVElGSUNBVElPTl9UWVBFX1VOU1BFQ0lGSUVEEAASGg'
    'oWTk9USUZJQ0FUSU9OX1RZUEVfSU5GTxABEh0KGU5PVElGSUNBVElPTl9UWVBFX1dBUk5JTkcQ'
    'AhIbChdOT1RJRklDQVRJT05fVFlQRV9FUlJPUhAD');

@$core.Deprecated('Use graphMetricDescriptor instead')
const GraphMetric$json = {
  '1': 'GraphMetric',
  '2': [
    {'1': 'GRAPH_METRIC_UNSPECIFIED', '2': 0},
    {'1': 'GRAPH_METRIC_TEMPERATURE', '2': 1},
    {'1': 'GRAPH_METRIC_HUMIDITY', '2': 2},
    {'1': 'GRAPH_METRIC_AIRFLOW', '2': 3},
    {'1': 'GRAPH_METRIC_ENERGY', '2': 4},
    {'1': 'GRAPH_METRIC_CO2', '2': 5},
  ],
};

/// Descriptor for `GraphMetric`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List graphMetricDescriptor = $convert.base64Decode(
    'CgtHcmFwaE1ldHJpYxIcChhHUkFQSF9NRVRSSUNfVU5TUEVDSUZJRUQQABIcChhHUkFQSF9NRV'
    'RSSUNfVEVNUEVSQVRVUkUQARIZChVHUkFQSF9NRVRSSUNfSFVNSURJVFkQAhIYChRHUkFQSF9N'
    'RVRSSUNfQUlSRkxPVxADEhcKE0dSQVBIX01FVFJJQ19FTkVSR1kQBBIUChBHUkFQSF9NRVRSSU'
    'NfQ08yEAU=');

@$core.Deprecated('Use airQualityDescriptor instead')
const AirQuality$json = {
  '1': 'AirQuality',
  '2': [
    {'1': 'AIR_QUALITY_UNSPECIFIED', '2': 0},
    {'1': 'AIR_QUALITY_EXCELLENT', '2': 1},
    {'1': 'AIR_QUALITY_GOOD', '2': 2},
    {'1': 'AIR_QUALITY_FAIR', '2': 3},
    {'1': 'AIR_QUALITY_POOR', '2': 4},
  ],
};

/// Descriptor for `AirQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List airQualityDescriptor = $convert.base64Decode(
    'CgpBaXJRdWFsaXR5EhsKF0FJUl9RVUFMSVRZX1VOU1BFQ0lGSUVEEAASGQoVQUlSX1FVQUxJVF'
    'lfRVhDRUxMRU5UEAESFAoQQUlSX1FVQUxJVFlfR09PRBACEhQKEEFJUl9RVUFMSVRZX0ZBSVIQ'
    'AxIUChBBSVJfUVVBTElUWV9QT09SEAQ=');

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor =
    $convert.base64Decode('CgVFbXB0eQ==');

@$core.Deprecated('Use alertDescriptor instead')
const Alert$json = {
  '1': 'Alert',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.breez.AlertType',
      '10': 'type',
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'timestamp',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp',
    },
  ],
};

/// Descriptor for `Alert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alertDescriptor = $convert.base64Decode(
    'CgVBbGVydBIkCgR0eXBlGAEgASgOMhAuYnJlZXouQWxlcnRUeXBlUgR0eXBlEhgKB21lc3NhZ2'
    'UYAiABKAlSB21lc3NhZ2USOAoJdGltZXN0YW1wGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIJdGltZXN0YW1w');
