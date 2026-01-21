/// Unit Settings Widgets - Reusable components for unit settings dialog
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

/// Delete confirmation dialog
class DeleteConfirmDialog extends StatelessWidget {

  const DeleteConfirmDialog({required this.unitName, super.key});
  final String unitName;

  /// Shows the dialog and returns true if confirmed
  static Future<bool?> show(BuildContext context, String unitName) => showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmDialog(unitName: unitName),
    );

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
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              l10n.unitSettingsDeleteConfirm,
              style: TextStyle(fontSize: AppFontSizes.h4, color: colors.text),
            ),
          ),
        ],
      ),
      content: Text(
        l10n.unitSettingsDeleteMessage(unitName),
        style: TextStyle(fontSize: AppFontSizes.bodySmall, color: colors.textMuted),
      ),
      actions: [
        BreezButton(
          onTap: () => Navigator.of(context).pop(false),
          backgroundColor: Colors.transparent,
          hoverColor: colors.cardLight,
          pressedColor: colors.buttonBg,
          showBorder: false,
          semanticLabel: l10n.cancel,
          child: Text(l10n.cancel, style: TextStyle(color: colors.textMuted)),
        ),
        const SizedBox(width: AppSpacing.sm),
        BreezButton(
          onTap: () => Navigator.of(context).pop(true),
          backgroundColor: AppColors.accentRed.withValues(alpha: 0.1),
          hoverColor: AppColors.accentRed.withValues(alpha: 0.2),
          border: Border.all(color: AppColors.accentRed.withValues(alpha: 0.3)),
          semanticLabel: l10n.unitSettingsDelete,
          child: Text(
            l10n.unitSettingsDelete,
            style: const TextStyle(
              color: AppColors.accentRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
