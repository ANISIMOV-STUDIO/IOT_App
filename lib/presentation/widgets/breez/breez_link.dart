/// BREEZ Link - Text link with underline on hover
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';

/// Текстовая ссылка с подчёркиванием при наведении
///
/// Использование:
/// ```dart
/// BreezLink(
///   text: 'Регистрация',
///   onTap: () => ...,
/// )
/// ```
class BreezLink extends StatefulWidget {
  const BreezLink({
    required this.text,
    required this.onTap,
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  final String text;
  final VoidCallback onTap;

  /// Цвет текста (по умолчанию AppColors.accent)
  final Color? color;

  /// Размер шрифта (по умолчанию AppFontSizes.caption)
  final double? fontSize;

  /// Толщина шрифта (по умолчанию w600)
  final FontWeight? fontWeight;

  @override
  State<BreezLink> createState() => _BreezLinkState();
}

class _BreezLinkState extends State<BreezLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final effectiveColor = widget.color ?? colors.accent;
    final effectiveFontSize = widget.fontSize ?? AppFontSizes.caption;
    final effectiveFontWeight = widget.fontWeight ?? FontWeight.w600;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Semantics(
          button: true,
          label: widget.text,
          child: Text(
            widget.text,
            style: TextStyle(
              color: effectiveColor,
              fontSize: effectiveFontSize,
              fontWeight: effectiveFontWeight,
              decoration: _isHovered ? TextDecoration.underline : null,
              decorationColor: effectiveColor,
            ),
          ),
        ),
      ),
    );
  }
}
