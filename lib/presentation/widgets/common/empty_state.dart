/// Empty State Widget
/// Displays when there's no data to show
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool isFullScreen;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.title,
    this.onAction,
    this.actionLabel,
    this.isFullScreen = true,
    this.icon = Icons.inbox_outlined,
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
            size: 64.sp,
            color: HvacColors.textTertiary,
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
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: HvacSpacing.xl),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
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

class EmptyListState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyListState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HvacSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48.sp,
              color: HvacColors.textTertiary,
            ),
            const SizedBox(height: HvacSpacing.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
