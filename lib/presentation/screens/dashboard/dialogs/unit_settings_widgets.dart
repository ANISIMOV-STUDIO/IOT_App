/// Unit Settings Widgets - Reusable components for unit settings dialog
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';

/// Delete confirmation dialog
class DeleteConfirmDialog extends StatelessWidget {
  final String unitName;

  const DeleteConfirmDialog({super.key, required this.unitName});

  /// Shows the dialog and returns true if confirmed
  static Future<bool?> show(BuildContext context, String unitName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmDialog(unitName: unitName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        side: BorderSide(color: colors.border),
      ),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.accentRed),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.unitSettingsDeleteConfirm,
              style: TextStyle(fontSize: 16, color: colors.text),
            ),
          ),
        ],
      ),
      content: Text(
        l10n.unitSettingsDeleteMessage(unitName),
        style: TextStyle(fontSize: 13, color: colors.textMuted),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: colors.textMuted),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            backgroundColor: AppColors.accentRed.withValues(alpha: 0.1),
          ),
          child: Text(
            l10n.unitSettingsDelete,
            style: const TextStyle(color: AppColors.accentRed),
          ),
        ),
      ],
    );
  }
}
