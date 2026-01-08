/// Unit Settings Widgets - Reusable components for unit settings dialog
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez_card.dart';

/// Device info card showing name, ID, and status
class DeviceInfoCard extends StatelessWidget {
  final UnitState unit;

  const DeviceInfoCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.label_outline,
            label: l10n.unitSettingsName,
            value: unit.name,
            isBold: true,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.tag,
            label: 'ID:',
            value: unit.id,
            isMonospace: true,
          ),
          const SizedBox(height: 12),
          _StatusRow(
            isOn: unit.power,
            onLabel: l10n.statusEnabled,
            offLabel: l10n.statusDisabled,
            statusLabel: l10n.unitSettingsStatus,
          ),
        ],
      ),
    );
  }
}

/// Row showing device info with icon
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;
  final bool isMonospace;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
    this.isMonospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Row(
      children: [
        Icon(icon, size: 16, color: colors.textMuted),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colors.textMuted),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isMonospace ? 13 : 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              fontFamily: isMonospace ? 'monospace' : null,
              color: colors.text,
            ),
          ),
        ),
      ],
    );
  }
}

/// Row showing device power status
class _StatusRow extends StatelessWidget {
  final bool isOn;
  final String onLabel;
  final String offLabel;
  final String statusLabel;

  const _StatusRow({
    required this.isOn,
    required this.onLabel,
    required this.offLabel,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Row(
      children: [
        Icon(
          isOn ? Icons.power : Icons.power_off,
          size: 16,
          color: isOn ? AppColors.accentGreen : colors.textMuted,
        ),
        const SizedBox(width: 8),
        Text(
          statusLabel,
          style: TextStyle(fontSize: 12, color: colors.textMuted),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isOn
                ? AppColors.accentGreen.withValues(alpha: 0.15)
                : colors.text.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.indicator),
          ),
          child: Text(
            isOn ? onLabel : offLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isOn ? AppColors.accentGreen : colors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

/// Rename input field with action buttons
class RenameField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const RenameField({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.unitSettingsNewName,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: colors.text),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          maxLength: 50,
          decoration: InputDecoration(
            hintText: l10n.unitSettingsEnterName,
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.bg,
            prefixIcon: Icon(Icons.edit, color: colors.textMuted, size: 20),
            counterText: '', // Скрываем счётчик символов
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onFieldSubmitted: (_) => onSave(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BreezDialogButton(
              label: l10n.cancel,
              onTap: onCancel,
            ),
            const SizedBox(width: 12),
            BreezDialogButton(
              label: l10n.save,
              isPrimary: true,
              onTap: onSave,
            ),
          ],
        ),
      ],
    );
  }
}

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
          Text(
            l10n.unitSettingsDeleteConfirm,
            style: TextStyle(color: colors.text),
          ),
        ],
      ),
      content: Text(
        l10n.unitSettingsDeleteMessage(unitName),
        style: TextStyle(color: colors.textMuted),
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
