/// BREEZ Text Button - Text link button based on BreezButton
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

/// Текстовая кнопка-ссылка с акцентным цветом
///
/// Использует базовый BreezButton для единообразия анимаций и accessibility.
class BreezTextButton extends StatelessWidget {

  const BreezTextButton({
    required this.text, required this.onPressed, super.key,
    this.fontSize = AppFontSizes.body,
    this.fontWeight = FontWeight.normal,
    this.underline = true,
    this.semanticLabel,
    this.tooltip,
  });
  final String text;
  final VoidCallback? onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final bool underline;

  /// Semantic label for screen readers (defaults to text)
  final String? semanticLabel;

  /// Tooltip shown on hover
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDisabled = onPressed == null;

    return BreezButton(
      onTap: onPressed,
      backgroundColor: Colors.transparent,
      hoverColor: colors.accent.withValues(alpha: 0.1),
      showBorder: false,
      enableScale: false,
      enforceMinTouchTarget: false,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
      semanticLabel: semanticLabel ?? text,
      tooltip: tooltip,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isDisabled ? colors.textMuted : colors.accent,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: underline ? TextDecoration.underline : TextDecoration.none,
          decorationColor: isDisabled ? colors.textMuted : colors.accent,
        ),
      ),
    );
  }
}
