/// Loading State Widgets
///
/// Компоненты для отображения состояний загрузки в приложении.
/// Следует Material Design guidelines и паттернам из Big Tech компаний.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Базовый индикатор загрузки
///
/// Отображает circular progress indicator с опциональным текстом.
/// Используется для индикации процесса загрузки данных.
class LoadingIndicator extends StatelessWidget {
  /// Размер индикатора
  final double size;

  /// Цвет индикатора (по умолчанию accent color)
  final Color? color;

  /// Опциональный текст под индикатором
  final String? message;

  /// Толщина линии индикатора
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color,
    this.message,
    this.strokeWidth = 4.0,
  });

  /// Фабричный метод для маленького индикатора
  factory LoadingIndicator.small({Color? color}) {
    return LoadingIndicator(
      size: 20,
      strokeWidth: 2.5,
      color: color,
    );
  }

  /// Фабричный метод для большого индикатора с сообщением
  factory LoadingIndicator.large({
    required String message,
    Color? color,
  }) {
    return LoadingIndicator(
      size: 60,
      strokeWidth: 5.0,
      message: message,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.accent,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            message!,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              color: BreezColors.of(context).textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Полноэкранный overlay с индикатором загрузки
///
/// Блокирует весь UI и показывает индикатор загрузки по центру экрана.
/// Используется для критичных операций, требующих блокировки взаимодействия.
///
/// Пример использования:
/// ```dart
/// LoadingOverlay.show(
///   context,
///   message: 'Загрузка данных...',
/// );
///
/// // Выполнить асинхронную операцию
/// await fetchData();
///
/// LoadingOverlay.hide(context);
/// ```
class LoadingOverlay {
  /// Показать overlay с индикатором загрузки
  static void show(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (dialogContext) => PopScope(
        canPop: barrierDismissible,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: BreezColors.of(dialogContext).card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: LoadingIndicator.large(
              message: message ?? l10n.loading,
            ),
          ),
        ),
      ),
    );
  }

  /// Скрыть overlay
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

/// Линейный индикатор прогресса
///
/// Показывает прогресс выполнения операции от 0% до 100%.
/// Используется когда известен точный прогресс операции.
class LoadingProgressBar extends StatelessWidget {
  /// Текущий прогресс (0.0 - 1.0)
  final double? value;

  /// Цвет заполненной части
  final Color? color;

  /// Цвет фона
  final Color? backgroundColor;

  /// Высота индикатора
  final double height;

  /// Опциональный текст с процентами
  final bool showPercentage;

  const LoadingProgressBar({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.height = 4.0,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: value,
            minHeight: height,
            backgroundColor: backgroundColor ?? colors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.accent,
            ),
          ),
        ),
        if (showPercentage && value != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${(value! * 100).toInt()}%',
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Состояние загрузки для контента
///
/// Универсальный виджет для управления состояниями загрузки, ошибки и успеха.
/// Автоматически переключается между skeleton loader, error state и content.
class LoadingState<T> extends StatelessWidget {
  /// Статус загрузки
  final LoadingStatus status;

  /// Данные (опционально)
  final T? data;

  /// Сообщение об ошибке
  final String? errorMessage;

  /// Builder для успешного состояния с данными
  final Widget Function(BuildContext context, T data) builder;

  /// Skeleton loader для состояния загрузки
  final Widget? loadingSkeleton;

  /// Виджет для состояния ошибки
  final Widget Function(BuildContext context, String error)? errorBuilder;

  /// Callback для повторной попытки загрузки
  final VoidCallback? onRetry;

  const LoadingState({
    super.key,
    required this.status,
    this.data,
    this.errorMessage,
    required this.builder,
    this.loadingSkeleton,
    this.errorBuilder,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LoadingStatus.loading:
        return loadingSkeleton ??
            const Center(child: LoadingIndicator());

      case LoadingStatus.success:
        if (data != null) {
          return builder(context, data as T);
        }
        // Если данных нет, но статус success, показываем загрузку
        return loadingSkeleton ??
            const Center(child: LoadingIndicator());

      case LoadingStatus.error:
        final l10n = AppLocalizations.of(context)!;
        final errorText = errorMessage ?? l10n.errorOccurred;
        if (errorBuilder != null) {
          return errorBuilder!(context, errorText);
        }
        // Default error UI
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.critical,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                errorText,
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  color: BreezColors.of(context).text,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ],
          ),
        );
    }
  }
}

/// Статус загрузки
enum LoadingStatus {
  /// Загрузка в процессе
  loading,

  /// Успешная загрузка
  success,

  /// Ошибка загрузки
  error,
}

/// Pull-to-refresh обертка
///
/// Добавляет функционал pull-to-refresh к любому scrollable виджету.
class PullToRefreshWrapper extends StatelessWidget {
  /// Дочерний scrollable виджет
  final Widget child;

  /// Callback для обновления данных
  final Future<void> Function() onRefresh;

  /// Цвет индикатора
  final Color? color;

  const PullToRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? AppColors.accent,
      backgroundColor: BreezColors.of(context).card,
      child: child,
    );
  }
}
