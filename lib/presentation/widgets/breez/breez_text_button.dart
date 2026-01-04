/// BREEZ Text Button - текстовая кнопка с hover эффектом
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Текстовая кнопка с акцентным цветом и hover эффектом
class BreezTextButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDisabled = onPressed == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        hoverColor: AppColors.accent.withValues(alpha: 0.1),
        splashColor: AppColors.accent.withValues(alpha: 0.2),
        highlightColor: AppColors.accent.withValues(alpha: 0.1),
        mouseCursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDisabled ? colors.textMuted : AppColors.accent,
              fontSize: fontSize,
              fontWeight: fontWeight,
              decoration: underline ? TextDecoration.underline : TextDecoration.none,
              decorationColor: isDisabled ? colors.textMuted : AppColors.accent,
            ),
          ),
        ),
      ),
    );
  }
}
