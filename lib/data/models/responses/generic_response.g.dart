// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericResponse _$GenericResponseFromJson(Map<String, dynamic> json) =>
    GenericResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$GenericResponseToJson(GenericResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

DiagnosticsResponse _$DiagnosticsResponseFromJson(Map<String, dynamic> json) =>
    DiagnosticsResponse(
      status: json['status'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      fanSpeed: (json['fan_speed'] as num?)?.toInt(),
      filterStatus: json['filter_status'] as String?,
      errorCodes: (json['error_codes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      uptimeHours: (json['uptime_hours'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DiagnosticsResponseToJson(
  DiagnosticsResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'temperature': instance.temperature,
  'humidity': instance.humidity,
  'fan_speed': instance.fanSpeed,
  'filter_status': instance.filterStatus,
  'error_codes': instance.errorCodes,
  'uptime_hours': instance.uptimeHours,
};
