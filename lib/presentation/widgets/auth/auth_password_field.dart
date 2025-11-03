/// Authentication Password Field Component
///
/// Specialized password input with visibility toggle
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/utils/validators.dart';
import 'auth_input_field.dart';
import 'responsive_utils.dart';

class AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool isConfirmField;
  final String? passwordToMatch;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.isConfirmField = false,
    this.passwordToMatch,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AuthInputField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText ?? '••••••••',
      prefixIcon: Icons.lock_outlined,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: _obscureText,
      validator: widget.isConfirmField
          ? (value) => Validators.validatePasswordConfirmation(
                value,
                widget.passwordToMatch ?? '',
              )
          : widget.validator,
      inputFormatters: [
        LengthLimitingTextInputFormatter(SecurityConstants.maxPasswordLength),
      ],
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          size: 20.rsp(context),
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
        splashRadius: 20.rw(context),
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      ),
    );
  }
}