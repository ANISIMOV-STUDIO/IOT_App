/// Debug Logs Page
///
/// Displays application logs using TalkerScreen (DEBUG MODE ONLY)
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../core/services/talker_service.dart';

/// Debug Logs Page - Only available in debug mode
class DebugLogsPage extends StatelessWidget {
  const DebugLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Only allow in debug mode
    if (!kDebugMode) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Debug Logs'),
        ),
        body: const Center(
          child: Text(
            'Debug logs are only available in debug mode',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return TalkerScreen(
      talker: talker,
      appBarTitle: 'BREEZ Home - Debug Logs',
      theme: TalkerScreenTheme(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        cardColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
      ),
    );
  }
}
