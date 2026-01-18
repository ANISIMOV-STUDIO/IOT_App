/// BREEZ Pin Code Field - поле для ввода кода подтверждения
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';

/// Поле для ввода PIN-кода (6 цифр)
class BreezPinCodeField extends StatefulWidget {
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final int length;
  final String? errorText;

  const BreezPinCodeField({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.length = 6,
    this.errorText,
  });

  @override
  State<BreezPinCodeField> createState() => _BreezPinCodeFieldState();
}

class _BreezPinCodeFieldState extends State<BreezPinCodeField> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  // FocusNodes для KeyboardListener - отдельные от текстовых полей
  final List<FocusNode> _keyboardListenerFocusNodes = [];
  String _currentCode = '';

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      _keyboardListenerFocusNodes.add(FocusNode());
    }
    // Автофокус на первое поле
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var node in _keyboardListenerFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Если вставили несколько символов (из буфера обмена)
      if (value.length > 1) {
        _handlePaste(value);
        return;
      }

      // Переход на следующее поле
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    _updateCode();
  }

  void _handlePaste(String pastedText) {
    // Очистка - только цифры
    final digits = pastedText.replaceAll(RegExp(r'\D'), '');

    for (int i = 0; i < widget.length && i < digits.length; i++) {
      _controllers[i].text = digits[i];
    }

    // Фокус на последнее заполненное поле
    final lastIndex = (digits.length - 1).clamp(0, widget.length - 1);
    _focusNodes[lastIndex].requestFocus();

    _updateCode();
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          // Переход на предыдущее поле при backspace
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].clear();
        }
      }
    }
  }

  void _updateCode() {
    _currentCode = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(_currentCode);

    if (_currentCode.length == widget.length) {
      widget.onCompleted(_currentCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final hasError = widget.errorText?.isNotEmpty ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Container(
              width: 56,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : AppSpacing.xs / 2,
                right: index == widget.length - 1 ? 0 : AppSpacing.xs / 2,
              ),
              child: KeyboardListener(
                  focusNode: _keyboardListenerFocusNodes[index],
                  onKeyEvent: (event) => _onKeyEvent(event, index),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: TextStyle(
                      fontSize: AppFontSizes.h2,
                      fontWeight: FontWeight.w600,
                      color: colors.text,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: colors.card,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        borderSide: BorderSide(
                          color: hasError
                              ? AppColors.critical
                              : colors.border,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        borderSide: BorderSide(
                          color: hasError
                              ? AppColors.critical
                              : AppColors.accent,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) => _onChanged(value, index),
                  ),
                ),
              );
          }),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Text(
              widget.errorText ?? '',
              style: const TextStyle(
                fontSize: AppFontSizes.caption,
                color: AppColors.critical,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
