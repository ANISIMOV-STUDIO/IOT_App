/// BREEZ Text Button - текстовая кнопка с hover эффектом
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Текстовая кнопка с акцентным цветом и hover эффектом
class BreezTextButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final bool underline;

  const BreezTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.underline = true,
  });

  @override
  State<BreezTextButton> createState() => _BreezTextButtonState();
}

class _BreezTextButtonState extends State<BreezTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDisabled = widget.onPressed == null;

    return MouseRegion(
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            color: isDisabled
                ? colors.textMuted
                : _isHovered
                    ? AppColors.accent.withValues(alpha: 0.8)
                    : AppColors.accent,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            decoration: widget.underline ? TextDecoration.underline : TextDecoration.none,
            decorationColor: isDisabled
                ? colors.textMuted
                : _isHovered
                    ? AppColors.accent.withValues(alpha: 0.8)
                    : AppColors.accent,
          ),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
