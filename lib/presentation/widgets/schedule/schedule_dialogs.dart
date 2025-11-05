/// Schedule-related dialogs with web-friendly interactions
///
/// Provides accessible confirmation and input dialogs for schedule management
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Accessible confirmation dialog with web-friendly hover states
class ScheduleConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;

  const ScheduleConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.confirmColor,
  });

  /// Shows delete confirmation dialog
  static Future<bool> showDeleteConfirmation(
    BuildContext context, {
    required String scheduleName,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => ScheduleConfirmDialog(
            title: 'Delete Schedule?',
            message: 'Are you sure you want to delete "$scheduleName"?',
            confirmLabel: 'Delete',
            cancelLabel: 'Cancel',
            confirmColor: HvacColors.error,
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HvacColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Semantics(
        header: true,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14.0,
          color: HvacColors.textSecondary,
        ),
      ),
      actions: [
        // Cancel button with hover effect for web
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelLabel,
              style: const TextStyle(
                fontSize: 14.0,
                color: HvacColors.textSecondary,
              ),
            ),
          ),
        ),
        // Confirm button with hover effect for web
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmLabel,
              style: TextStyle(
                fontSize: 14.0,
                color: confirmColor ?? HvacColors.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}