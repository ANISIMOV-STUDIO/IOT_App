/// Talker logging configuration
library;

import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Уровень логирования приложения
enum AppLogLevel {
  /// Только ошибки
  error,
  /// Ошибки и предупреждения
  warning,
  /// Всё кроме debug (HTTP запросы/ответы, WebSocket)
  info,
  /// Все логи включая verbose (stream data, debug)
  verbose,
}

class TalkerConfig {
  /// Текущий уровень логирования
  /// Изменить для фильтрации логов при дебаге:
  /// - error: только ошибки
  /// - warning: ошибки + предупреждения
  /// - info: + HTTP запросы/ответы, WebSocket connect
  /// - verbose: + stream data, debug messages
  static AppLogLevel logLevel = AppLogLevel.warning;

  static final Talker instance = TalkerFlutter.init(
    settings: TalkerSettings(
      // Логи включены всегда, но в production без console output
      enabled: true,
      // Console logs только в debug mode
      useConsoleLogs: kDebugMode,
      // В production храним меньше истории для экономии памяти
      maxHistoryItems: kDebugMode ? 1000 : 100,
    ),
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(
        enableColors: kDebugMode,
        lineSymbol: '─',
      ),
      formatter: const ColoredLoggerFormatter(),
    ),
  );

  static Talker get talker => instance;

  /// Проверка можно ли логировать на данном уровне
  static bool canLog(AppLogLevel level) {
    return level.index <= logLevel.index;
  }
}
