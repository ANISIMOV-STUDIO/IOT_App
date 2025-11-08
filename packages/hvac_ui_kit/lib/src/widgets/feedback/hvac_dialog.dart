/// Dialog System
/// Provides Material 3 dialogs with HVAC theming
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/typography.dart';

/// HVAC-themed alert dialog
class HvacAlertDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;
  final bool dismissible;

  const HvacAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.actions,
    this.icon,
    this.iconColor,
    this.dismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HvacColors.backgroundCard,
      shape: RoundedRectangleBorder(
        borderRadius: HvacRadius.mdRadius,
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? HvacColors.primaryOrange,
              size: 24,
            ),
            const SizedBox(width: HvacSpacing.sm),
          ],
          Expanded(
            child: Text(
              title,
              style: HvacTypography.h3.copyWith(
                color: HvacColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: contentWidget ??
          (content != null
              ? Text(
                  content!,
                  style: HvacTypography.bodyMedium.copyWith(
                    color: HvacColors.textSecondary,
                  ),
                )
              : null),
      actions: actions ??
          [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: HvacTypography.bodyMedium.copyWith(
                  color: HvacColors.primaryOrange,
                ),
              ),
            ),
          ],
    );
  }

  /// Show alert dialog
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? content,
    Widget? contentWidget,
    List<Widget>? actions,
    IconData? icon,
    Color? iconColor,
    bool dismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => HvacAlertDialog(
        title: title,
        content: content,
        contentWidget: contentWidget,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
        dismissible: dismissible,
      ),
    );
  }
}

/// Confirmation dialog with Yes/No buttons
class HvacConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final Color? confirmColor;
  final IconData? icon;
  final bool dangerous;

  const HvacConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.confirmColor,
    this.icon,
    this.dangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HvacColors.backgroundCard,
      shape: RoundedRectangleBorder(
        borderRadius: HvacRadius.mdRadius,
      ),
      title: Row(
        children: [
          Icon(
            icon ?? (dangerous ? Icons.warning_rounded : Icons.help_outline),
            color: dangerous ? HvacColors.error : HvacColors.primaryOrange,
            size: 24,
          ),
          const SizedBox(width: HvacSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: HvacTypography.h3.copyWith(
                color: HvacColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: HvacTypography.bodyMedium.copyWith(
          color: HvacColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelText ?? 'Cancel',
            style: HvacTypography.bodyMedium.copyWith(
              color: HvacColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            confirmText ?? (dangerous ? 'Delete' : 'Confirm'),
            style: HvacTypography.bodyMedium.copyWith(
              color: confirmColor ??
                  (dangerous ? HvacColors.error : HvacColors.primaryOrange),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Show confirmation dialog
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    IconData? icon,
    bool dangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => HvacConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        icon: icon,
        dangerous: dangerous,
      ),
    );
  }
}
