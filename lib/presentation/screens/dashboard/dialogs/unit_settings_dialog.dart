/// Диалог настроек устройства (переименование, удаление)
library;

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/screens/dashboard/dialogs/unit_settings_widgets.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_dialog_button.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_list_card.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_time_picker.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _DialogConstants {
  static const double maxWidth = 360;
  static const double statusBadgeVerticalPadding = 2;
}

// =============================================================================
// TYPES
// =============================================================================

/// Действия доступные в диалоге настроек
enum UnitSettingsAction { rename, delete, setTime }

/// Результат диалога настроек
class UnitSettingsResult {

  const UnitSettingsResult({
    required this.action,
    this.newName,
    this.time,
  });
  final UnitSettingsAction action;
  final String? newName;
  final DateTime? time;
}

// =============================================================================
// MAIN DIALOG
// =============================================================================

/// Диалог настроек устройства
class UnitSettingsDialog extends StatefulWidget {

  const UnitSettingsDialog({required this.unit, super.key});
  final UnitState unit;

  /// Показать диалог и вернуть результат
  static Future<UnitSettingsResult?> show(BuildContext context, UnitState unit) => showDialog<UnitSettingsResult>(
      context: context,
      builder: (context) => UnitSettingsDialog(unit: unit),
    );

  @override
  State<UnitSettingsDialog> createState() => _UnitSettingsDialogState();
}

class _UnitSettingsDialogState extends State<UnitSettingsDialog> {
  final _nameController = TextEditingController();
  bool _isRenaming = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.unit.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await DeleteConfirmDialog.show(context, widget.unit.name);

    if ((confirmed ?? false) && mounted) {
      Navigator.of(context).pop(const UnitSettingsResult(
        action: UnitSettingsAction.delete,
      ));
    }
  }

  void _submitRename() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty || newName == widget.unit.name) {
      setState(() => _isRenaming = false);
      return;
    }

    Navigator.of(context).pop(UnitSettingsResult(
      action: UnitSettingsAction.rename,
      newName: newName,
    ));
  }

  Future<void> _setTime() async {
    final now = DateTime.now();
    final selectedDateTime = await showBreezDateTimePicker(
      context: context,
      initialDateTime: now,
    );

    if (selectedDateTime != null && mounted) {
      Navigator.of(context).pop(UnitSettingsResult(
        action: UnitSettingsAction.setTime,
        time: selectedDateTime,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final maxWidth = min(
      MediaQuery.of(context).size.width - AppSpacing.xxl,
      _DialogConstants.maxWidth,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            BreezSectionHeader.dialog(
              title: l10n.unitSettingsTitle,
              icon: Icons.settings_outlined,
              onClose: () => Navigator.of(context).pop(),
              closeLabel: l10n.close,
            ),
            const SizedBox(height: AppSpacing.xs),

            // Device info
            _CompactDeviceInfo(unit: widget.unit),

            const SizedBox(height: AppSpacing.xs),

            // Actions or rename field
            if (_isRenaming)
              _CompactRenameField(
                controller: _nameController,
                onCancel: () => setState(() => _isRenaming = false),
                onSave: _submitRename,
              )
            else
              _CompactActions(
                onRename: () => setState(() => _isRenaming = true),
                onDelete: _confirmDelete,
                onSetTime: _setTime,
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// Компактная информация об устройстве
class _CompactDeviceInfo extends StatelessWidget {

  const _CompactDeviceInfo({required this.unit});
  final UnitState unit;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.cardLight,
        borderRadius: BorderRadius.circular(AppRadius.nested),
      ),
      child: Column(
        children: [
          // Name row
          _InfoRow(
            icon: Icons.label_outline,
            label: l10n.unitSettingsName,
            value: unit.name,
            isBold: true,
          ),
          const SizedBox(height: AppSpacing.xs),
          // MAC and Status in one row
          Row(
            children: [
              Icon(Icons.router_outlined, size: AppIconSizes.standard, color: colors.textMuted),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(
                child: Text(
                  unit.macAddress.isNotEmpty ? unit.macAddress : unit.id,
                  style: TextStyle(
                    fontSize: AppFontSizes.captionSmall,
                    fontFamily: 'monospace',
                    color: colors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: _DialogConstants.statusBadgeVerticalPadding,
                ),
                decoration: BoxDecoration(
                  color: unit.power
                      ? AppColors.accentGreen.withValues(alpha: 0.15)
                      : colors.buttonBg.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.indicator),
                ),
                child: Text(
                  unit.power ? l10n.statusEnabled : l10n.statusDisabled,
                  style: TextStyle(
                    fontSize: AppFontSizes.captionSmall,
                    fontWeight: FontWeight.w600,
                    color: unit.power ? AppColors.accentGreen : colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Строка информации
class _InfoRow extends StatelessWidget {

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Row(
      children: [
        Icon(icon, size: AppIconSizes.standard, color: colors.textMuted),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: TextStyle(fontSize: AppFontSizes.captionSmall, color: colors.textMuted),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: colors.text,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Компактные кнопки действий
class _CompactActions extends StatelessWidget {

  const _CompactActions({
    required this.onRename,
    required this.onDelete,
    required this.onSetTime,
  });
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onSetTime;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BreezDialogButton(
                icon: Icons.edit_outlined,
                label: l10n.unitSettingsRename,
                onTap: onRename,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: BreezDialogButton(
                icon: Icons.delete_outline,
                label: l10n.unitSettingsDelete,
                onTap: onDelete,
                isDanger: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        BreezDialogButton(
          icon: Icons.access_time,
          label: l10n.unitSettingsSetTime,
          onTap: onSetTime,
        ),
      ],
    );
  }
}

/// Компактное поле переименования
class _CompactRenameField extends StatelessWidget {

  const _CompactRenameField({
    required this.controller,
    required this.onCancel,
    required this.onSave,
  });
  final TextEditingController controller;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input field
        TextFormField(
          controller: controller,
          autofocus: true,
          style: TextStyle(fontSize: AppFontSizes.bodySmall, color: colors.text),
          decoration: InputDecoration(
            hintText: l10n.unitSettingsEnterName,
            hintStyle: TextStyle(fontSize: AppFontSizes.bodySmall, color: colors.textMuted),
            filled: true,
            fillColor: colors.cardLight,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.nested),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.nested),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
          ),
          onFieldSubmitted: (_) => onSave(),
        ),
        const SizedBox(height: AppSpacing.xs),
        // Buttons
        Row(
          children: [
            Expanded(
              child: BreezDialogButton(
                icon: Icons.close,
                label: l10n.cancel,
                onTap: onCancel,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: BreezDialogButton(
                icon: Icons.check,
                label: l10n.save,
                onTap: onSave,
                isPrimary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
