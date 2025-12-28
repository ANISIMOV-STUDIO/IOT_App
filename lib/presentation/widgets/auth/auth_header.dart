/// Компонент заголовка авторизации
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../breez/breez_logo.dart';

/// Заголовок для страниц авторизации
class AuthHeader extends StatelessWidget {
  final String title;

  const AuthHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      children: [
        // Логотип
        const BreezLogo(
          iconSize: 56,
          titleSize: 28,
          subtitleSize: 10,
          spacing: 12,
        ),
        const SizedBox(height: AppSpacing.xl),

        // Подзаголовок
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: FontWeight.w600,
            color: colors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
