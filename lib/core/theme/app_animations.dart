/// App Animations - Централизованные константы анимаций
library;

import 'package:flutter/material.dart';

/// Стандартные длительности анимаций
///
/// Использование:
/// ```dart
/// AnimatedContainer(
///   duration: AppDurations.fast,
///   curve: AppCurves.easeOut,
///   // ...
/// )
/// ```
abstract final class AppDurations {
  /// Мгновенная анимация (50ms) - для микро-интеракций
  static const Duration instant = Duration(milliseconds: 50);

  /// Быстрая анимация (150ms) - hover, focus, небольшие изменения
  static const Duration fast = Duration(milliseconds: 150);

  /// Стандартная анимация (200ms) - большинство переходов
  static const Duration normal = Duration(milliseconds: 200);

  /// Средняя анимация (300ms) - раскрытие, сворачивание
  static const Duration medium = Duration(milliseconds: 300);

  /// Медленная анимация (400ms) - сложные переходы
  static const Duration slow = Duration(milliseconds: 400);

  /// Очень медленная анимация (600ms) - page transitions
  static const Duration slower = Duration(milliseconds: 600);

  /// Shimmer цикл (1500ms)
  static const Duration shimmer = Duration(milliseconds: 1500);
}

/// Стандартные кривые анимаций
abstract final class AppCurves {
  /// Стандартная Material кривая
  static const Curve standard = Curves.easeInOut;

  /// Ускорение в начале - для исчезновения элементов
  static const Curve easeIn = Curves.easeIn;

  /// Замедление в конце - для появления элементов
  static const Curve easeOut = Curves.easeOut;

  /// Быстрое начало, медленный конец - для emphasize
  static const Curve emphasize = Curves.easeOutCubic;

  /// Пружинящий эффект - для интерактивных элементов
  static const Curve bounce = Curves.elasticOut;

  /// Мягкий bounce - для кнопок
  static const Curve softBounce = Curves.easeOutBack;

  /// Плавное замедление - для scroll, списков
  static const Curve decelerate = Curves.decelerate;

  /// Линейная - для бесконечных анимаций (shimmer, loading)
  static const Curve linear = Curves.linear;

  /// Overshoot - выход за пределы и возврат
  static const Curve overshoot = Curves.easeOutBack;
}

/// Стандартные офсеты для staggered анимаций
abstract final class AppStagger {
  /// Задержка между элементами в списке (50ms)
  static const Duration listItem = Duration(milliseconds: 50);

  /// Задержка между карточками (100ms)
  static const Duration card = Duration(milliseconds: 100);

  /// Задержка между секциями (150ms)
  static const Duration section = Duration(milliseconds: 150);
}

/// Предустановленные Tween'ы для переиспользования
abstract final class AppTweens {
  /// Появление с прозрачности
  static final Tween<double> fadeIn = Tween(begin: 0, end: 1);

  /// Исчезновение
  static final Tween<double> fadeOut = Tween(begin: 1, end: 0);

  /// Масштабирование от 0.95 до 1.0 (subtle)
  static final Tween<double> scaleSubtle = Tween(begin: 0.95, end: 1);

  /// Масштабирование от 0.8 до 1.0 (medium)
  static final Tween<double> scaleMedium = Tween(begin: 0.8, end: 1);

  /// Масштабирование от 0 до 1.0 (full)
  static final Tween<double> scaleFull = Tween(begin: 0, end: 1);

  /// Сдвиг снизу (для появления)
  static final Tween<Offset> slideUp = Tween(
    begin: const Offset(0, 0.1),
    end: Offset.zero,
  );

  /// Сдвиг сверху
  static final Tween<Offset> slideDown = Tween(
    begin: const Offset(0, -0.1),
    end: Offset.zero,
  );

  /// Сдвиг слева
  static final Tween<Offset> slideLeft = Tween(
    begin: const Offset(-0.1, 0),
    end: Offset.zero,
  );

  /// Сдвиг справа
  static final Tween<Offset> slideRight = Tween(
    begin: const Offset(0.1, 0),
    end: Offset.zero,
  );
}

/// Extension для удобного создания анимированных переходов
extension AnimatedTransitionExtension on Widget {
  /// Обернуть в AnimatedSwitcher с настройками по умолчанию
  Widget withAnimatedSwitcher({
    Duration duration = AppDurations.normal,
    Curve switchInCurve = AppCurves.easeOut,
    Curve switchOutCurve = AppCurves.easeIn,
  }) => AnimatedSwitcher(
      duration: duration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      child: this,
    );
}
