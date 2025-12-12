// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceResponse _$DeviceResponseFromJson(Map<String, dynamic> json) =>
    DeviceResponse(
      id: json['id'] as String,
      macAddress: json['mac_address'] as String?,
      name: json['name'] as String,
      location: json['location'] as String?,
      model: json['model'] as String?,
      firmware: json['firmware'] as String?,
      isOnline: json['is_online'] as bool?,
    );

Map<String, dynamic> _$DeviceResponseToJson(DeviceResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mac_address': instance.macAddress,
      'name': instance.name,
      'location': instance.location,
      'model': instance.model,
      'firmware': instance.firmware,
      'is_online': instance.isOnline,
    };
