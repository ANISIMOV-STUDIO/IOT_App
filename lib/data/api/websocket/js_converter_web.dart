/// Web implementation using dart:js_interop for deep conversion
///
/// На Web платформе данные из SignalR приходят как JavaScript объекты.
/// dart:js_interop.dartify() рекурсивно конвертирует их в Dart типы.
// ignore_for_file: avoid_web_libraries_in_flutter
library;

import 'dart:js_interop';

/// Конвертирует данные из SignalR в Map<String, dynamic>
///
/// Использует dart:js_interop dartify() для глубокой рекурсивной конвертации
/// JavaScript объектов в Dart типы (включая вложенные Map и List).
Map<String, dynamic>? convertSignalRData(Object? data) {
  if (data == null) {
    return null;
  }

  // Если уже Dart Map — всё равно применяем глубокую конвертацию,
  // т.к. вложенные объекты могут быть JS объектами или Map<Object?, Object?>
  if (data is Map) {
    return _deepConvertMap(data);
  }

  // Конвертируем JS объект через dart:js_interop
  try {
    final jsAny = data as JSAny?;
    final dartified = jsAny.dartify();

    // dartify() конвертирует top-level, но вложенные объекты могут
    // остаться JS объектами или Map<Object?, Object?>
    // Поэтому ВСЕГДА применяем глубокую конвертацию
    if (dartified is Map) {
      return _deepConvertMap(dartified);
    }
  } catch (_) {
    // Fallback если не удалось конвертировать
  }

  return null;
}

/// Глубокая конвертация любого Map в Map<String, dynamic>
Map<String, dynamic> _deepConvertMap(Map<dynamic, dynamic> source) =>
    source.map((key, value) => MapEntry(
          key?.toString() ?? '',
          _convertValue(value),
        ));

/// Рекурсивная конвертация значений
dynamic _convertValue(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is Map) {
    return _deepConvertMap(value);
  }

  if (value is List) {
    return value.map(_convertValue).toList();
  }

  // Если значение всё ещё JS объект - конвертируем через dartify
  try {
    final jsAny = value as JSAny?;
    if (jsAny != null) {
      final dartified = jsAny.dartify();
      if (dartified is Map) {
        return _deepConvertMap(dartified);
      }
      if (dartified is List) {
        return dartified.map(_convertValue).toList();
      }
      return dartified;
    }
  } catch (_) {
    // Не JS объект - возвращаем как есть
  }

  return value;
}
