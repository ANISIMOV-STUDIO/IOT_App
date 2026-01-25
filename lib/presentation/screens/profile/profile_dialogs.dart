/// Profile Dialogs - Dialogs used in profile screen
library;

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/constants/auth_constants.dart';
import 'package:hvac_control/core/services/language_service.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/core/utils/validators.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';

/// Language option widget for language picker dialog
class LanguageOption extends StatelessWidget {

  const LanguageOption({
    required this.language, required this.isSelected, required this.onTap, super.key,
  });
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTap,
      backgroundColor: isSelected
          ? colors.accent.withValues(alpha: 0.1)
          : colors.cardLight,
      hoverColor: isSelected
          ? colors.accent.withValues(alpha: 0.15)
          : colors.card,
      border: isSelected
          ? Border.all(color: colors.accent.withValues(alpha: 0.3))
          : null,
      padding: const EdgeInsets.all(AppSpacing.sm),
      semanticLabel: '${language.nativeName}${isSelected ? ' (выбран)' : ''}',
      child: Row(
        children: [
          Text(
            language.flag,
            style: const TextStyle(
              fontSize: AppFontSizes.h3,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              language.nativeName,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? colors.accent : colors.text,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: colors.accent,
              size: AppIconSizes.standard,
            ),
        ],
      ),
    );
  }
}

/// Edit profile dialog
class EditProfileDialog extends StatefulWidget {

  const EditProfileDialog({
    required this.firstName, required this.lastName, required this.onSave, super.key,
  });
  final String firstName;
  final String lastName;
  final void Function(String firstName, String lastName) onSave;

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final maxWidth = min(
      MediaQuery.of(context).size.width - AppSpacing.xxl,
      AuthConstants.formMaxWidth,
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BreezSectionHeader.dialog(
                title: l10n.editProfile,
                icon: Icons.edit,
                onClose: () => Navigator.of(context).pop(),
                closeLabel: l10n.close,
              ),
              const SizedBox(height: AppSpacing.xs),
              BreezTextField(
                controller: _firstNameController,
                label: l10n.firstName,
                prefixIcon: Icons.person_outlined,
                validator: (v) =>
                    Validators.of(context).name(v, fieldName: l10n.firstName),
                validateOnChange: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.xs),
              BreezTextField(
                controller: _lastNameController,
                label: l10n.lastName,
                prefixIcon: Icons.person_outlined,
                validator: (v) =>
                    Validators.of(context).name(v, fieldName: l10n.lastName),
                validateOnChange: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: AppSpacing.xs),
              BreezButton(
                onTap: _save,
                backgroundColor: colors.accent,
                hoverColor: colors.accentLight,
                showBorder: false,
                borderRadius: AppRadius.nested,
                padding: const EdgeInsets.all(AppSpacing.xs),
                enableGlow: true,
                semanticLabel: l10n.save,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save_outlined, size: AppSpacing.md, color: AppColors.black),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      l10n.save,
                      style: const TextStyle(
                        fontSize: AppFontSizes.caption,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

/// Change password dialog
class ChangePasswordDialog extends StatefulWidget {

  const ChangePasswordDialog({required this.onSave, super.key});
  final void Function(String currentPassword, String newPassword) onSave;

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        _currentPasswordController.text,
        _newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final maxWidth = min(
      MediaQuery.of(context).size.width - AppSpacing.xxl,
      AuthConstants.formMaxWidth,
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BreezSectionHeader.dialog(
                title: l10n.changePassword,
                icon: Icons.lock,
                onClose: () => Navigator.of(context).pop(),
                closeLabel: l10n.close,
              ),
              const SizedBox(height: AppSpacing.xs),
              BreezTextField(
                controller: _currentPasswordController,
                label: l10n.currentPassword,
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: Validators.of(context).loginPassword,
                validateOnChange: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.xs),
              BreezTextField(
                controller: _newPasswordController,
                label: l10n.newPassword,
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: Validators.of(context).password,
                validateOnChange: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.xs),
              BreezTextField(
                controller: _confirmPasswordController,
                label: l10n.passwordConfirmation,
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: (value) => Validators.of(
                  context,
                ).confirmPassword(value, _newPasswordController.text),
                validateOnChange: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: AppSpacing.xs),
              BreezButton(
                onTap: _save,
                backgroundColor: colors.accent,
                hoverColor: colors.accentLight,
                showBorder: false,
                borderRadius: AppRadius.nested,
                padding: const EdgeInsets.all(AppSpacing.xs),
                enableGlow: true,
                semanticLabel: l10n.change,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_reset, size: AppSpacing.md, color: AppColors.black),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      l10n.change,
                      style: const TextStyle(
                        fontSize: AppFontSizes.caption,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows language picker dialog
Future<void> showLanguagePickerDialog(
  BuildContext context,
  LanguageService languageService,
) async {
  final colors = BreezColors.of(context);
  final l10n = AppLocalizations.of(context)!;
  final maxWidth = min(
    MediaQuery.of(context).size.width - AppSpacing.xxl,
    AuthConstants.formMaxWidth,
  );

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
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
          children: [
            BreezSectionHeader.dialog(
              title: l10n.language,
              icon: Icons.language,
              onClose: () => Navigator.of(dialogContext).pop(),
              closeLabel: l10n.close,
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final language in languageService.availableLanguages) ...[
              LanguageOption(
                language: language,
                isSelected: languageService.currentLanguage == language,
                onTap: () {
                  languageService.setLanguage(language);
                  Navigator.of(dialogContext).pop();
                },
              ),
              if (language != languageService.availableLanguages.last)
                const SizedBox(height: AppSpacing.xs),
            ],
          ],
        ),
      ),
    ),
  );
}
