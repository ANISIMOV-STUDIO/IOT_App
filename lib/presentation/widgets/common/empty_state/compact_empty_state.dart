/// Compact Empty State
///
/// Smaller empty state widget for limited spaces
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Compact empty state for smaller spaces
class CompactEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;

  const CompactEmptyState({
    super.key,
    required this.message,
    required this.icon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: message,
      hint: onAction != null ? 'Double tap to take action' : null,
      child: InkWell(
        onTap: onAction,
        borderRadius: BorderRadius.circular(HvacSpacing.md),
        child: Container(
          padding: const EdgeInsets.all(HvacSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: ResponsiveUtils.scaledIconSize(context, 48),
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              const SizedBox(height: HvacSpacing.sm),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: ResponsiveUtils.scaledFontSize(context, 14),
                ),
                textAlign: TextAlign.center,
              ),
              if (onAction != null) ...[
                const SizedBox(height: HvacSpacing.sm),
                Icon(
                  Icons.refresh_rounded,
                  size: ResponsiveUtils.scaledIconSize(context, 20),
                  color: theme.colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
