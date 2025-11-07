/// Empty State Widget for HVAC UI Kit
///
/// Professional empty state with:
/// - Adaptive layouts (mobile/tablet/desktop)
/// - Customizable icon and messages
/// - Optional action button
/// - Corporate blue theme
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../buttons/hvac_primary_button.dart';

/// Size variant for empty state
enum EmptyStateSize {
  compact,  // For small containers
  medium,   // Default
  large,    // For full screen
}

/// Empty state component
///
/// Usage:
/// ```dart
/// HvacEmptyState(
///   icon: Icons.inbox_outlined,
///   title: 'No devices',
///   message: 'Add your first device to get started',
///   actionLabel: 'Add Device',
///   onAction: () => _addDevice(),
/// )
/// ```
class HvacEmptyState extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Title text (optional)
  final String? title;

  /// Message text
  final String message;

  /// Action button label (optional)
  final String? actionLabel;

  /// Action callback
  final VoidCallback? onAction;

  /// Display as full screen (with Scaffold)
  final bool isFullScreen;

  /// Size variant
  final EmptyStateSize size;

  /// Custom icon color
  final Color? iconColor;

  const HvacEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.isFullScreen = false,
    this.size = EmptyStateSize.medium,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    if (isFullScreen) {
      return Scaffold(
        backgroundColor: HvacColors.backgroundDark,
        body: Center(child: content),
      );
    }

    return Center(child: content);
  }

  Widget _buildContent(BuildContext context) {
    final iconSize = _getIconSize();
    final spacing = _getSpacing();
    final effectiveIconColor = iconColor ?? HvacColors.textTertiary;

    return Padding(
      padding: EdgeInsets.all(spacing.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            icon,
            size: iconSize,
            color: effectiveIconColor,
          ),
          SizedBox(height: spacing.titleGap),

          // Title (optional)
          if (title != null) ...[
            Text(
              title!,
              style: _getTitleStyle(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.messageGap),
          ],

          // Message
          Text(
            message,
            style: _getMessageStyle(context),
            textAlign: TextAlign.center,
            maxLines: size == EmptyStateSize.compact ? 2 : null,
            overflow: size == EmptyStateSize.compact
                ? TextOverflow.ellipsis
                : null,
          ),

          // Action button (optional)
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: spacing.buttonGap),
            HvacPrimaryButton(
              label: actionLabel!,
              onPressed: onAction,
              size: size == EmptyStateSize.compact
                  ? HvacButtonSize.small
                  : HvacButtonSize.medium,
            ),
          ],
        ],
      ),
    );
  }

  _SizeConfig _getSpacing() {
    switch (size) {
      case EmptyStateSize.compact:
        return _SizeConfig(
          padding: HvacSpacing.md,
          titleGap: HvacSpacing.sm,
          messageGap: HvacSpacing.xs,
          buttonGap: HvacSpacing.md,
        );
      case EmptyStateSize.medium:
        return _SizeConfig(
          padding: HvacSpacing.xl,
          titleGap: HvacSpacing.md,
          messageGap: HvacSpacing.sm,
          buttonGap: HvacSpacing.xl,
        );
      case EmptyStateSize.large:
        return _SizeConfig(
          padding: HvacSpacing.xxl,
          titleGap: HvacSpacing.lg,
          messageGap: HvacSpacing.md,
          buttonGap: HvacSpacing.xxl,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case EmptyStateSize.compact:
        return 48.0;
      case EmptyStateSize.medium:
        return 64.0;
      case EmptyStateSize.large:
        return 80.0;
    }
  }

  TextStyle _getTitleStyle(BuildContext context) {
    switch (size) {
      case EmptyStateSize.compact:
        return HvacTypography.h4.copyWith(color: HvacColors.textPrimary);
      case EmptyStateSize.medium:
        return HvacTypography.h3.copyWith(color: HvacColors.textPrimary);
      case EmptyStateSize.large:
        return HvacTypography.h2.copyWith(color: HvacColors.textPrimary);
    }
  }

  TextStyle _getMessageStyle(BuildContext context) {
    switch (size) {
      case EmptyStateSize.compact:
        return HvacTypography.bodySmall.copyWith(color: HvacColors.textSecondary);
      case EmptyStateSize.medium:
        return HvacTypography.bodyMedium.copyWith(color: HvacColors.textSecondary);
      case EmptyStateSize.large:
        return HvacTypography.bodyLarge.copyWith(color: HvacColors.textSecondary);
    }
  }
}

class _SizeConfig {
  final double padding;
  final double titleGap;
  final double messageGap;
  final double buttonGap;

  _SizeConfig({
    required this.padding,
    required this.titleGap,
    required this.messageGap,
    required this.buttonGap,
  });
}
