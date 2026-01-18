/// Утилиты для SnackBar
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_font_sizes.dart';
import '../theme/app_radius.dart';
import '../theme/spacing.dart';

/// Вспомогательные функции для показа SnackBar с единым стилем
class SnackBarUtils {
  /// Базовая функция для показа красивого SnackBar
  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.white, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: AppFontSizes.body,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        elevation: 8,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Показать SnackBar с ошибкой
  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.accentRed,
      icon: Icons.error_outline,
    );
  }

  /// Показать SnackBar с предупреждением
  static void showWarning(BuildContext context, String message) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber_outlined,
    );
  }

  /// Показать SnackBar с информацией
  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline,
    );
  }

  /// Показать SnackBar с успехом
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.accentGreen,
      icon: Icons.check_circle_outline,
    );
  }
}
