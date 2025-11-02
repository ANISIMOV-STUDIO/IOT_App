/// Empty State Widget
/// Displays when there's no data to show
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';

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
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64.sp,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (title != null) ...[
            Text(
              title!,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: AppSpacing.xl),
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
      backgroundColor: AppTheme.backgroundDark,
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
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48.sp,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
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
