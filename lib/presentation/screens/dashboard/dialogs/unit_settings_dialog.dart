/// Unit Settings Dialog - Dialog for device settings (rename, delete, info)
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez_card.dart';

/// Действия доступные в диалоге настроек
enum UnitSettingsAction {
  rename,
  delete,
}

/// Результат диалога настроек
class UnitSettingsResult {
  final UnitSettingsAction action;
  final String? newName; // Для rename

  const UnitSettingsResult({
    required this.action,
    this.newName,
  });
}

/// Dialog for device settings
class UnitSettingsDialog extends StatefulWidget {
  final UnitState unit;

  const UnitSettingsDialog({
    super.key,
    required this.unit,
  });

  /// Shows the dialog and returns result if action taken
  static Future<UnitSettingsResult?> show(BuildContext context, UnitState unit) {
    return showDialog<UnitSettingsResult>(
      context: context,
      builder: (context) => UnitSettingsDialog(unit: unit),
    );
  }

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

  void _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _DeleteConfirmDialog(unitName: widget.unit.name),
    );

    if (confirmed == true && mounted) {
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

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        side: BorderSide(color: colors.border),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colors, l10n),
            const SizedBox(height: 24),
            _buildDeviceInfo(colors, l10n),
            const SizedBox(height: 16),
            if (_isRenaming)
              _buildRenameField(colors, l10n)
            else
              _buildActions(colors, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BreezColors colors, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.settings_outlined,
              size: 20,
              color: colors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.unitSettingsTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.text,
              ),
            ),
          ],
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(AppRadius.button),
            hoverColor: colors.buttonBg,
            splashColor: AppColors.accent.withValues(alpha: 0.1),
            highlightColor: AppColors.accent.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 20,
                color: colors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceInfo(BreezColors colors, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Название
          Row(
            children: [
              Icon(Icons.label_outline, size: 16, color: colors.textMuted),
              const SizedBox(width: 8),
              Text(
                l10n.unitSettingsName,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.unit.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // ID
          Row(
            children: [
              Icon(Icons.tag, size: 16, color: colors.textMuted),
              const SizedBox(width: 8),
              Text(
                'ID:',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.unit.id,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'monospace',
                    color: colors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Статус
          Row(
            children: [
              Icon(
                widget.unit.power ? Icons.power : Icons.power_off,
                size: 16,
                color: widget.unit.power ? AppColors.accentGreen : colors.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.unitSettingsStatus,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.unit.power
                      ? AppColors.accentGreen.withValues(alpha: 0.15)
                      : colors.text.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.indicator),
                ),
                child: Text(
                  widget.unit.power ? l10n.statusEnabled : l10n.statusDisabled,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: widget.unit.power ? AppColors.accentGreen : colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRenameField(BreezColors colors, AppLocalizations l10n) {
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
          controller: _nameController,
          autofocus: true,
          style: TextStyle(color: colors.text),
          inputFormatters: [
            LengthLimitingTextInputFormatter(50),
          ],
          decoration: InputDecoration(
            hintText: l10n.unitSettingsEnterName,
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.bg,
            prefixIcon: Icon(Icons.edit, color: colors.textMuted, size: 20),
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
          onFieldSubmitted: (_) => _submitRename(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BreezDialogButton(
              label: l10n.cancel,
              onTap: () => setState(() => _isRenaming = false),
            ),
            const SizedBox(width: 12),
            BreezDialogButton(
              label: l10n.save,
              isPrimary: true,
              onTap: _submitRename,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BreezColors colors, AppLocalizations l10n) {
    return Column(
      children: [
        // Rename button
        BreezSettingsButton(
          icon: Icons.edit_outlined,
          label: l10n.unitSettingsRename,
          subtitle: l10n.unitSettingsRenameSubtitle,
          onTap: () => setState(() => _isRenaming = true),
        ),
        const SizedBox(height: 12),
        // Delete button
        BreezSettingsButton(
          icon: Icons.delete_outline,
          label: l10n.unitSettingsDelete,
          subtitle: l10n.unitSettingsDeleteSubtitle,
          isDanger: true,
          onTap: _confirmDelete,
        ),
      ],
    );
  }
}

/// Delete confirmation dialog
class _DeleteConfirmDialog extends StatelessWidget {
  final String unitName;

  const _DeleteConfirmDialog({required this.unitName});

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
