import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Тени для UI элементов
abstract class AppShadows {
  /// Тень для карточек
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Светящаяся тень (акцент)
  static List<BoxShadow> get glow => [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.3),
          blurRadius: 40,
          spreadRadius: 0,
        ),
      ];
}
