/// BREEZ Error Widget - Компоненты для отображения ошибок и восстановления
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import 'breez_button.dart';
import 'breez_dialog_button.dart';
import 'breez_text_button.dart';

/// Типы ошибок для разного визуального оформления
enum BreezErrorType {
  /// Ошибка сети / подключения
  network,

  /// Ошибка сервера
  server,

  /// Данные не найдены
  notFound,

  /// Общая ошибка
  general,

  /// Предупреждение (не критичная ошибка)
  warning,
}

/// Универсальный виджет для отображения ошибок с поддержкой восстановления
///
/// Особенности:
/// - Различные типы ошибок с соответствующими иконками
/// - Кнопка повторной попытки
/// - Дополнительные действия
/// - Компактный и полноэкранный режимы
class BreezErrorWidget extends StatelessWidget {
  /// Сообщение об ошибке
  final String message;

  /// Подробное описание (опционально)
  final String? description;

  /// Тип ошибки для выбора иконки
  final BreezErrorType type;

  /// Callback для повторной попытки
  final VoidCallback? onRetry;

  /// Текст кнопки повторной попытки
  final String retryText;

  /// Дополнительное действие
  final VoidCallback? onSecondaryAction;

  /// Текст дополнительной кнопки
  final String? secondaryActionText;

  /// Компактный режим (для встраивания в карточки)
  final bool compact;

  /// Кастомная иконка
  final IconData? icon;

  /// Семантическая метка для screen readers
  final String? semanticLabel;

  const BreezErrorWidget({
    super.key,
    required this.message,
    this.description,
    this.type = BreezErrorType.general,
    this.onRetry,
    this.retryText = 'Повторить',
    this.onSecondaryAction,
    this.secondaryActionText,
    this.compact = false,
    this.icon,
    this.semanticLabel,
  });

  /// Создать виджет для ошибки сети
  factory BreezErrorWidget.network({
    Key? key,
    String message = 'Нет подключения к сети',
    String? description = 'Проверьте интернет-соединение и попробуйте снова',
    VoidCallback? onRetry,
    bool compact = false,
  }) {
    return BreezErrorWidget(
      key: key,
      message: message,
      description: description,
      type: BreezErrorType.network,
      onRetry: onRetry,
      compact: compact,
    );
  }

  /// Создать виджет для ошибки сервера
  factory BreezErrorWidget.server({
    Key? key,
    String message = 'Ошибка сервера',
    String? description = 'Попробуйте позже или обратитесь в поддержку',
    VoidCallback? onRetry,
    bool compact = false,
  }) {
    return BreezErrorWidget(
      key: key,
      message: message,
      description: description,
      type: BreezErrorType.server,
      onRetry: onRetry,
      compact: compact,
    );
  }

  /// Создать виджет для пустого состояния / не найдено
  factory BreezErrorWidget.notFound({
    Key? key,
    String message = 'Ничего не найдено',
    String? description,
    VoidCallback? onRetry,
    bool compact = false,
  }) {
    return BreezErrorWidget(
      key: key,
      message: message,
      description: description,
      type: BreezErrorType.notFound,
      onRetry: onRetry,
      compact: compact,
    );
  }

  IconData get _icon {
    if (icon != null) return icon!;
    return switch (type) {
      BreezErrorType.network => Icons.wifi_off_rounded,
      BreezErrorType.server => Icons.cloud_off_rounded,
      BreezErrorType.notFound => Icons.search_off_rounded,
      BreezErrorType.warning => Icons.warning_amber_rounded,
      BreezErrorType.general => Icons.error_outline_rounded,
    };
  }

  Color get _iconColor {
    return switch (type) {
      BreezErrorType.warning => AppColors.warning,
      _ => AppColors.critical,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    if (compact) {
      return _buildCompact(context, colors);
    }
    return _buildFull(context, colors);
  }

  Widget _buildCompact(BuildContext context, BreezColors colors) {
    return Semantics(
      label: semanticLabel ?? message,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: _iconColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(_icon, color: _iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.text,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(width: 8),
              BreezButton(
                onTap: onRetry,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                backgroundColor: _iconColor.withValues(alpha: 0.15),
                hoverColor: _iconColor.withValues(alpha: 0.25),
                showBorder: false,
                semanticLabel: retryText,
                child: Text(
                  retryText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _iconColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFull(BuildContext context, BreezColors colors) {
    return Semantics(
      label: semanticLabel ?? message,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка с фоном
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon,
                  size: 40,
                  color: _iconColor,
                ),
              ),
              const SizedBox(height: 24),

              // Заголовок
              Text(
                message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colors.text,
                ),
                textAlign: TextAlign.center,
              ),

              // Описание
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              // Кнопки
              if (onRetry != null || onSecondaryAction != null) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onSecondaryAction != null && secondaryActionText != null)
                      BreezTextButton(
                        text: secondaryActionText!,
                        onPressed: onSecondaryAction,
                        semanticLabel: secondaryActionText,
                      ),
                    if (onSecondaryAction != null && onRetry != null)
                      const SizedBox(width: 12),
                    if (onRetry != null)
                      BreezDialogButton(
                        label: retryText,
                        onTap: onRetry!,
                        isPrimary: true,
                        semanticLabel: retryText,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline ошибка для форм и полей ввода
class BreezFieldError extends StatelessWidget {
  final String message;
  final bool visible;

  const BreezFieldError({
    super.key,
    required this.message,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible || message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'Ошибка: $message',
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              size: 14,
              color: AppColors.critical,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.critical,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Снэкбар для показа ошибок
class BreezErrorSnackbar {
  BreezErrorSnackbar._();

  /// Показать ошибку в SnackBar
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.critical,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  /// Показать предупреждение в SnackBar
  static void showWarning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}
