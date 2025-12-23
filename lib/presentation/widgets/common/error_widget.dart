/// Error Widget components
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Error display widget using shadcn alert
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadAlert.destructive(
              title: const Text('Error'),
              description: Text(message),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ShadButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
