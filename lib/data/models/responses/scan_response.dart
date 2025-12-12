import 'package:json_annotation/json_annotation.dart';

part 'scan_response.g.dart';

@JsonSerializable()
class ScanResponse {
  final List<ScannedDevice> devices;

  ScanResponse({required this.devices});

  factory ScanResponse.fromJson(Map<String, dynamic> json) =>
      _$ScanResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ScanResponseToJson(this);
}

@JsonSerializable()
class ScannedDevice {
  @JsonKey(name: 'mac_address')
  final String macAddress;
  final String? name;
  final String? model;
  @JsonKey(name: 'signal_strength')
  final int? signalStrength;

  ScannedDevice({
    required this.macAddress,
    this.name,
    this.model,
    this.signalStrength,
  });

  factory ScannedDevice.fromJson(Map<String, dynamic> json) =>
      _$ScannedDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$ScannedDeviceToJson(this);
}
