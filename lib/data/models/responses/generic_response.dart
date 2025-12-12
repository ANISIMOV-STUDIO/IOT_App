import 'package:json_annotation/json_annotation.dart';

part 'generic_response.g.dart';

@JsonSerializable()
class GenericResponse {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;

  GenericResponse({this.success, this.message, this.data});

  factory GenericResponse.fromJson(Map<String, dynamic> json) =>
      _$GenericResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GenericResponseToJson(this);
}

@JsonSerializable()
class DiagnosticsResponse {
  final String? status;
  final double? temperature;
  final double? humidity;
  @JsonKey(name: 'fan_speed')
  final int? fanSpeed;
  @JsonKey(name: 'filter_status')
  final String? filterStatus;
  @JsonKey(name: 'error_codes')
  final List<String>? errorCodes;
  @JsonKey(name: 'uptime_hours')
  final int? uptimeHours;

  DiagnosticsResponse({
    this.status,
    this.temperature,
    this.humidity,
    this.fanSpeed,
    this.filterStatus,
    this.errorCodes,
    this.uptimeHours,
  });

  factory DiagnosticsResponse.fromJson(Map<String, dynamic> json) =>
      _$DiagnosticsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DiagnosticsResponseToJson(this);
}
