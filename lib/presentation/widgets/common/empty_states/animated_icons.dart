/// Animated Icons for Empty States
/// Collection of animated icon widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Animated device icon with shimmer effect
class AnimatedDeviceIcon extends StatelessWidget {
  const AnimatedDeviceIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.r,
      height: 120.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: HvacColors.primaryOrange.withValues(alpha: 0.1),
      ),
      child: Icon(
        Icons.devices_other,
        size: 60.r,
        color: HvacColors.primaryOrange.withValues(alpha: 0.5),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 2000.ms, delay: 500.ms)
        .shake(hz: 0.5, curve: Curves.easeInOut);
  }
}

/// Animated chart icon with scale effect
class AnimatedChartIcon extends StatelessWidget {
  const AnimatedChartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120.r,
          height: 120.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: HvacColors.primaryOrange.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
        ),
        Icon(
          Icons.insert_chart_outlined,
          size: 60.r,
          color: HvacColors.textTertiary,
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 1000.ms)
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 1500.ms,
              curve: Curves.elasticOut,
            ),
      ],
    );
  }
}

/// Animated bell icon with rotation effect
class AnimatedBellIcon extends StatefulWidget {
  const AnimatedBellIcon({super.key});

  @override
  State<AnimatedBellIcon> createState() => _AnimatedBellIconState();
}

class _AnimatedBellIconState extends State<AnimatedBellIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 0.05),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.05, end: -0.05),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.05, end: 0.05),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.05, end: 0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0),
        weight: 10,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) => Transform.rotate(
        angle: _rotationAnimation.value,
        child: Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                HvacColors.primaryOrange.withValues(alpha: 0.1),
                HvacColors.primaryOrange.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            Icons.notifications_none,
            size: 50.r,
            color: HvacColors.textTertiary,
          ),
        ),
      ),
    );
  }
}

/// Animated search icon with scale effect
class AnimatedSearchIcon extends StatelessWidget {
  const AnimatedSearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: HvacColors.backgroundCard,
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
              width: 2,
            ),
          ),
        ),
        Icon(
          Icons.search_off,
          size: 50.r,
          color: HvacColors.textTertiary,
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn(duration: 1000.ms)
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
              duration: 2000.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }
}

/// Animated wifi icon with shake effect
class AnimatedWifiIcon extends StatelessWidget {
  const AnimatedWifiIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.wifi_off,
          size: 80.r,
          color: HvacColors.error.withValues(alpha: 0.5),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 500.ms)
            .then()
            .shake(hz: 2, curve: Curves.easeInOut)
            .then(delay: 2000.ms),
      ],
    );
  }
}

/// Static permission icon
class PermissionIcon extends StatelessWidget {
  const PermissionIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.r,
      height: 100.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: HvacColors.warning.withValues(alpha: 0.1),
      ),
      child: Icon(
        Icons.lock_outline,
        size: 50.r,
        color: HvacColors.warning,
      ),
    );
  }
}

/// Animated maintenance icon with rotation
class AnimatedMaintenanceIcon extends StatelessWidget {
  const AnimatedMaintenanceIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.construction,
      size: 80.r,
      color: HvacColors.warning,
    )
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: 3000.ms, curve: Curves.linear);
  }
}