/// Shimmer Loading Effect
///
/// Реализация shimmer эффекта для skeleton screens по стандартам Big Tech.
/// Вдохновлено Facebook Shimmer и Material Design guidelines.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Shimmer эффект для skeleton loaders
///
/// Создает анимированный градиент, который перемещается слева направо,
/// создавая эффект "мерцания" (shimmer). Используется для индикации загрузки
/// контента, когда точный размер и форма элементов известны заранее.
///
/// Пример использования:
/// ```dart
/// Shimmer(
///   child: Container(
///     width: 200,
///     height: 100,
///     color: Colors.white,
///   ),
/// )
/// ```
class Shimmer extends StatefulWidget {
  /// Дочерний виджет, к которому применяется shimmer эффект
  final Widget child;

  /// Базовый цвет (обычно цвет фона). Если null, использует цвет темы.
  final Color? baseColor;

  /// Цвет подсветки (цвет "блика"). Если null, использует цвет темы.
  final Color? highlightColor;

  /// Длительность одного цикла анимации
  final Duration period;

  /// Направление анимации
  final ShimmerDirection direction;

  const Shimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.leftToRight,
  });

  /// Фабричный метод для создания shimmer с темной темой
  factory Shimmer.dark({
    required Widget child,
    Duration period = const Duration(milliseconds: 1500),
    ShimmerDirection direction = ShimmerDirection.leftToRight,
  }) {
    return Shimmer(
      baseColor: AppColors.darkShimmerBase,
      highlightColor: AppColors.darkShimmerHighlight,
      period: period,
      direction: direction,
      child: child,
    );
  }

  /// Фабричный метод для создания shimmer со светлой темой
  factory Shimmer.light({
    required Widget child,
    Duration period = const Duration(milliseconds: 1500),
    ShimmerDirection direction = ShimmerDirection.leftToRight,
  }) {
    return Shimmer(
      baseColor: AppColors.lightShimmerBase,
      highlightColor: AppColors.lightShimmerHighlight,
      period: period,
      direction: direction,
      child: child,
    );
  }

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Создаем контроллер анимации
    _controller = AnimationController(
      vsync: this,
      duration: widget.period,
    );

    // Создаем линейную анимацию от 0 до 1
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Запускаем бесконечную анимацию
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = widget.baseColor ??
        (isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase);
    final highlightColor = widget.highlightColor ??
        (isDark ? AppColors.darkShimmerHighlight : AppColors.lightShimmerHighlight);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              begin: _getBeginAlignment(),
              end: _getEndAlignment(),
              transform: _SlidingGradientTransform(
                slidePercent: _animation.value,
                direction: widget.direction,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }

  Alignment _getBeginAlignment() {
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        return Alignment.centerLeft;
      case ShimmerDirection.rightToLeft:
        return Alignment.centerRight;
      case ShimmerDirection.topToBottom:
        return Alignment.topCenter;
      case ShimmerDirection.bottomToTop:
        return Alignment.bottomCenter;
    }
  }

  Alignment _getEndAlignment() {
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        return Alignment.centerRight;
      case ShimmerDirection.rightToLeft:
        return Alignment.centerLeft;
      case ShimmerDirection.topToBottom:
        return Alignment.bottomCenter;
      case ShimmerDirection.bottomToTop:
        return Alignment.topCenter;
    }
  }
}

/// Направление анимации shimmer эффекта
enum ShimmerDirection {
  /// Слева направо (по умолчанию)
  leftToRight,

  /// Справа налево
  rightToLeft,

  /// Сверху вниз
  topToBottom,

  /// Снизу вверх
  bottomToTop,
}

/// Трансформация градиента для создания эффекта скольжения
///
/// Используется внутри Shimmer для анимации перемещения градиента.
/// Реализует GradientTransform для корректной работы с LinearGradient.
class _SlidingGradientTransform extends GradientTransform {
  /// Процент выполнения анимации (0.0 - 1.0)
  final double slidePercent;

  /// Направление анимации
  final ShimmerDirection direction;

  const _SlidingGradientTransform({
    required this.slidePercent,
    required this.direction,
  });

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // Рассчитываем смещение на основе процента анимации
    double dx = 0;
    double dy = 0;

    switch (direction) {
      case ShimmerDirection.leftToRight:
      case ShimmerDirection.rightToLeft:
        dx = bounds.width * (slidePercent - 0.5) * 2;
        break;
      case ShimmerDirection.topToBottom:
      case ShimmerDirection.bottomToTop:
        dy = bounds.height * (slidePercent - 0.5) * 2;
        break;
    }

    return Matrix4.translationValues(dx, dy, 0.0);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _SlidingGradientTransform &&
        other.slidePercent == slidePercent &&
        other.direction == direction;
  }

  @override
  int get hashCode => Object.hash(slidePercent, direction);
}

/// Утилитный класс для получения shimmer с учетом текущей темы
class ShimmerUtil {
  /// Получить shimmer эффект с цветами, соответствующими текущей теме
  static Widget fromTheme({
    required BuildContext context,
    required Widget child,
    Duration period = const Duration(milliseconds: 1500),
    ShimmerDirection direction = ShimmerDirection.leftToRight,
  }) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Shimmer(
      baseColor: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
      highlightColor: isDark ? AppColors.darkShimmerHighlight : AppColors.lightShimmerHighlight,
      period: period,
      direction: direction,
      child: child,
    );
  }
}
