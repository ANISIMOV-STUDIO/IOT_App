/// Компонент ссылки действия авторизации
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../breez/breez_button.dart';

/// Ссылка для перехода между страницами авторизации
/// Например: "Нет аккаунта? Зарегистрироваться"
class AuthActionLink extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const AuthActionLink({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

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
            fontSize: AppFontSizes.bodySmall,
          ),
        ),
        BreezButton(
          onTap: onTap,
          backgroundColor: Colors.transparent,
          hoverColor: AppColors.accent.withValues(alpha: 0.1),
          pressedColor: AppColors.accent.withValues(alpha: 0.15),
          showBorder: false,
          enforceMinTouchTarget: false,
          semanticLabel: actionText,
          child: Text(
            actionText,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: AppFontSizes.bodySmall,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
