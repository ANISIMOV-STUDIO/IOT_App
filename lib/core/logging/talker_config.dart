/// Talker logging configuration
library;

import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerConfig {
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
}
