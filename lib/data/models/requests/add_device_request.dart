import 'package:json_annotation/json_annotation.dart';

part 'add_device_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AddDeviceRequest {
  final String name;
  @JsonKey(name: 'mac_address')
  final String macAddress;
  final String? location;

  AddDeviceRequest({
    required this.name,
    required this.macAddress,
    this.location,
  });

  factory AddDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$AddDeviceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddDeviceRequestToJson(this);
}
