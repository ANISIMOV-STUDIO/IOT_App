/// BREEZ Page Transitions - Переходы между страницами
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_animations.dart';

/// Типы переходов между страницами
enum BreezTransitionType {
  /// Fade - простое затухание/появление
  fade,

  /// Slide - сдвиг справа налево (iOS style)
  slideRight,

  /// Slide - сдвиг снизу вверх (modal style)
  slideUp,

  /// Scale - масштабирование с fade
  scale,

  /// Shared axis - Material Design 3 style
  sharedAxisX,

  /// Shared axis vertical
  sharedAxisY,

  /// Нет анимации
  none,
}

/// Кастомный PageRoute с настраиваемыми переходами
class BreezPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final BreezTransitionType transitionType;
  final Duration? customDuration;
  final Curve? customCurve;

  BreezPageRoute({
    required this.page,
    this.transitionType = BreezTransitionType.fade,
    this.customDuration,
    this.customCurve,
    super.settings,
    super.fullscreenDialog,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: customDuration ?? _getDuration(transitionType),
          reverseTransitionDuration:
              customDuration ?? _getDuration(transitionType),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              transitionType,
              animation,
              secondaryAnimation,
              child,
              customCurve,
            );
          },
        );

  static Duration _getDuration(BreezTransitionType type) {
    return switch (type) {
      BreezTransitionType.none => Duration.zero,
      BreezTransitionType.fade => AppDurations.normal,
      BreezTransitionType.slideRight => AppDurations.medium,
      BreezTransitionType.slideUp => AppDurations.medium,
      BreezTransitionType.scale => AppDurations.normal,
      BreezTransitionType.sharedAxisX => AppDurations.medium,
      BreezTransitionType.sharedAxisY => AppDurations.medium,
    };
  }

  static Widget _buildTransition(
    BreezTransitionType type,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Curve? customCurve,
  ) {
    final curve = customCurve ?? AppCurves.easeOut;
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    return switch (type) {
      BreezTransitionType.none => child,
      BreezTransitionType.fade => FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      BreezTransitionType.slideRight => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        ),
      BreezTransitionType.slideUp => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        ),
      BreezTransitionType.scale => ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        ),
      BreezTransitionType.sharedAxisX => _SharedAxisTransition(
          animation: curvedAnimation,
          secondaryAnimation: secondaryAnimation,
          isHorizontal: true,
          child: child,
        ),
      BreezTransitionType.sharedAxisY => _SharedAxisTransition(
          animation: curvedAnimation,
          secondaryAnimation: secondaryAnimation,
          isHorizontal: false,
          child: child,
        ),
    };
  }
}

/// Material 3 Shared Axis переход
class _SharedAxisTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool isHorizontal;
  final Widget child;

  const _SharedAxisTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.isHorizontal,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Входящая страница: сдвигается и появляется
    final slideIn = Tween<Offset>(
      begin: Offset(isHorizontal ? 0.3 : 0.0, isHorizontal ? 0.0 : 0.3),
      end: Offset.zero,
    ).animate(animation);

    // Уходящая страница: сдвигается и исчезает
    final slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(isHorizontal ? -0.3 : 0.0, isHorizontal ? 0.0 : -0.3),
    ).animate(secondaryAnimation);

    return SlideTransition(
      position: slideIn,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: slideOut,
          child: FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0)
                .animate(secondaryAnimation),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// PageTransitionsTheme для использования в ThemeData
class BreezPageTransitionsTheme extends PageTransitionsTheme {
  final BreezTransitionType defaultTransition;

  const BreezPageTransitionsTheme({
    this.defaultTransition = BreezTransitionType.fade,
  }) : super(builders: const {});

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Используем стандартный Material переход для совместимости
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: AppCurves.easeOut,
      ),
      child: child,
    );
  }
}

/// Extension для Navigator с удобными методами навигации
extension BreezNavigatorExtension on NavigatorState {
  /// Перейти на страницу с fade анимацией
  Future<T?> pushFade<T>(Widget page, {RouteSettings? settings}) {
    return push<T>(BreezPageRoute(
      page: page,
      transitionType: BreezTransitionType.fade,
      settings: settings,
    ));
  }

  /// Перейти на страницу с slide справа
  Future<T?> pushSlide<T>(Widget page, {RouteSettings? settings}) {
    return push<T>(BreezPageRoute(
      page: page,
      transitionType: BreezTransitionType.slideRight,
      settings: settings,
    ));
  }

  /// Открыть модальную страницу (slide снизу)
  Future<T?> pushModal<T>(Widget page, {RouteSettings? settings}) {
    return push<T>(BreezPageRoute(
      page: page,
      transitionType: BreezTransitionType.slideUp,
      settings: settings,
      fullscreenDialog: true,
    ));
  }

  /// Заменить страницу с fade
  Future<T?> pushReplacementFade<T, TO>(
    Widget page, {
    RouteSettings? settings,
    TO? result,
  }) {
    return pushReplacement<T, TO>(
      BreezPageRoute(
        page: page,
        transitionType: BreezTransitionType.fade,
        settings: settings,
      ),
      result: result,
    );
  }
}

/// Extension для BuildContext с удобной навигацией
extension BreezNavigationExtension on BuildContext {
  /// Получить NavigatorState
  NavigatorState get navigator => Navigator.of(this);

  /// Перейти на страницу с fade
  Future<T?> pushFade<T>(Widget page, {String? routeName}) {
    return navigator.pushFade<T>(
      page,
      settings: routeName != null ? RouteSettings(name: routeName) : null,
    );
  }

  /// Перейти на страницу с slide
  Future<T?> pushSlide<T>(Widget page, {String? routeName}) {
    return navigator.pushSlide<T>(
      page,
      settings: routeName != null ? RouteSettings(name: routeName) : null,
    );
  }

  /// Открыть модальную страницу
  Future<T?> pushModal<T>(Widget page, {String? routeName}) {
    return navigator.pushModal<T>(
      page,
      settings: routeName != null ? RouteSettings(name: routeName) : null,
    );
  }

  /// Вернуться назад
  void pop<T>([T? result]) => navigator.pop<T>(result);

  /// Можно ли вернуться назад
  bool get canPop => navigator.canPop();
}
