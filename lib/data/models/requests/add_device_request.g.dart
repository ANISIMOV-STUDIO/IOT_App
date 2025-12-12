// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_device_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddDeviceRequest _$AddDeviceRequestFromJson(Map<String, dynamic> json) =>
    AddDeviceRequest(
      name: json['name'] as String,
      macAddress: json['mac_address'] as String,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$AddDeviceRequestToJson(AddDeviceRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mac_address': instance.macAddress,
      'location': ?instance.location,
    };
