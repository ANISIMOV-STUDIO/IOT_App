/// Login Form Widget
///
/// Handles email and password input fields
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Login form with email and password fields
class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _LoginTextField(
          controller: emailController,
          hintText: l10n.emailHint,
          icon: Icons.email_rounded,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          onSubmitted: (_) => onSubmit(),
        ),

        SizedBox(height: HvacSpacing.md.h),

        _LoginTextField(
          controller: passwordController,
          hintText: l10n.passwordHint,
          icon: Icons.lock_rounded,
          obscureText: true,
          enabled: !isLoading,
          onSubmitted: (_) => onSubmit(),
        ),
      ],
    );
  }
}

/// Custom text field for login form
class _LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(String)? onSubmitted;

  const _LoginTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.enabled = true,
    this.inputFormatters,
    this.keyboardType,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(HvacRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmitted,
        style: TextStyle(
          fontSize: 16.sp,
          color: HvacColors.textPrimary,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: HvacColors.textSecondary,
            size: 20.w,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: HvacColors.textSecondary,
            fontSize: 14.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(HvacRadius.md),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: HvacColors.backgroundCard,
          contentPadding: EdgeInsets.symmetric(
            horizontal: HvacSpacing.md.w,
            vertical: HvacSpacing.sm.h,
          ),
        ),
      ),
    );
  }
}