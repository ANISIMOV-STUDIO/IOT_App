/// Toast/Snackbar Service
///
/// Централизованный сервис для показа toast-уведомлений.
/// Следует Material Design guidelines и паттернам Big Tech.
library;

import 'package:flutter/material.dart';
import '../config/app_constants.dart';
import '../theme/app_theme.dart';
import '../theme/app_font_sizes.dart';
import '../theme/app_radius.dart';
import '../theme/spacing.dart';

/// Глобальный ключ для доступа к ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Типы toast-уведомлений
enum ToastType {
  /// Успешное действие (зелёный)
  success,

  /// Ошибка (красный)
  error,

  /// Предупреждение (оранжевый)
  warning,

  /// Информация (синий)
  info,
}

/// Сервис для показа toast-уведомлений
///
/// Использование:
/// ```dart
/// ToastService.show('Данные сохранены', type: ToastType.success);
/// ToastService.success('Устройство добавлено');
/// ToastService.error('Не удалось подключиться');
/// ```
class ToastService {
  ToastService._();

  /// Показать toast с заданным типом
  static void show(
    String message, {
    ToastType type = ToastType.info,
    Duration duration = UiConstants.toastDuration,
    String? actionLabel,
    VoidCallback? onAction,
    bool showIcon = true,
  }) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    // Скрыть текущий snackbar перед показом нового
    messenger.hideCurrentSnackBar();

    final (color, icon) = _getTypeStyle(type);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showIcon) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  /// Показать success toast
  static void success(String message, {String? actionLabel, VoidCallback? onAction}) {
    show(message, type: ToastType.success, actionLabel: actionLabel, onAction: onAction);
  }

  /// Показать error toast
  static void error(String message, {String? actionLabel, VoidCallback? onAction}) {
    show(message, type: ToastType.error, actionLabel: actionLabel, onAction: onAction);
  }

  /// Показать warning toast
  static void warning(String message, {String? actionLabel, VoidCallback? onAction}) {
    show(message, type: ToastType.warning, actionLabel: actionLabel, onAction: onAction);
  }

  /// Показать info toast
  static void info(String message, {String? actionLabel, VoidCallback? onAction}) {
    show(message, type: ToastType.info, actionLabel: actionLabel, onAction: onAction);
  }

  /// Скрыть текущий toast
  static void hide() {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }

  /// Получить стиль для типа toast
  static (Color, IconData) _getTypeStyle(ToastType type) {
    return switch (type) {
      ToastType.success => (AppColors.success, Icons.check_circle_outline),
      ToastType.error => (AppColors.critical, Icons.error_outline),
      ToastType.warning => (AppColors.warning, Icons.warning_amber_outlined),
      ToastType.info => (AppColors.info, Icons.info_outline),
    };
  }
}
