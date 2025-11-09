/// Authentication Form Widget
///
/// Reusable form component for login/register with responsive design
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'auth_checkbox_section.dart';
import 'auth_input_field.dart';
import 'auth_password_field.dart';
import 'password_strength_indicator.dart';
import 'responsive_utils.dart';

class AuthForm extends StatefulWidget {
  final bool isLoginMode;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;
  final bool isLoading;

  const AuthForm({
    super.key,
    required this.isLoginMode,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.confirmPasswordController,
    required this.onSubmit,
    required this.onToggleMode,
    this.isLoading = false,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _checkboxKey = GlobalKey<AuthCheckboxSectionState>();

  late FocusNode _emailFocus;
  late FocusNode _passwordFocus;
  late FocusNode _nameFocus;
  late FocusNode _confirmPasswordFocus;

  @override
  void initState() {
    super.initState();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _nameFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _nameFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      return;
    }

    final checkboxState = _checkboxKey.currentState;
    if (!widget.isLoginMode && !(checkboxState?.acceptTerms ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: HvacColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final responsive = AuthResponsive(context);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name field (register only)
          if (!widget.isLoginMode) ...[
            AuthInputField(
              controller: widget.nameController,
              labelText: 'Full Name',
              hintText: 'John Doe',
              prefixIcon: Icons.person_outline,
              focusNode: _nameFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _emailFocus.requestFocus(),
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  Validators.validateName(value, fieldName: 'Name'),
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
            ),
            SizedBox(height: responsive.verticalSpacing),
          ],

          // Email field
          AuthInputField(
            controller: widget.emailController,
            labelText: l10n.email,
            hintText: 'your@email.com',
            prefixIcon: Icons.email_outlined,
            focusNode: _emailFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            inputFormatters: [
              LengthLimitingTextInputFormatter(254),
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            ],
          ),
          SizedBox(height: responsive.verticalSpacing),

          // Password field
          AuthPasswordField(
            controller: widget.passwordController,
            labelText: l10n.password,
            hintText: widget.isLoginMode
                ? '••••••••'
                : 'Min ${SecurityConstants.minPasswordLength} characters',
            focusNode: _passwordFocus,
            textInputAction: widget.isLoginMode
                ? TextInputAction.done
                : TextInputAction.next,
            onFieldSubmitted: widget.isLoginMode
                ? (_) => _handleSubmit()
                : (_) => _confirmPasswordFocus.requestFocus(),
            validator: widget.isLoginMode ? null : Validators.validatePassword,
          ),

          // Password strength indicator (register only)
          if (!widget.isLoginMode &&
              widget.passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            PasswordStrengthIndicator(
              password: widget.passwordController.text,
              showRequirements: responsive.isDesktop,
            ),
          ],

          if (!widget.isLoginMode) ...[
            SizedBox(height: responsive.verticalSpacing),
            // Confirm password field
            AuthPasswordField(
              controller: widget.confirmPasswordController,
              labelText: 'Confirm Password',
              focusNode: _confirmPasswordFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(),
              isConfirmField: true,
              passwordToMatch: widget.passwordController.text,
            ),
          ],

          SizedBox(height: responsive.verticalSpacing),

          // Checkbox section
          AuthCheckboxSection(
            key: _checkboxKey,
            isLoginMode: widget.isLoginMode,
            onRememberMeChanged: (value) {},
            onAcceptTermsChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
