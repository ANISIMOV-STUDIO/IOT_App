/// Stub implementation for non-web platforms
///
/// На мобильных платформах данные уже приходят как Dart типы,
/// поэтому глубокая конвертация не требуется.
library;

/// Конвертирует данные из SignalR в Map<String, dynamic>
///
/// На мобильных платформах просто приводит тип без дополнительной обработки.
Map<String, dynamic>? convertSignalRData(Object? data) {
  if (data == null) {
    return null;
  }

  if (data is Map<String, dynamic>) {
    return data;
  }

  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }

  return null;
}
