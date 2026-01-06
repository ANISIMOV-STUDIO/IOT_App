/// BREEZ Animated Widgets - Виджеты с анимациями появления
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_animations.dart';

/// Направление анимации появления
enum BreezSlideDirection {
  up,
  down,
  left,
  right,
}

/// Анимация появления с fade
///
/// Автоматически запускается при первом build или по триггеру [animate]
class BreezFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool animate;
  final VoidCallback? onComplete;

  const BreezFadeIn({
    super.key,
    required this.child,
    this.duration = AppDurations.normal,
    this.delay = Duration.zero,
    this.curve = AppCurves.easeOut,
    this.animate = true,
    this.onComplete,
  });

  @override
  State<BreezFadeIn> createState() => _BreezFadeInState();
}

class _BreezFadeInState extends State<BreezFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.animate) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    if (widget.delay > Duration.zero) {
      await Future.delayed(widget.delay);
    }
    if (mounted) {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
    }
  }

  @override
  void didUpdateWidget(BreezFadeIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.reset();
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

/// Анимация появления со сдвигом
class BreezSlideIn extends StatefulWidget {
  final Widget child;
  final BreezSlideDirection direction;
  final double offset;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool animate;
  final bool fade;
  final VoidCallback? onComplete;

  const BreezSlideIn({
    super.key,
    required this.child,
    this.direction = BreezSlideDirection.up,
    this.offset = 0.1,
    this.duration = AppDurations.medium,
    this.delay = Duration.zero,
    this.curve = AppCurves.easeOut,
    this.animate = true,
    this.fade = true,
    this.onComplete,
  });

  /// Появление снизу
  const BreezSlideIn.up({
    super.key,
    required this.child,
    this.offset = 0.1,
    this.duration = AppDurations.medium,
    this.delay = Duration.zero,
    this.curve = AppCurves.easeOut,
    this.animate = true,
    this.fade = true,
    this.onComplete,
  }) : direction = BreezSlideDirection.up;

  /// Появление сверху
  const BreezSlideIn.down({
    super.key,
    required this.child,
    this.offset = 0.1,
    this.duration = AppDurations.medium,
    this.delay = Duration.zero,
    this.curve = AppCurves.easeOut,
    this.animate = true,
    this.fade = true,
    this.onComplete,
  }) : direction = BreezSlideDirection.down;

  /// Появление слева
  const BreezSlideIn.left({
    super.key,
    required this.child,
    this.offset = 0.1,
    this.duration = AppDurations.medium,
    this.delay = Duration.zero,
    this.curve = AppCurves.easeOut,
    this.animate = true,
    this.fade = true,
    this.onComplete,
  }) : direction = BreezSlideDirection.left;

  /// Появление справа
  const BreezSlideIn.right({
    super.key,
    required this.child,
    this.offset = 0.1,
    this.duration = AppDurations.medium,
    this.delay = Duration.zero,
    this.curve = AppCurves.easeOut,
    this.animate = true,
    this.fade = true,
    this.onComplete,
  }) : direction = BreezSlideDirection.right;

  @override
  State<BreezSlideIn> createState() => _BreezSlideInState();
}

class _BreezSlideInState extends State<BreezSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _slideAnimation = Tween<Offset>(
      begin: _getBeginOffset(),
      end: Offset.zero,
    ).animate(curvedAnimation);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curvedAnimation);

    if (widget.animate) {
      _startAnimation();
    }
  }

  Offset _getBeginOffset() {
    return switch (widget.direction) {
      BreezSlideDirection.up => Offset(0, widget.offset),
      BreezSlideDirection.down => Offset(0, -widget.offset),
      BreezSlideDirection.left => Offset(-widget.offset, 0),
      BreezSlideDirection.right => Offset(widget.offset, 0),
    };
  }

  void _startAnimation() async {
    if (widget.delay > Duration.zero) {
      await Future.delayed(widget.delay);
    }
    if (mounted) {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
    }
  }

  @override
  void didUpdateWidget(BreezSlideIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.reset();
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );

    if (widget.fade) {
      result = FadeTransition(
        opacity: _fadeAnimation,
        child: result,
      );
    }

    return result;
  }
}

