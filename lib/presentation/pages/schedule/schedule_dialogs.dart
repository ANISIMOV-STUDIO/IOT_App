/// Schedule screen dialogs and snackbars
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Helper class for schedule screen dialogs and notifications
class ScheduleDialogs {
  ScheduleDialogs._();

  /// Show success snackbar after saving schedule
  static void showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20.0),
            SizedBox(width: HvacSpacing.xs),
            Text('Расписание успешно сохранено'),
          ],
        ),
        backgroundColor: HvacColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.sm),
        ),
      ),
    );
  }

  /// Show error snackbar when save fails
  static void showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20.0),
            const SizedBox(width: HvacSpacing.xs),
            Expanded(child: Text('Ошибка сохранения: $error')),
          ],
        ),
        backgroundColor: HvacColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.sm),
        ),
        action: SnackBarAction(
          label: 'Повторить',
          textColor: Colors.white,
          onPressed: () {
            // Retry logic can be added here
          },
        ),
      ),
    );
  }

  /// Show dialog for unsaved changes
  static Future<bool?> showUnsavedChangesDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _UnsavedChangesDialog(),
    );
  }
}

/// Dialog widget for unsaved changes confirmation
class _UnsavedChangesDialog extends StatefulWidget {
  @override
  State<_UnsavedChangesDialog> createState() => _UnsavedChangesDialogState();
}

class _UnsavedChangesDialogState extends State<_UnsavedChangesDialog> {
  bool _cancelHovered = false;
  bool _discardHovered = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HvacColors.backgroundCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HvacRadius.md),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: HvacColors.warning,
            size: 24.0,
          ),
          SizedBox(width: HvacSpacing.sm),
          Text(
            'Несохранённые изменения',
            style: TextStyle(
              color: HvacColors.textPrimary,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
      content: const Text(
        'У вас есть несохранённые изменения. Выйти без сохранения?',
        style: TextStyle(
          color: HvacColors.textSecondary,
          fontSize: 14.0,
        ),
      ),
      actions: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _cancelHovered = true),
          onExit: (_) => setState(() => _cancelHovered = false),
          child: TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              backgroundColor: _cancelHovered
                  ? HvacColors.primaryOrange.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: _cancelHovered
                    ? HvacColors.primaryOrange
                    : HvacColors.textSecondary,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _discardHovered = true),
          onExit: (_) => setState(() => _discardHovered = false),
          child: TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: _discardHovered
                  ? HvacColors.error.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Text(
              'Выйти',
              style: TextStyle(
                color: _discardHovered
                    ? HvacColors.error.withValues(alpha: 0.8)
                    : HvacColors.error,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}