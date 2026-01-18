/// Breez Loader - Тематический лоадер для HVAC приложения
///
/// Вращающийся вентилятор для индикации загрузки.
/// Используется везде где система ожидает ответа от сервера.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:material_symbols_icons/symbols.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _LoaderConstants {
  // Sizes
  static const double sizeSmall = 16;
  static const double sizeMedium = 24;
  static const double sizeLarge = 32;

  // Animation
  static const Duration rotationDuration = Duration(milliseconds: 1200);
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Тематический лоадер для HVAC приложения
///
/// Вращающийся вентилятор. Используется для:
/// - Ожидания ответа сервера при изменении температуры
/// - Переключения режимов работы
/// - Загрузки данных датчиков
/// - Любых операций требующих ожидания
///
/// ```dart
/// // Базовое использование
/// BreezLoader()
///
/// // Маленький размер для inline
/// BreezLoader.small()
///
/// // Большой с кастомным цветом
/// BreezLoader.large(color: AppColors.white)
/// ```
class BreezLoader extends StatefulWidget {

  const BreezLoader({
    super.key,
    this.size = _LoaderConstants.sizeMedium,
    this.color,
  });

  /// Большой лоадер (32px) - для центрированного отображения
  const BreezLoader.large({
    super.key,
    this.color,
  }) : size = _LoaderConstants.sizeLarge;

  /// Маленький лоадер (16px) - для inline использования
  const BreezLoader.small({
    super.key,
    this.color,
  }) : size = _LoaderConstants.sizeSmall;

  /// Средний лоадер (24px) - стандартный размер
  const BreezLoader.medium({
    super.key,
    this.color,
  }) : size = _LoaderConstants.sizeMedium;
  /// Размер иконки
  final double size;

  /// Цвет иконки (по умолчанию AppColors.accent)
  final Color? color;

  @override
  State<BreezLoader> createState() => _BreezLoaderState();
}

class _BreezLoaderState extends State<BreezLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _LoaderConstants.rotationDuration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.accent;

    return Semantics(
      label: 'Loading',
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform.rotate(
              angle: _controller.value * math.pi * 2,
              child: child,
            ),
          child: Icon(
            Symbols.mode_fan,
            size: widget.size,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Лоадер с текстом
///
/// Показывает вращающуюся иконку с опциональным текстом снизу.
/// Используется для полноэкранных состояний загрузки.
class BreezLoaderWithText extends StatelessWidget {

  const BreezLoaderWithText({
    super.key,
    this.text,
    this.size = _LoaderConstants.sizeLarge,
    this.color,
  });
  /// Текст под лоадером
  final String? text;

  /// Размер иконки
  final double size;

  /// Цвет иконки
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      label: text ?? 'Loading',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BreezLoader(size: size, color: color),
          if (text != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              text!,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                color: colors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
