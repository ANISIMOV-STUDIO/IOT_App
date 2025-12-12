import 'package:json_annotation/json_annotation.dart';

part 'pair_device_request.g.dart';

@JsonSerializable()
class PairDeviceRequest {
  @JsonKey(name: 'device_id')
  final String deviceId;
  @JsonKey(name: 'wifi_ssid')
  final String wifiSsid;
  @JsonKey(name: 'wifi_password')
  final String wifiPassword;

  PairDeviceRequest({
    required this.deviceId,
    required this.wifiSsid,
    required this.wifiPassword,
  });

  factory PairDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$PairDeviceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PairDeviceRequestToJson(this);
}
