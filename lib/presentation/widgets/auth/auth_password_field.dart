/// Authentication Password Field Component
///
/// Wrapper around HvacPasswordField for authentication screens
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/utils/validators.dart';

class AuthPasswordField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return HvacPasswordField(
      controller: controller,
      labelText: labelText,
      hintText: hintText ?? '••••••••',
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: isConfirmField
          ? (value) => Validators.validatePasswordConfirmation(
                value,
                passwordToMatch ?? '',
              )
          : validator,
      maxLength: SecurityConstants.maxPasswordLength,
    );
  }
}
