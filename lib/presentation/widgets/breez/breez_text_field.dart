/// BREEZ Text Field Component
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';

/// BREEZ styled text field
class BreezTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;
  final bool validateOnChange;
  final bool showPasswordToggle;

  const BreezTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.validateOnChange = false,
    this.showPasswordToggle = false,
  });

  @override
  State<BreezTextField> createState() => _BreezTextFieldState();
}

class _BreezTextFieldState extends State<BreezTextField> {
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;
  late bool _obscureTextInternal;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscureTextInternal = widget.obscureText;
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (!_focusNode.hasFocus && !widget.validateOnChange && widget.validator != null) {
      _validateField();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _validateField() {
    // Запускаем валидацию через FormField
    _fieldKey.currentState?.validate();
    // Получаем текущую ошибку из FormField
    final error = _fieldKey.currentState?.errorText;
    setState(() {
      _hasError = error != null;
      _errorText = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    // Определяем suffixIcon с учетом passwordToggle
    Widget? effectiveSuffixIcon = widget.suffixIcon;
    if (widget.showPasswordToggle && widget.suffixIcon == null) {
      effectiveSuffixIcon = IconButton(
        icon: Icon(
          _obscureTextInternal
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: colors.textMuted,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureTextInternal = !_obscureTextInternal;
          });
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            (widget.label ?? '').toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: Border.all(
                  color: _hasError
                      ? AppColors.accentRed
                      : _isFocused
                          ? AppColors.accent
                          : colors.border,
                  width: 1,
                ),
              ),
              child: TextFormField(
                key: _fieldKey,
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.showPasswordToggle ? _obscureTextInternal : widget.obscureText,
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                enabled: widget.enabled,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    color: colors.textMuted,
                    fontSize: 14,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Icon(
                            widget.prefixIcon,
                            color: colors.textMuted,
                            size: 20,
                          ),
                        )
                      : null,
                  suffixIcon: effectiveSuffixIcon != null
                      ? Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: effectiveSuffixIcon,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.prefixIcon != null ? 0 : AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  helperText: ' ', // Резервирует место для ошибки
                  helperStyle: const TextStyle(height: 0, fontSize: 0),
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                ),
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  if (widget.validateOnChange && widget.validator != null) {
                    _validateField();
                  }
                },
                validator: widget.validator,
              ),
            ),
            if (_hasError && _errorText != null)
              Positioned(
                left: 12,
                bottom: -7,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  color: colors.card,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 12,
                        color: AppColors.accentRed,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _errorText ?? '',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.accentRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
