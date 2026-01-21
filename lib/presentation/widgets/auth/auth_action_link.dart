/// Компонент ссылки действия авторизации
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_link.dart';

/// Ссылка для перехода между страницами авторизации
/// Например: "Нет аккаунта? Зарегистрироваться"
class AuthActionLink extends StatelessWidget {
  const AuthActionLink({
    required this.text,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  final String text;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: colors.textMuted,
            fontSize: AppFontSizes.caption,
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        BreezLink(
          text: actionText,
          onTap: onTap,
        ),
      ],
    );
  }
}
