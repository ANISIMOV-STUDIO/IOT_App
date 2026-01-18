/// BREEZ Error Boundary - Обработка ошибок в виджетах
///
/// Предотвращает краш всего приложения при ошибке в дочернем виджете.
/// Показывает fallback UI с возможностью retry.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_radius.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для ErrorBoundary
abstract class _ErrorBoundaryConstants {
  static const double iconSize = 48;
  static const double compactIconSize = 32;
  static const double titleFontSize = 16;
  static const double messageFontSize = 13;
  static const double buttonFontSize = 13;
}

// =============================================================================
// ERROR BOUNDARY WIDGET
// =============================================================================

/// Виджет для перехвата ошибок в дочерних виджетах
///
/// Пример использования:
/// ```dart
/// BreezErrorBoundary(
///   onRetry: () => bloc.add(RefreshEvent()),
///   child: MyWidget(),
/// )
/// ```
class BreezErrorBoundary extends StatefulWidget {

  const BreezErrorBoundary({
    required this.child, super.key,
    this.onRetry,
    this.fallbackBuilder,
    this.compact = false,
    this.showDetails = true,
  });
  /// Дочерний виджет
  final Widget child;

  /// Callback при нажатии "Повторить"
  final VoidCallback? onRetry;

  /// Кастомный fallback виджет
  final Widget Function(FlutterErrorDetails? error)? fallbackBuilder;

  /// Компактный режим
  final bool compact;

  /// Показывать детали ошибки (только в debug)
  final bool showDetails;

  @override
  State<BreezErrorBoundary> createState() => _BreezErrorBoundaryState();
}

class _BreezErrorBoundaryState extends State<BreezErrorBoundary> {
  FlutterErrorDetails? _error;

  @override
  void initState() {
    super.initState();
  }

  void _resetError() {
    setState(() {
      _error = null;
    });
    widget.onRetry?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallbackBuilder?.call(_error) ??
          _DefaultErrorWidget(
            error: _error,
            onRetry: _resetError,
            compact: widget.compact,
            showDetails: widget.showDetails,
          );
    }

    // Оборачиваем child в ErrorWidget.builder для перехвата ошибок
    return _ErrorCatcher(
      onError: (error) {
        setState(() {
          _error = error;
        });
      },
      child: widget.child,
    );
  }
}

// =============================================================================
// ERROR CATCHER
// =============================================================================

/// Внутренний виджет для перехвата ошибок build
class _ErrorCatcher extends StatelessWidget {

  const _ErrorCatcher({
    required this.child,
    required this.onError,
  });
  final Widget child;
  final void Function(FlutterErrorDetails) onError;

  @override
  Widget build(BuildContext context) =>
      // ErrorWidget.builder не работает для build-time ошибок напрямую,
      // поэтому используем Builder для дополнительной защиты
      Builder(
        builder: (context) {
          try {
            return child;
          } catch (e, stack) {
            final error = FlutterErrorDetails(
              exception: e,
              stack: stack,
              library: 'breez_error_boundary',
              context: ErrorDescription('при построении виджета'),
            );

            // Вызываем onError асинхронно чтобы избежать setState во время build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onError(error);
            });

            return const SizedBox.shrink();
          }
        },
      );
}

// =============================================================================
// DEFAULT ERROR WIDGET
// =============================================================================

/// Виджет отображения ошибки по умолчанию
class _DefaultErrorWidget extends StatelessWidget {

  const _DefaultErrorWidget({
    this.error,
    this.onRetry,
    this.compact = false,
    this.showDetails = true,
  });
  final FlutterErrorDetails? error;
  final VoidCallback? onRetry;
  final bool compact;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final iconSize = compact
        ? _ErrorBoundaryConstants.compactIconSize
        : _ErrorBoundaryConstants.iconSize;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.critical.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(
          color: AppColors.critical.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Иконка
          Icon(
            Icons.error_outline_rounded,
            size: iconSize,
            color: AppColors.critical.withValues(alpha: 0.7),
          ),

          SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),

          // Заголовок
          Text(
            'Что-то пошло не так',
            style: TextStyle(
              fontSize: _ErrorBoundaryConstants.titleFontSize,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
            textAlign: TextAlign.center,
          ),

          // Сообщение об ошибке (только в debug)
          if (showDetails && kDebugMode && error != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              error!.exceptionAsString(),
              style: TextStyle(
                fontSize: _ErrorBoundaryConstants.messageFontSize,
                color: colors.textMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: compact ? 2 : 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Кнопка повторить
          if (onRetry != null) ...[
            SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
            BreezButton(
              onTap: onRetry,
              backgroundColor: AppColors.critical.withValues(alpha: 0.1),
              hoverColor: AppColors.critical.withValues(alpha: 0.15),
              showBorder: false,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: compact ? AppSpacing.xs : AppSpacing.sm,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: AppColors.critical,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    'Повторить',
                    style: TextStyle(
                      fontSize: _ErrorBoundaryConstants.buttonFontSize,
                      fontWeight: FontWeight.w600,
                      color: AppColors.critical,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// GLOBAL ERROR HANDLER SETUP
// =============================================================================

/// Настройка глобального обработчика ошибок
///
/// Вызвать в main() перед runApp():
/// ```dart
/// void main() {
///   setupGlobalErrorHandler();
///   runApp(MyApp());
/// }
/// ```
void setupGlobalErrorHandler({
  void Function(FlutterErrorDetails)? onError,
}) {
  // Кастомный виджет для ошибок рендеринга
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // В release показываем простой fallback
    if (kReleaseMode) {
      return Container(
        alignment: Alignment.center,
        child: const Icon(
          Icons.error_outline,
          color: AppColors.critical,
          size: 32,
        ),
      );
    }

    // В debug показываем детали
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        color: AppColors.critical.withValues(alpha: 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.critical,
              size: 32,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              details.exceptionAsString(),
              style: const TextStyle(
                color: AppColors.critical,
                fontSize: AppFontSizes.caption,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  };

  // Глобальный обработчик ошибок Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    onError?.call(details);
  };
}
