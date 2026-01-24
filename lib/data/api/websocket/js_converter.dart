/// Platform-aware SignalR data converter
///
/// Использует условный импорт для выбора реализации:
/// - Web: dart:js_util.dartify() для глубокой конвертации JS объектов
/// - Mobile: прямое приведение типов (данные уже Dart типы)
library;

export 'js_converter_stub.dart'
    if (dart.library.js_util) 'js_converter_web.dart';
