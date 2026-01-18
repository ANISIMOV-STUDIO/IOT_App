/// Talker logging configuration
library;

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

    ),
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(

      ),
      formatter: const ColoredLoggerFormatter(),
    ),
  );

  static Talker get talker => instance;

  /// Проверка можно ли логировать на данном уровне
  static bool canLog(AppLogLevel level) => level.index <= logLevel.index;
}
