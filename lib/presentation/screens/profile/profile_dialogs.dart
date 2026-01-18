/// Profile Dialogs - Dialogs used in profile screen
library;

import 'dart:math' show min;

import 'package:flutter/material.dart';
import '../../../core/services/language_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../widgets/breez/breez.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _ProfileDialogsConstants {
  static const double flagFontSize = 20.0;
  static const double bodyFontSize = AppFontSizes.body;
  static const double headerFontSize = AppFontSizes.h3;
  static const double checkIconSize = 18.0;
}

/// Language option widget for language picker dialog
class LanguageOption extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOption({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTap,
      backgroundColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.1)
          : colors.cardLight,
      hoverColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.15)
          : colors.card,
      borderRadius: AppRadius.button,
      border: isSelected
          ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
          : null,
      padding: const EdgeInsets.all(AppSpacing.sm),
      semanticLabel: '${language.nativeName}${isSelected ? ' (выбран)' : ''}',
      child: Row(
        children: [
          Text(
            language.flag,
            style: const TextStyle(
              fontSize: _ProfileDialogsConstants.flagFontSize,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              language.nativeName,
              style: TextStyle(
                fontSize: _ProfileDialogsConstants.bodyFontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.accent : colors.text,
              ),
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: AppColors.accent,
              size: _ProfileDialogsConstants.checkIconSize,
            ),
        ],
      ),
    );
  }
}

/// Edit profile dialog
class EditProfileDialog extends StatefulWidget {
  final String firstName;
  final String lastName;
  final void Function(String firstName, String lastName) onSave;

  const EditProfileDialog({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.onSave,
  });

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
    final maxWidth = min(MediaQuery.of(context).size.width - 48, 400.0);

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Container(
        width: maxWidth,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeader(
                icon: Icons.edit,
                title: l10n.editProfile,
                colors: colors,
              ),
              const SizedBox(height: AppSpacing.xl),
              BreezTextField(
                controller: _firstNameController,
                label: l10n.firstName,
                prefixIcon: Icons.person_outlined,
                validator: (v) =>
                    Validators.of(context).name(v, fieldName: l10n.firstName),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              BreezTextField(
                controller: _lastNameController,
                label: l10n.lastName,
                prefixIcon: Icons.person_outlined,
                validator: (v) =>
                    Validators.of(context).name(v, fieldName: l10n.lastName),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: AppSpacing.xl),
              _DialogActions(
                onCancel: () => Navigator.of(context).pop(),
                onSave: _save,
                saveLabel: l10n.save,
                colors: colors,
                l10n: l10n,
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
  final void Function(String currentPassword, String newPassword) onSave;

  const ChangePasswordDialog({super.key, required this.onSave});

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
    final maxWidth = min(MediaQuery.of(context).size.width - 48, 400.0);

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Container(
        width: maxWidth,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeader(
                icon: Icons.lock,
                title: l10n.changePassword,
                colors: colors,
              ),
              const SizedBox(height: AppSpacing.xl),
              BreezTextField(
                controller: _currentPasswordController,
                label: l10n.currentPassword,
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: Validators.of(context).loginPassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              BreezTextField(
                controller: _newPasswordController,
                label: l10n.newPassword,
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: Validators.of(context).password,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              BreezTextField(
                controller: _confirmPasswordController,
                label: l10n.passwordConfirmation,
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: (value) => Validators.of(
                  context,
                ).confirmPassword(value, _newPasswordController.text),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: AppSpacing.xl),
              _DialogActions(
                onCancel: () => Navigator.of(context).pop(),
                onSave: _save,
                saveLabel: l10n.change,
                colors: colors,
                l10n: l10n,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog header with icon and title
class _DialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final BreezColors colors;

  const _DialogHeader({
    required this.icon,
    required this.title,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: TextStyle(
            fontSize: _ProfileDialogsConstants.headerFontSize,
            fontWeight: FontWeight.w600,
            color: colors.text,
          ),
        ),
      ],
    );
  }
}

/// Dialog action buttons (Cancel + Save)
class _DialogActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String saveLabel;
  final BreezColors colors;
  final AppLocalizations l10n;

  const _DialogActions({
    required this.onCancel,
    required this.onSave,
    required this.saveLabel,
    required this.colors,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BreezButton(
          onTap: onCancel,
          backgroundColor: Colors.transparent,
          hoverColor: colors.cardLight,
          pressedColor: colors.buttonBg,
          showBorder: false,
          semanticLabel: l10n.cancel,
          child: Text(l10n.cancel, style: TextStyle(color: colors.textMuted)),
        ),
        const SizedBox(width: AppSpacing.md),
        BreezButton(
          onTap: onSave,
          backgroundColor: AppColors.accent,
          hoverColor: AppColors.accentLight,
          enableGlow: true,
          semanticLabel: saveLabel,
          child: Text(
            saveLabel,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Shows language picker dialog
void showLanguagePickerDialog(
  BuildContext context,
  LanguageService languageService,
) {
  final colors = BreezColors.of(context);
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        0,
      ),
      contentPadding: const EdgeInsets.all(AppSpacing.sm),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        0,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      title: Text(
        l10n.language,
        style: TextStyle(
          fontSize: _ProfileDialogsConstants.bodyFontSize,
          fontWeight: FontWeight.w600,
          color: colors.textMuted,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.sm,
        children: [
          for (final language in languageService.availableLanguages)
            LanguageOption(
              language: language,
              isSelected: languageService.currentLanguage == language,
              onTap: () {
                languageService.setLanguage(language);
                Navigator.of(dialogContext).pop();
              },
            ),
        ],
      ),
      actions: [
        BreezButton(
          onTap: () => Navigator.of(dialogContext).pop(),
          backgroundColor: Colors.transparent,
          hoverColor: colors.cardLight,
          pressedColor: colors.buttonBg,
          showBorder: false,
          semanticLabel: l10n.cancel,
          child: Text(l10n.cancel, style: TextStyle(color: colors.textMuted)),
        ),
      ],
    ),
  );
}
