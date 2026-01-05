// This is a generated file - do not edit.
//
// Generated from occupant.proto.

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

@$core.Deprecated('Use occupantDescriptor instead')
const Occupant$json = {
  '1': 'Occupant',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'avatar_url', '3': 3, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'is_home', '3': 4, '4': 1, '5': 8, '10': 'isHome'},
    {
      '1': 'last_seen',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastSeen'
    },
    {'1': 'device_ids', '3': 6, '4': 3, '5': 9, '10': 'deviceIds'},
  ],
};

/// Descriptor for `Occupant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List occupantDescriptor = $convert.base64Decode(
    'CghPY2N1cGFudBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIdCgphdmF0YX'
    'JfdXJsGAMgASgJUglhdmF0YXJVcmwSFwoHaXNfaG9tZRgEIAEoCFIGaXNIb21lEjcKCWxhc3Rf'
    'c2VlbhgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGxhc3RTZWVuEh0KCmRldm'
    'ljZV9pZHMYBiADKAlSCWRldmljZUlkcw==');

@$core.Deprecated('Use getOccupantsRequestDescriptor instead')
const GetOccupantsRequest$json = {
  '1': 'GetOccupantsRequest',
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

/// Descriptor for `GetOccupantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOccupantsRequestDescriptor = $convert.base64Decode(
    'ChNHZXRPY2N1cGFudHNSZXF1ZXN0EiAKCWRldmljZV9pZBgBIAEoCUgAUghkZXZpY2VJZIgBAU'
    'IMCgpfZGV2aWNlX2lk');

@$core.Deprecated('Use listOccupantsResponseDescriptor instead')
const ListOccupantsResponse$json = {
  '1': 'ListOccupantsResponse',
  '2': [
    {
      '1': 'occupants',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.breez.Occupant',
      '10': 'occupants'
    },
    {'1': 'home_count', '3': 2, '4': 1, '5': 5, '10': 'homeCount'},
  ],
};

/// Descriptor for `ListOccupantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOccupantsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0T2NjdXBhbnRzUmVzcG9uc2USLQoJb2NjdXBhbnRzGAEgAygLMg8uYnJlZXouT2NjdX'
    'BhbnRSCW9jY3VwYW50cxIdCgpob21lX2NvdW50GAIgASgFUglob21lQ291bnQ=');

@$core.Deprecated('Use createOccupantRequestDescriptor instead')
const CreateOccupantRequest$json = {
  '1': 'CreateOccupantRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'avatar_url',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'avatarUrl',
      '17': true
    },
    {'1': 'device_ids', '3': 3, '4': 3, '5': 9, '10': 'deviceIds'},
  ],
  '8': [
    {'1': '_avatar_url'},
  ],
};

/// Descriptor for `CreateOccupantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createOccupantRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVPY2N1cGFudFJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIiCgphdmF0YXJfdX'
    'JsGAIgASgJSABSCWF2YXRhclVybIgBARIdCgpkZXZpY2VfaWRzGAMgAygJUglkZXZpY2VJZHNC'
    'DQoLX2F2YXRhcl91cmw=');

@$core.Deprecated('Use updateOccupantRequestDescriptor instead')
const UpdateOccupantRequest$json = {
  '1': 'UpdateOccupantRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
    {
      '1': 'avatar_url',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'avatarUrl',
      '17': true
    },
    {
      '1': 'is_home',
      '3': 4,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'isHome',
      '17': true
    },
    {'1': 'device_ids', '3': 5, '4': 3, '5': 9, '10': 'deviceIds'},
  ],
  '8': [
    {'1': '_name'},
    {'1': '_avatar_url'},
    {'1': '_is_home'},
  ],
};

/// Descriptor for `UpdateOccupantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateOccupantRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVPY2N1cGFudFJlcXVlc3QSDgoCaWQYASABKAlSAmlkEhcKBG5hbWUYAiABKAlIAF'
    'IEbmFtZYgBARIiCgphdmF0YXJfdXJsGAMgASgJSAFSCWF2YXRhclVybIgBARIcCgdpc19ob21l'
    'GAQgASgISAJSBmlzSG9tZYgBARIdCgpkZXZpY2VfaWRzGAUgAygJUglkZXZpY2VJZHNCBwoFX2'
    '5hbWVCDQoLX2F2YXRhcl91cmxCCgoIX2lzX2hvbWU=');

@$core.Deprecated('Use deleteOccupantRequestDescriptor instead')
const DeleteOccupantRequest$json = {
  '1': 'DeleteOccupantRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteOccupantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteOccupantRequestDescriptor = $convert
    .base64Decode('ChVEZWxldGVPY2N1cGFudFJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use updatePresenceRequestDescriptor instead')
const UpdatePresenceRequest$json = {
  '1': 'UpdatePresenceRequest',
  '2': [
    {'1': 'occupant_id', '3': 1, '4': 1, '5': 9, '10': 'occupantId'},
    {'1': 'is_home', '3': 2, '4': 1, '5': 8, '10': 'isHome'},
  ],
};

/// Descriptor for `UpdatePresenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePresenceRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQcmVzZW5jZVJlcXVlc3QSHwoLb2NjdXBhbnRfaWQYASABKAlSCm9jY3VwYW50SW'
    'QSFwoHaXNfaG9tZRgCIAEoCFIGaXNIb21l');
