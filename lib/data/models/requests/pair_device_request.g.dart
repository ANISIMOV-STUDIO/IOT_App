// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_device_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PairDeviceRequest _$PairDeviceRequestFromJson(Map<String, dynamic> json) =>
    PairDeviceRequest(
      deviceId: json['device_id'] as String,
      wifiSsid: json['wifi_ssid'] as String,
      wifiPassword: json['wifi_password'] as String,
    );

Map<String, dynamic> _$PairDeviceRequestToJson(PairDeviceRequest instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'wifi_ssid': instance.wifiSsid,
      'wifi_password': instance.wifiPassword,
    };
