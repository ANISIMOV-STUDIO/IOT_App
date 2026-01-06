/// Unit Settings Dialog - Dialog for device settings (rename, delete, info)
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez_card.dart';
import 'unit_settings_widgets.dart';

/// Действия доступные в диалоге настроек
enum UnitSettingsAction { rename, delete }

/// Результат диалога настроек
class UnitSettingsResult {
  final UnitSettingsAction action;
  final String? newName;

  const UnitSettingsResult({required this.action, this.newName});
}

/// Dialog for device settings
class UnitSettingsDialog extends StatefulWidget {
  final UnitState unit;

  const UnitSettingsDialog({super.key, required this.unit});

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
    final confirmed = await DeleteConfirmDialog.show(context, widget.unit.name);

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
            DeviceInfoCard(unit: widget.unit),
            const SizedBox(height: 16),
            if (_isRenaming)
              RenameField(
                controller: _nameController,
                onCancel: () => setState(() => _isRenaming = false),
                onSave: _submitRename,
              )
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
            Icon(Icons.settings_outlined, size: 20, color: colors.textMuted),
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
        BreezIconButton(
          icon: Icons.close,
          onTap: () => Navigator.of(context).pop(),
          size: 32,
          showBorder: false,
        ),
      ],
    );
  }

  Widget _buildActions(BreezColors colors, AppLocalizations l10n) {
    return Column(
      children: [
        BreezSettingsButton(
          icon: Icons.edit_outlined,
          label: l10n.unitSettingsRename,
          subtitle: l10n.unitSettingsRenameSubtitle,
          onTap: () => setState(() => _isRenaming = true),
        ),
        const SizedBox(height: 12),
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
