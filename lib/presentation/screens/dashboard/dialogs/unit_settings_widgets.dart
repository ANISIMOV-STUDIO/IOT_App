/// Unit Settings Widgets - Reusable components for unit settings dialog
library;

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_dialog_button.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_list_card.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _DeleteDialogConstants {
  static const double maxWidth = 360;
}

// =============================================================================
// DELETE CONFIRMATION DIALOG
// =============================================================================

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
    final maxWidth = min(
      MediaQuery.of(context).size.width - AppSpacing.xxl,
      _DeleteDialogConstants.maxWidth,
    );

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        side: BorderSide(color: colors.border),
      ),
      child: Container(
        width: maxWidth,
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            BreezSectionHeader.dialog(
              title: l10n.unitSettingsDeleteConfirm,
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.accentRed,
              onClose: () => Navigator.of(context).pop(false),
              closeLabel: l10n.cancel,
            ),
            const SizedBox(height: AppSpacing.xs),

            // Warning message
            Text(
              l10n.unitSettingsDeleteMessage(unitName),
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Delete button
            BreezDialogButton(
              label: l10n.unitSettingsDelete,
              icon: Icons.delete_outline,
              isDanger: true,
              onTap: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
  }
}
