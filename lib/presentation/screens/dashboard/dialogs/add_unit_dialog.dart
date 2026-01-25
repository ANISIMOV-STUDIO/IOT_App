/// Add Unit Dialog - Dialog for registering HVAC device by MAC address
library;

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/constants/auth_constants.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _DialogConstants {
  static const double closeButtonPadding = 6;
}

// =============================================================================
// RESULT CLASS
// =============================================================================

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

    // Адаптивная ширина: максимум как форма регистрации
    final maxWidth = min(MediaQuery.of(context).size.width - 48, AuthConstants.formMaxWidth);

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        side: BorderSide(color: colors.border),
      ),
      child: Container(
        width: maxWidth,
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(l10n),
              const SizedBox(height: AppSpacing.xs),
              _buildMacField(l10n),
              const SizedBox(height: AppSpacing.xs),
              _buildNameField(l10n),
              const SizedBox(height: AppSpacing.xs),
              _buildHelpText(colors, l10n),
              const SizedBox(height: AppSpacing.xs),
              _buildActions(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final colors = BreezColors.of(context);

    return BreezSectionHeader(
      icon: Icons.router,
      title: l10n.addUnit,
      iconColor: colors.accent,
      trailing: BreezButton(
        onTap: () => Navigator.of(context).pop(),
        enforceMinTouchTarget: false,
        showBorder: false,
        backgroundColor: colors.buttonBg.withValues(alpha: AppColors.opacityMedium),
        hoverColor: colors.text.withValues(alpha: AppColors.opacitySubtle),
        padding: const EdgeInsets.all(_DialogConstants.closeButtonPadding),
        semanticLabel: 'Закрыть',
        child: Icon(
          Icons.close,
          size: AppIconSizes.standard,
          color: colors.textMuted,
        ),
      ),
    );
  }

  Widget _buildMacField(AppLocalizations l10n) => BreezTextField(
      controller: _macController,
      label: l10n.deviceMacAddress,
      hint: 'AA:BB:CC:DD:EE:FF',
      prefixIcon: Icons.router,
      validator: (value) => _validateMacAddress(value, l10n),
      validateOnChange: true,
      textInputAction: TextInputAction.next,
    );

  Widget _buildNameField(AppLocalizations l10n) => BreezTextField(
      controller: _nameController,
      label: l10n.deviceName,
      hint: 'Например: ПВ-1',
      prefixIcon: Icons.label_outline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.enterDeviceName;
        }
        return null;
      },
      validateOnChange: true,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submit(),
    );

  Widget _buildHelpText(BreezColors colors, AppLocalizations l10n) => Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: AppIconSizes.standard,
            color: colors.textMuted,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              l10n.macAddressDisplayedOnRemote,
              style: TextStyle(
                fontSize: AppFontSizes.captionSmall,
                color: colors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );

  Widget _buildActions(AppLocalizations l10n) {
    final colors = BreezColors.of(context);
    return BreezButton(
      onTap: _submit,
      backgroundColor: colors.accent,
      hoverColor: colors.accentLight,
      showBorder: false,
      borderRadius: AppRadius.nested,
      padding: const EdgeInsets.all(AppSpacing.xs),
      enableGlow: true,
      semanticLabel: l10n.addButton,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add, size: AppSpacing.md, color: AppColors.black),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            l10n.addButton,
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
