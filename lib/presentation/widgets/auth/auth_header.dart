/// Компонент заголовка авторизации
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_logo.dart';

/// Заголовок для страниц авторизации
class AuthHeader extends StatelessWidget {

  const AuthHeader({
    required this.title, super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      children: [
        // Логотип
        const BreezLogo.compact(),
        const SizedBox(height: AppSpacing.sm),

        // Подзаголовок
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: FontWeight.w600,
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }
}
