/// Error State Widget
/// Displays error message with retry option
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final bool isFullScreen;
  final IconData icon;

  const ErrorState({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.isFullScreen = true,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(HvacSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64.0,
            color: HvacColors.error,
          ),
          const SizedBox(height: HvacSpacing.lg),
          if (title != null) ...[
            Text(
              title!,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HvacSpacing.sm),
          ],
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: HvacSpacing.xl),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HvacColors.primaryOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: HvacSpacing.xl,
                  vertical: HvacSpacing.md,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (!isFullScreen) {
      return Center(child: content);
    }

    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      body: Center(child: content),
    );
  }
}

class ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorCard({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: HvacSpacing.cardPadding,
      decoration: HvacTheme.roundedCard(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48.0,
            color: HvacColors.error,
          ),
          const SizedBox(height: HvacSpacing.md),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: HvacSpacing.md),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