/// Анимация появления с масштабированием
class BreezScaleIn extends StatefulWidget {
  final Widget child;
  final double beginScale;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool animate;
  final bool fade;
  final Alignment alignment;
  final VoidCallback? onComplete;

  const BreezScaleIn({
    super.key,
    required this.child,
    this.beginScale = 0.95,
    this.duration = AppDurations.normal,
    this.delay = Duration.zero,
    this.curve = AppCurves.easeOut,
    this.animate = true,
    this.fade = true,
    this.alignment = Alignment.center,
    this.onComplete,
  });

  @override
  State<BreezScaleIn> createState() => _BreezScaleInState();
}

class _BreezScaleInState extends State<BreezScaleIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.beginScale,
      end: 1.0,
    ).animate(curvedAnimation);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curvedAnimation);

    if (widget.animate) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    if (widget.delay > Duration.zero) {
      await Future.delayed(widget.delay);
    }
    if (mounted) {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
    }
  }

  @override
  void didUpdateWidget(BreezScaleIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.reset();
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = ScaleTransition(
      scale: _scaleAnimation,
      alignment: widget.alignment,
      child: widget.child,
    );

    if (widget.fade) {
      result = FadeTransition(
        opacity: _fadeAnimation,
        child: result,
      );
    }

    return result;
  }
}

/// Staggered анимация для списков - анимирует элементы с задержкой
class BreezStaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDuration;
  final Duration staggerDelay;
  final BreezSlideDirection direction;
  final double offset;
  final Curve curve;
  final bool fade;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const BreezStaggeredList({
    super.key,
    required this.children,
    this.itemDuration = AppDurations.medium,
    this.staggerDelay = AppStagger.listItem,
    this.direction = BreezSlideDirection.up,
    this.offset = 0.1,
    this.curve = AppCurves.easeOut,
    this.fade = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (int i = 0; i < children.length; i++)
          BreezSlideIn(
            direction: direction,
            offset: offset,
            duration: itemDuration,
            delay: staggerDelay * i,
            curve: curve,
            fade: fade,
            child: children[i],
          ),
      ],
    );
  }
}

/// Staggered анимация для горизонтального списка
class BreezStaggeredRow extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDuration;
  final Duration staggerDelay;
  final BreezSlideDirection direction;
  final double offset;
  final Curve curve;
  final bool fade;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const BreezStaggeredRow({
    super.key,
    required this.children,
    this.itemDuration = AppDurations.medium,
    this.staggerDelay = AppStagger.listItem,
    this.direction = BreezSlideDirection.left,
    this.offset = 0.1,
    this.curve = AppCurves.easeOut,
    this.fade = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (int i = 0; i < children.length; i++)
          BreezSlideIn(
            direction: direction,
            offset: offset,
            duration: itemDuration,
            delay: staggerDelay * i,
            curve: curve,
            fade: fade,
            child: children[i],
          ),
      ],
    );
  }
}

/// Animated visibility - показывает/скрывает с анимацией
class BreezAnimatedVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool maintainState;
  final bool maintainSize;

  const BreezAnimatedVisibility({
    super.key,
    required this.visible,
    required this.child,
    this.duration = AppDurations.normal,
    this.curve = AppCurves.easeOut,
    this.maintainState = false,
    this.maintainSize = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: AnimatedScale(
        scale: visible ? 1.0 : 0.95,
        duration: duration,
        curve: curve,
        child: Visibility(
          visible: visible || maintainState || maintainSize,
          maintainState: maintainState,
          maintainSize: maintainSize,
          maintainAnimation: maintainState,
          child: child,
        ),
      ),
    );
  }
}

/// Пульсирующая анимация для привлечения внимания
class BreezPulse extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool animate;

  const BreezPulse({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.animate = true,
  });

  @override
  State<BreezPulse> createState() => _BreezPulseState();
}

class _BreezPulseState extends State<BreezPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(BreezPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return widget.child;
    }

    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
