/// Unit Settings Dialog - Dialog for device settings (rename, delete, info)
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../domain/entities/unit_state.dart';

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
            _buildHeader(colors),
            const SizedBox(height: 24),
            _buildDeviceInfo(colors),
            const SizedBox(height: 16),
            if (_isRenaming)
              _buildRenameField(colors)
            else
              _buildActions(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BreezColors colors) {
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
              'Настройки установки',
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

  Widget _buildDeviceInfo(BreezColors colors) {
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
                'Название:',
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
                'Статус:',
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
                  widget.unit.power ? 'Включено' : 'Выключено',
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

  Widget _buildRenameField(BreezColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Новое название',
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
            hintText: 'Введите название',
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
            _ActionButton(
              label: 'Отмена',
              colors: colors,
              onTap: () => setState(() => _isRenaming = false),
            ),
            const SizedBox(width: 12),
            _ActionButton(
              label: 'Сохранить',
              isPrimary: true,
              colors: colors,
              onTap: _submitRename,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BreezColors colors) {
    return Column(
      children: [
        // Rename button
        _SettingsButton(
          icon: Icons.edit_outlined,
          label: 'Переименовать',
          subtitle: 'Изменить название установки',
          colors: colors,
          onTap: () => setState(() => _isRenaming = true),
        ),
        const SizedBox(height: 12),
        // Delete button
        _SettingsButton(
          icon: Icons.delete_outline,
          label: 'Удалить установку',
          subtitle: 'Отвязать устройство от аккаунта',
          colors: colors,
          isDanger: true,
          onTap: _confirmDelete,
        ),
      ],
    );
  }
}

/// Settings action button
class _SettingsButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDanger;
  final BreezColors colors;

  const _SettingsButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.colors,
    this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppColors.accentRed : colors.text;
    final bgColor = isDanger
        ? AppColors.accentRed.withValues(alpha: 0.1)
        : colors.cardLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        hoverColor: isDanger
            ? AppColors.accentRed.withValues(alpha: 0.15)
            : colors.border.withValues(alpha: 0.3),
        splashColor: isDanger
            ? AppColors.accentRed.withValues(alpha: 0.2)
            : AppColors.accent.withValues(alpha: 0.1),
        highlightColor: isDanger
            ? AppColors.accentRed.withValues(alpha: 0.1)
            : AppColors.accent.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDanger
                  ? AppColors.accentRed.withValues(alpha: 0.3)
                  : colors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: colors.textMuted,
              ),
            ],
          ),
        ),
      ),
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
            'Удалить установку?',
            style: TextStyle(color: colors.text),
          ),
        ],
      ),
      content: Text(
        'Установка "$unitName" будет отвязана от вашего аккаунта. '
        'Вы сможете снова добавить её по MAC-адресу.',
        style: TextStyle(color: colors.textMuted),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Отмена',
            style: TextStyle(color: colors.textMuted),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            backgroundColor: AppColors.accentRed.withValues(alpha: 0.1),
          ),
          child: const Text(
            'Удалить',
            style: TextStyle(color: AppColors.accentRed),
          ),
        ),
      ],
    );
  }
}

/// Action button for dialog
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final BreezColors colors;

  const _ActionButton({
    required this.label,
    required this.colors,
    this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        hoverColor: isPrimary
            ? AppColors.accentLight
            : colors.text.withValues(alpha: 0.05),
        splashColor: isPrimary
            ? AppColors.accent.withValues(alpha: 0.3)
            : AppColors.accent.withValues(alpha: 0.1),
        highlightColor: isPrimary
            ? AppColors.accent.withValues(alpha: 0.2)
            : AppColors.accent.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: isPrimary ? null : Border.all(color: colors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
              color: isPrimary ? Colors.white : colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
