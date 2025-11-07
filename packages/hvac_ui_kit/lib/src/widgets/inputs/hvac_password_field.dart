/// Password Field Widget for HVAC UI Kit
///
/// Specialized password input with visibility toggle
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'hvac_text_field.dart';
import '../../theme/colors.dart';

/// Password field component with visibility toggle
///
/// Usage:
/// ```dart
/// HvacPasswordField(
///   controller: controller,
///   labelText: 'Password',
/// )
/// ```
class HvacPasswordField extends StatefulWidget {
  /// Text controller
  final TextEditingController controller;

  /// Label text
  final String labelText;

  /// Hint text
  final String? hintText;

  /// Focus node
  final FocusNode? focusNode;

  /// Text input action
  final TextInputAction? textInputAction;

  /// On field submitted callback
  final void Function(String)? onFieldSubmitted;

  /// Validator function
  final String? Function(String?)? validator;

  /// Field size
  final HvacTextFieldSize size;

  /// Maximum password length
  final int maxLength;

  /// Show password strength indicator
  final bool showStrengthIndicator;

  /// On changed callback
  final void Function(String)? onChanged;

  const HvacPasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.size = HvacTextFieldSize.medium,
    this.maxLength = 128,
    this.showStrengthIndicator = false,
    this.onChanged,
  });

  @override
  State<HvacPasswordField> createState() => _HvacPasswordFieldState();
}

class _HvacPasswordFieldState extends State<HvacPasswordField> {
  bool _obscureText = true;
  double _passwordStrength = 0.0;

  void _handlePasswordChange(String value) {
    if (widget.showStrengthIndicator) {
      setState(() {
        _passwordStrength = _calculatePasswordStrength(value);
      });
    }
    widget.onChanged?.call(value);
  }

  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;

    // Length check
    if (password.length >= 8) strength += 0.25;
    if (password.length >= 12) strength += 0.15;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.15;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.15;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.15;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.15;

    return strength.clamp(0.0, 1.0);
  }

  Color _getStrengthColor() {
    if (_passwordStrength < 0.3) return HvacColors.error;
    if (_passwordStrength < 0.6) return HvacColors.warning;
    if (_passwordStrength < 0.8) return HvacColors.info;
    return HvacColors.success;
  }

  String _getStrengthText() {
    if (_passwordStrength < 0.3) return 'Weak';
    if (_passwordStrength < 0.6) return 'Fair';
    if (_passwordStrength < 0.8) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HvacTextField(
          controller: widget.controller,
          labelText: widget.labelText,
          hintText: widget.hintText ?? '••••••••',
          prefixIcon: Icons.lock_outlined,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: _handlePasswordChange,
          obscureText: _obscureText,
          validator: widget.validator,
          size: widget.size,
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
            tooltip: _obscureText ? 'Show password' : 'Hide password',
          ),
        ),

        // Password strength indicator
        if (widget.showStrengthIndicator &&
            widget.controller.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: _passwordStrength,
                    backgroundColor: HvacColors.backgroundCardBorder,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(_getStrengthColor()),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _getStrengthText(),
                style: TextStyle(
                  fontSize: 12,
                  color: _getStrengthColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
