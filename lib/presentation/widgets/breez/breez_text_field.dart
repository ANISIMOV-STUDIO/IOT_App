/// BREEZ Text Field Component
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezTextField
abstract class _TextFieldConstants {
  static const double iconSize = 20;
  static const double labelFontSize = 12;
  static const double inputFontSize = 14;
  static const double errorIconSize = 12;
  static const double errorFontSize = 11;
  static const double errorPositionLeft = 12;
  static const double errorPositionBottom = -7;
}

// =============================================================================
// WIDGET
// =============================================================================

/// BREEZ styled text field
class BreezTextField extends StatefulWidget {

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
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
  });
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
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  @override
  State<BreezTextField> createState() => _BreezTextFieldState();
}

class _BreezTextFieldState extends State<BreezTextField> {
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;
  late bool _obscureTextInternal;
  final GlobalKey<FormFieldState<String>> _fieldKey = GlobalKey<FormFieldState<String>>();
  FocusNode? _internalFocusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _obscureTextInternal = widget.obscureText;
    _effectiveFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _effectiveFocusNode.hasFocus;
    });
    if (!_effectiveFocusNode.hasFocus && !widget.validateOnChange && widget.validator != null) {
      _validateField();
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    // Только если мы создали внутренний FocusNode - удаляем его
    _internalFocusNode?.dispose();
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
    var effectiveSuffixIcon = widget.suffixIcon;
    if (widget.showPasswordToggle && widget.suffixIcon == null) {
      effectiveSuffixIcon = IconButton(
        icon: Icon(
          _obscureTextInternal
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: colors.textMuted,
          size: _TextFieldConstants.iconSize,
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
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Text(
              widget.label ?? '',
              style: TextStyle(
                fontSize: _TextFieldConstants.labelFontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: colors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
        ],
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: Border.all(
                  color: _hasError
                      ? AppColors.accentRed
                      : _isFocused
                          ? AppColors.accent
                          : colors.border,
                ),
              ),
              // Сбрасываем глобальную InputDecorationTheme
              child: Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: const InputDecorationTheme(),
                ),
                child: TextFormField(
                  key: _fieldKey,
                  controller: widget.controller,
                  focusNode: _effectiveFocusNode,
                  obscureText: widget.showPasswordToggle ? _obscureTextInternal : widget.obscureText,
                  keyboardType: widget.keyboardType,
                  maxLines: widget.maxLines,
                  enabled: widget.enabled,
                  autofillHints: widget.autofillHints,
                  textInputAction: widget.textInputAction,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: _TextFieldConstants.inputFontSize,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: colors.textMuted,
                      fontSize: _TextFieldConstants.inputFontSize,
                    ),
                    prefixIcon: widget.prefixIcon != null
                        ? Align(
                            widthFactor: 1,
                            heightFactor: 1,
                            child: Icon(
                              widget.prefixIcon,
                              color: colors.textMuted,
                              size: _TextFieldConstants.iconSize,
                            ),
                          )
                        : null,
                    suffixIcon: effectiveSuffixIcon != null
                        ? Align(
                            widthFactor: 1,
                            heightFactor: 1,
                            child: effectiveSuffixIcon,
                          )
                        : null,
                    // Убираем фон и все бордеры
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon != null ? 0 : AppSpacing.md,
                      vertical: AppSpacing.sm,
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
            ),
            if (_hasError && _errorText != null)
              Positioned(
                left: _TextFieldConstants.errorPositionLeft,
                bottom: _TextFieldConstants.errorPositionBottom,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                  color: colors.card,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: _TextFieldConstants.errorIconSize,
                        color: AppColors.accentRed,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        _errorText ?? '',
                        style: const TextStyle(
                          fontSize: _TextFieldConstants.errorFontSize,
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
