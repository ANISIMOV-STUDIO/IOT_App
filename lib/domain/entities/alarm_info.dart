import 'package:equatable/equatable.dart';

/// Информация об аварии
class AlarmInfo extends Equatable {
  final int code;
  final String description;

  const AlarmInfo({
    required this.code,
    required this.description,
  });

  factory AlarmInfo.fromJson(Map<String, dynamic> json) {
    return AlarmInfo(
      code: json['code'] as int? ?? 0,
      description: json['description'] as String? ?? 'Неизвестная авария',
    );
  }

  @override
  List<Object?> get props => [code, description];
}

/// История аварии
class AlarmHistory extends Equatable {
  final String id;
  final int alarmCode;
  final String description;
  final DateTime occurredAt;
  final bool isCleared;
  final DateTime? clearedAt;

  const AlarmHistory({
    required this.id,
    required this.alarmCode,
    required this.description,
    required this.occurredAt,
    this.isCleared = false,
    this.clearedAt,
  });

  factory AlarmHistory.fromJson(Map<String, dynamic> json) {
    return AlarmHistory(
      id: json['id']?.toString() ?? '',
      alarmCode: json['alarmCode'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      occurredAt: _parseDateTime(json['occurredAt']) ?? DateTime.now(),
      isCleared: json['isCleared'] as bool? ?? false,
      clearedAt: _parseDateTime(json['clearedAt']),
    );
  }

  /// Парсинг даты: поддержка String (ISO) и int (Unix timestamp)
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    return null;
  }

  @override
  List<Object?> get props => [id, alarmCode, description, occurredAt, isCleared, clearedAt];
}
