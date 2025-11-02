/// Alert Entity
///
/// System alert/error from ventilation unit
library;

import 'package:equatable/equatable.dart';

class Alert extends Equatable {
  final int code; // Код аварии/ошибки (0 = нет аварии)
  final DateTime? timestamp; // Время фиксации (null = не зафиксировано)
  final String description; // Описание ошибки
  final AlertSeverity severity; // Уровень критичности

  const Alert({
    required this.code,
    this.timestamp,
    required this.description,
    this.severity = AlertSeverity.warning,
  });

  /// Create a copy with updated fields
  Alert copyWith({
    int? code,
    DateTime? timestamp,
    String? description,
    AlertSeverity? severity,
  }) {
    return Alert(
      code: code ?? this.code,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      severity: severity ?? this.severity,
    );
  }

  /// Check if this is an active alert
  bool get isActive => code != 0;

  /// Empty alert (no error)
  static const Alert empty = Alert(
    code: 0,
    timestamp: null,
    description: 'Нет аварий',
    severity: AlertSeverity.info,
  );

  @override
  List<Object?> get props => [code, timestamp, description, severity];

  @override
  String toString() {
    return 'Alert(code: $code, desc: $description, severity: $severity, time: $timestamp)';
  }

  /// Get alert code descriptions (based on typical ventilation error codes)
  static String getDescription(int code) {
    switch (code) {
      case 0:
        return 'Нет аварий';
      case 1:
        return 'Ошибка датчика температуры притока';
      case 2:
        return 'Ошибка датчика температуры вытяжки';
      case 3:
        return 'Перегрев нагревателя';
      case 4:
        return 'Блокировка приточного вентилятора';
      case 5:
        return 'Блокировка вытяжного вентилятора';
      case 6:
        return 'Ошибка связи с контроллером';
      case 7:
        return 'Низкая температура теплоносителя';
      case 8:
        return 'Заморозка теплообменника';
      case 9:
        return 'Загрязнение фильтра (требуется замена)';
      case 10:
        return 'Ошибка датчика давления';
      case 11:
        return 'Аварийное отключение по защите';
      case 12:
        return 'Ошибка конфигурации';
      default:
        return 'Неизвестная ошибка (код $code)';
    }
  }

  /// Get alert severity based on code
  static AlertSeverity getSeverity(int code) {
    if (code == 0) return AlertSeverity.info;
    if (code <= 2) return AlertSeverity.warning;
    if (code <= 7) return AlertSeverity.error;
    return AlertSeverity.critical;
  }
}

/// Alert Severity Level
enum AlertSeverity {
  info, // Информационное сообщение
  warning, // Предупреждение
  error, // Ошибка
  critical, // Критическая ошибка
}

extension AlertSeverityExtension on AlertSeverity {
  String get displayName {
    switch (this) {
      case AlertSeverity.info:
        return 'Информация';
      case AlertSeverity.warning:
        return 'Предупреждение';
      case AlertSeverity.error:
        return 'Ошибка';
      case AlertSeverity.critical:
        return 'Критическая ошибка';
    }
  }
}
