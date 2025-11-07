/// Text Field Widget for HVAC UI Kit
///
/// Professional text input component with:
/// - Focus and hover states
/// - Responsive sizing
/// - Corporate blue theme
/// - Validation support
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/typography.dart';

/// Text field size variant
enum HvacTextFieldSize {
  small,   // Compact input (40h)
  medium,  // Standard input (48h)
  large,   // Large input (56h)
}

/// Professional text field component
///
/// Usage:
/// ```dart
/// HvacTextField(
///   controller: controller,
///   labelText: 'Email',
///   prefixIcon: Icons.email,
/// )
/// ```
class HvacTextField extends StatefulWidget {
  /// Text controller
  final TextEditingController controller;

  /// Label text
  final String labelText;

  /// Hint text
  final String? hintText;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final Widget? suffixIcon;

  /// Obscure text (for passwords)
  final bool obscureText;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Validator function
  final String? Function(String?)? validator;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Autofocus
  final bool autofocus;

  /// On changed callback
  final void Function(String)? onChanged;

  /// On field submitted callback
  final void Function(String)? onFieldSubmitted;

  /// Focus node
  final FocusNode? focusNode;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Field size
  final HvacTextFieldSize size;

  /// Max lines
  final int? maxLines;

  /// Max length
  final int? maxLength;

  /// Enabled state
  final bool enabled;

  const HvacTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.size = HvacTextFieldSize.medium,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
  });

  @override
  State<HvacTextField> createState() => _HvacTextFieldState();
}

class _HvacTextFieldState extends State<HvacTextField> {
  bool _isFocused = false;
  bool _isHovered = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  double get _height {
    switch (widget.size) {
      case HvacTextFieldSize.small:
        return 40;
      case HvacTextFieldSize.medium:
        return 48;
      case HvacTextFieldSize.large:
        return 56;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case HvacTextFieldSize.small:
        return 14;
      case HvacTextFieldSize.medium:
        return 16;
      case HvacTextFieldSize.large:
        return 18;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HvacRadius.mdR),
          boxShadow: _isFocused && widget.enabled
              ? [
                  BoxShadow(
                    color: HvacColors.accent.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          textCapitalization: widget.textCapitalization,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          style: HvacTypography.bodyMedium.copyWith(
            fontSize: _fontSize,
            color: widget.enabled ? HvacColors.textPrimary : HvacColors.textTertiary,
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: _isFocused && widget.enabled
                        ? HvacColors.accent
                        : _isHovered && widget.enabled
                            ? HvacColors.textPrimary
                            : HvacColors.textSecondary,
                  )
                : null,
            suffixIcon: widget.suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: HvacSpacing.md,
              vertical: (_height - _fontSize) / 2 - 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HvacRadius.mdR),
              borderSide: const BorderSide(
                color: HvacColors.backgroundCardBorder,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HvacRadius.mdR),
              borderSide: BorderSide(
                color: _isHovered
                    ? HvacColors.textSecondary.withValues(alpha: 0.4)
                    : HvacColors.backgroundCardBorder,
                width: _isHovered ? 1.5 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HvacRadius.mdR),
              borderSide: const BorderSide(
                color: HvacColors.accent,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HvacRadius.mdR),
              borderSide: const BorderSide(
                color: HvacColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HvacRadius.mdR),
              borderSide: const BorderSide(
                color: HvacColors.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HvacRadius.mdR),
              borderSide: BorderSide(
                color: HvacColors.backgroundCardBorder.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            labelStyle: HvacTypography.bodyMedium.copyWith(
              fontSize: _fontSize - 2,
              color: _isFocused && widget.enabled
                  ? HvacColors.accent
                  : HvacColors.textSecondary,
            ),
            hintStyle: HvacTypography.bodyMedium.copyWith(
              fontSize: _fontSize - 2,
              color: HvacColors.textSecondary.withValues(alpha: 0.6),
            ),
            errorStyle: HvacTypography.caption.copyWith(
              fontSize: 12,
            ),
            counterStyle: HvacTypography.caption.copyWith(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
