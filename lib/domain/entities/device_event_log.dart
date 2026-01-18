/// Device Event Log Entity
///
/// Лог событий устройства (изменения настроек и аварии).
/// Immutable записи для отображения в таблице сервисным инженерам.
library;

import 'package:equatable/equatable.dart';

/// Тип события
enum DeviceEventType {
  /// Изменение настроек
  settingsChange,
  /// Авария
  alarm,
}

/// Запись лога события устройства
class DeviceEventLog extends Equatable {

  const DeviceEventLog({
    required this.id,
    required this.eventType,
    required this.category,
    required this.property,
    required this.newValue,
    required this.description,
    required this.serverTimestamp,
    this.oldValue,
    this.deviceTimestamp,
  });

  /// Создать из JSON
  factory DeviceEventLog.fromJson(Map<String, dynamic> json) => DeviceEventLog(
      id: json['id'] as String,
      eventType: _parseEventType(json['eventType'] as String),
      category: json['category'] as String,
      property: json['property'] as String,
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String,
      description: json['description'] as String,
      deviceTimestamp: json['deviceTimestamp'] != null
          ? DateTime.parse(json['deviceTimestamp'] as String)
          : null,
      serverTimestamp: DateTime.parse(json['serverTimestamp'] as String),
    );
  /// Уникальный идентификатор
  final String id;

  /// Тип события (SettingsChange, Alarm)
  final DeviceEventType eventType;

  /// Категория события (mode, timer, alarm)
  final String category;

  /// Свойство, которое изменилось (например: "basic/supply_fan")
  final String property;

  /// Старое значение (до изменения), null для алармов
  final String? oldValue;

  /// Новое значение
  final String newValue;

  /// Человекочитаемое описание события
  final String description;

  /// Время на устройстве (если доступно)
  final DateTime? deviceTimestamp;

  /// Время сервера (UTC)
  final DateTime serverTimestamp;

  static DeviceEventType _parseEventType(String type) => switch (type.toLowerCase()) {
      'settingschange' => DeviceEventType.settingsChange,
      'alarm' => DeviceEventType.alarm,
      _ => DeviceEventType.settingsChange,
    };

  @override
  List<Object?> get props => [
        id,
        eventType,
        category,
        property,
        oldValue,
        newValue,
        description,
        deviceTimestamp,
        serverTimestamp,
      ];
}

/// Результат с пагинацией для логов
class PaginatedLogs extends Equatable {

  const PaginatedLogs({
    required this.items,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  /// Создать из JSON
  factory PaginatedLogs.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>;
    return PaginatedLogs(
      items: itemsList
          .map((e) => DeviceEventLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int,
      limit: json['limit'] as int,
      offset: json['offset'] as int,
    );
  }
  final List<DeviceEventLog> items;
  final int totalCount;
  final int limit;
  final int offset;

  /// Есть ли ещё страницы
  bool get hasMore => offset + items.length < totalCount;

  /// Номер текущей страницы (начиная с 1)
  int get currentPage => (offset ~/ limit) + 1;

  /// Всего страниц
  int get totalPages => (totalCount / limit).ceil();

  @override
  List<Object?> get props => [items, totalCount, limit, offset];
}
