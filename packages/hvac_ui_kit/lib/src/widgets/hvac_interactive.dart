/// HVAC UI Kit - Interactive Animations
///
/// Micro-interactions for better UX (tap, press, hover effects)
library;

import 'package:flutter/material.dart';

/// Interactive widget with scale animation on press
class HvacInteractiveScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final Duration duration;

  const HvacInteractiveScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.95,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<HvacInteractiveScale> createState() => _HvacInteractiveScaleState();
}

class _HvacInteractiveScaleState extends State<HvacInteractiveScale> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleDown : 1.0,
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

/// Interactive widget with elevation change on press
class HvacInteractiveElevation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedElevation;
  final double normalElevation;
  final Duration duration;

  const HvacInteractiveElevation({
    super.key,
    required this.child,
    this.onTap,
    this.pressedElevation = 0,
    this.normalElevation = 4,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<HvacInteractiveElevation> createState() => _HvacInteractiveElevationState();
}

class _HvacInteractiveElevationState extends State<HvacInteractiveElevation> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedPhysicalModel(
        duration: widget.duration,
        curve: Curves.easeInOut,
        elevation: _isPressed ? widget.pressedElevation : widget.normalElevation,
        color: Colors.transparent,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(12),
        child: widget.child,
      ),
    );
  }
}

/// Interactive widget with opacity change on press
class HvacInteractiveOpacity extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedOpacity;
  final Duration duration;

  const HvacInteractiveOpacity({
    super.key,
    required this.child,
    this.onTap,
    this.pressedOpacity = 0.6,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<HvacInteractiveOpacity> createState() => _HvacInteractiveOpacityState();
}

class _HvacInteractiveOpacityState extends State<HvacInteractiveOpacity> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedOpacity(
        opacity: _isPressed ? widget.pressedOpacity : 1.0,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}

/// Interactive widget with ripple effect
class HvacInteractiveRipple extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final BorderRadius? borderRadius;

  const HvacInteractiveRipple({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: rippleColor ?? Theme.of(context).primaryColor.withOpacity(0.2),
        highlightColor: rippleColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}

/// Bouncy button with spring animation
class HvacBouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const HvacBouncyButton({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<HvacBouncyButton> createState() => _HvacBouncyButtonState();
}

class _HvacBouncyButtonState extends State<HvacBouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Shake animation on error
class HvacShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool trigger;

  const HvacShakeAnimation({
    super.key,
    required this.child,
    required this.trigger,
  });

  @override
  State<HvacShakeAnimation> createState() => _HvacShakeAnimationState();
}

class _HvacShakeAnimationState extends State<HvacShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(HvacShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
