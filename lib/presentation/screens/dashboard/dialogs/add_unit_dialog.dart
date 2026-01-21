/// Add Unit Dialog - Dialog for registering HVAC device by MAC address
library;

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart'; // BreezDialogButton, BreezIconButton

/// Результат диалога добавления устройства
class AddUnitResult {

  const AddUnitResult({
    required this.macAddress,
    required this.name,
  });
  final String macAddress;
  final String name;
}

/// Dialog for registering a new HVAC device by MAC address
class AddUnitDialog extends StatefulWidget {
  const AddUnitDialog({super.key});

  /// Shows the dialog and returns MAC address and name if created
  static Future<AddUnitResult?> show(BuildContext context) => showDialog<AddUnitResult>(
      context: context,
      builder: (context) => const AddUnitDialog(),
    );

  @override
  State<AddUnitDialog> createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends State<AddUnitDialog> {
  final _macController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _macController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(AddUnitResult(
        macAddress: _macController.text.trim().toUpperCase(),
        name: _nameController.text.trim(),
      ));
    }
  }

  String? _validateMacAddress(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.enterMacAddress;
    }

    // Убираем разделители и приводим к верхнему регистру
    final cleaned = value.replaceAll(RegExp(r'[:\-\s]'), '').toUpperCase();

    // MAC-адрес должен содержать 12 hex символов
    if (cleaned.length != 12) {
      return l10n.macAddressMustContain12Chars;
    }

    if (!RegExp(r'^[0-9A-F]+$').hasMatch(cleaned)) {
      return l10n.macAddressOnlyHex;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Адаптивная ширина: максимум 420, но не больше экра минус отступы
    final maxWidth = min(MediaQuery.of(context).size.width - 48, 420).toDouble();

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        side: BorderSide(color: colors.border),
      ),
      child: Container(
        width: maxWidth,
        padding: const EdgeInsets.all(AppSpacing.lgx),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(colors, l10n),
              const SizedBox(height: AppSpacing.lgx),
              _buildMacField(colors, l10n),
              const SizedBox(height: AppSpacing.md),
              _buildNameField(colors, l10n),
              const SizedBox(height: AppSpacing.xs),
              _buildHelpText(colors, l10n),
              const SizedBox(height: AppSpacing.lgx),
              _buildActions(colors, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BreezColors colors, AppLocalizations l10n) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.addUnit,
          style: TextStyle(
            fontSize: AppFontSizes.h3,
            fontWeight: FontWeight.w700,
            color: colors.text,
          ),
        ),
        BreezIconButton(
          icon: Icons.close,
          onTap: () => Navigator.of(context).pop(),
          size: 32,
          showBorder: false,
        ),
      ],
    );

  Widget _buildMacField(BreezColors colors, AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.deviceMacAddress,
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: _macController,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f:\-\s]')),
            LengthLimitingTextInputFormatter(17), // XX:XX:XX:XX:XX:XX
          ],
          style: TextStyle(
            color: colors.text,
            fontFamily: 'monospace',
            fontSize: AppFontSizes.h4,
            letterSpacing: 1.5,
          ),
          decoration: InputDecoration(
            hintText: 'AA:BB:CC:DD:EE:FF',
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.bg,
            prefixIcon: Icon(Icons.router, color: colors.textMuted, size: 20),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: const BorderSide(color: AppColors.accentRed),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) => _validateMacAddress(value, l10n),
        ),
      ],
    );

  Widget _buildNameField(BreezColors colors, AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.deviceName,
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: _nameController,
          style: TextStyle(color: colors.text),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          maxLength: 50,
          decoration: InputDecoration(
            hintText: l10n.deviceNameExample,
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.bg,
            prefixIcon: Icon(Icons.label_outline, color: colors.textMuted, size: 20),
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
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.enterDeviceName;
            }
            return null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
      ],
    );

  Widget _buildHelpText(BreezColors colors, AppLocalizations l10n) => Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.cardLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: colors.textMuted),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              l10n.macAddressDisplayedOnRemote,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                color: colors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );

  Widget _buildActions(BreezColors colors, AppLocalizations l10n) => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Cancel button
        BreezDialogButton(
          label: l10n.cancelButton,
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Create button
        BreezDialogButton(
          label: l10n.addButton,
          isPrimary: true,
          onTap: _submit,
        ),
      ],
    );
}
