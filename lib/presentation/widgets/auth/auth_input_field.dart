/// Authentication Input Field Widget
///
/// Responsive, accessible input field for web authentication
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import 'responsive_utils.dart';

class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    required this.prefixIcon,
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
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
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

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.text,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.rw(context)),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: HvacColors.primaryOrange.withAlpha(51),
                    blurRadius: 8.rw(context),
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
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: (16 * responsive.fontMultiplier).rsp(context),
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: Icon(
              widget.prefixIcon,
              size: (20 * responsive.fontMultiplier).rsp(context),
              color: _isFocused
                  ? HvacColors.primaryOrange
                  : _isHovered
                      ? HvacColors.textPrimary
                      : HvacColors.textSecondary,
            ),
            suffixIcon: widget.suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.rw(context),
              vertical: responsive.inputHeight / 4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rw(context)),
              borderSide: BorderSide(
                color: HvacColors.backgroundCardBorder,
                width: 1.rw(context),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rw(context)),
              borderSide: BorderSide(
                color: _isHovered
                    ? HvacColors.textSecondary.withAlpha(102)
                    : HvacColors.backgroundCardBorder,
                width: (_isHovered ? 1.5 : 1).rw(context),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rw(context)),
              borderSide: BorderSide(
                color: HvacColors.primaryOrange,
                width: 2.rw(context),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rw(context)),
              borderSide: BorderSide(
                color: HvacColors.error,
                width: 1.rw(context),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rw(context)),
              borderSide: BorderSide(
                color: HvacColors.error,
                width: 2.rw(context),
              ),
            ),
            labelStyle: TextStyle(
              fontSize: (14 * responsive.fontMultiplier).rsp(context),
              color: _isFocused
                  ? HvacColors.primaryOrange
                  : HvacColors.textSecondary,
            ),
            hintStyle: TextStyle(
              fontSize: (14 * responsive.fontMultiplier).rsp(context),
              color: HvacColors.textSecondary.withAlpha(153),
            ),
            errorStyle: TextStyle(
              fontSize: (12 * responsive.fontMultiplier).rsp(context),
            ),
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
    );
  }
}