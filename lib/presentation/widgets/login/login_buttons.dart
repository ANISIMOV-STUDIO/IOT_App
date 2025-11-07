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
        TextButton(
          onPressed: isLoading ? null : onSkip,
          child: Text(
            l10n.skip,
            style: TextStyle(
              fontSize: 14.sp,
              color: HvacColors.textSecondary,
              decoration: TextDecoration.underline,
            ),
          ),
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
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HvacColors.primaryOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HvacRadius.md),
          ),
          elevation: isLoading ? 0 : 8,
          shadowColor: HvacColors.primaryOrange.withValues(alpha: 0.4),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
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
      height: 56.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: HvacColors.textPrimary,
          side: const BorderSide(
            color: HvacColors.borderSubtle,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HvacRadius.md),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
