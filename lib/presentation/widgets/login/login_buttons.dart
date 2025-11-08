/// Login Buttons Widget
///
/// Handles login, register, and skip actions
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Login action buttons
class LoginButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final VoidCallback onSkip;

  const LoginButtons({
    super.key,
    required this.isLoading,
    required this.onLogin,
    required this.onRegister,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Login button
        _LoginPrimaryButton(
          label: l10n.login,
          isLoading: isLoading,
          onPressed: isLoading ? null : onLogin,
        ),

        SizedBox(height: HvacSpacing.md.h),

        // Register button
        _LoginSecondaryButton(
          label: l10n.register,
          onPressed: isLoading ? null : onRegister,
        ),

        SizedBox(height: HvacSpacing.lg.h),

        // Skip button
        HvacTextButton(
          label: l10n.skip,
          onPressed: isLoading ? null : onSkip,
        ),
      ],
    );
  }
}

/// Primary action button with loading state
class _LoginPrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _LoginPrimaryButton({
    required this.label,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: HvacPrimaryButton(
        label: label,
        onPressed: onPressed,
        isExpanded: true,
        isLoading: isLoading,
      ),
    );
  }
}

/// Secondary action button
class _LoginSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _LoginSecondaryButton({
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: HvacOutlineButton(
        label: label,
        onPressed: onPressed,
      ),
    );
  }
}
