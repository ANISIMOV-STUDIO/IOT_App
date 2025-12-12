// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResponse _$ScanResponseFromJson(Map<String, dynamic> json) => ScanResponse(
  devices: (json['devices'] as List<dynamic>)
      .map((e) => ScannedDevice.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ScanResponseToJson(ScanResponse instance) =>
    <String, dynamic>{'devices': instance.devices};

ScannedDevice _$ScannedDeviceFromJson(Map<String, dynamic> json) =>
    ScannedDevice(
      macAddress: json['mac_address'] as String,
      name: json['name'] as String?,
      model: json['model'] as String?,
      signalStrength: (json['signal_strength'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScannedDeviceToJson(ScannedDevice instance) =>
    <String, dynamic>{
      'mac_address': instance.macAddress,
      'name': instance.name,
      'model': instance.model,
      'signal_strength': instance.signalStrength,
    };
