/// Talker logging configuration
library;

import 'package:talker_flutter/talker_flutter.dart';

class TalkerConfig {
  static final Talker instance = TalkerFlutter.init(
    settings: TalkerSettings(
      enabled: true,
      useConsoleLogs: true,
      maxHistoryItems: 1000,
    ),
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(
        enableColors: true,
        lineSymbol: '─',
      ),
      formatter: const ColoredLoggerFormatter(),
    ),
  );

  static Talker get talker => instance;
}
