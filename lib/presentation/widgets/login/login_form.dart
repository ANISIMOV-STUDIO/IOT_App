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
          hintText: l10n.email,
          icon: Icons.email_rounded,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: HvacSpacing.md),
        _LoginTextField(
          controller: passwordController,
          hintText: l10n.password,
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
    if (obscureText) {
      return Semantics(
        label: hintText,
        hint: 'Enter your password',
        textField: true,
        child: HvacPasswordField(
          controller: controller,
          labelText: hintText,
          onFieldSubmitted: onSubmitted,
        ),
      );
    }

    return Semantics(
      label: hintText,
      hint: 'Enter your email address',
      textField: true,
      child: HvacTextField(
        controller: controller,
        labelText: hintText,
        prefixIcon: icon,
        enabled: enabled,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}
