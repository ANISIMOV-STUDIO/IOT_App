import 'package:json_annotation/json_annotation.dart';

part 'device_response.g.dart';

@JsonSerializable()
class DeviceResponse {
  final String id;
  @JsonKey(name: 'mac_address')
  final String? macAddress;
  final String name;
  final String? location;
  final String? model;
  final String? firmware;
  @JsonKey(name: 'is_online')
  final bool? isOnline;

  DeviceResponse({
    required this.id,
    this.macAddress,
    required this.name,
    this.location,
    this.model,
    this.firmware,
    this.isOnline,
  });

  factory DeviceResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceResponseToJson(this);
}
