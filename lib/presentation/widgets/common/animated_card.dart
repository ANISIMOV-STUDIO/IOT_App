/// Animated Card Widget
/// Card with entrance animations using flutter_animate
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/animation_constants.dart';
import '../../../core/theme/app_theme.dart';

class AnimatedCard extends StatelessWidget {
  final Widget child;
  final int delay;
  final VoidCallback? onTap;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final bool enableAnimation;

  const AnimatedCard({
    super.key,
    required this.child,
    this.delay = 0,
    this.onTap,
    this.decoration,
    this.padding,
    this.enableAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: decoration ?? AppTheme.roundedCard(),
      padding: padding ?? AppTheme.cardPadding,
      child: child,
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      );
    }

    if (!enableAnimation) {
      return card;
    }

    return card
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(
          duration: AnimationConstants.cardFadeIn,
          curve: AnimationConstants.cardCurve,
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: AnimationConstants.cardSlideIn,
          curve: AnimationConstants.cardCurve,
        );
  }
}

class AnimatedDeviceCard extends StatelessWidget {
  final Widget child;
  final int delay;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsets? padding;

  const AnimatedDeviceCard({
    super.key,
    required this.child,
    this.delay = 0,
    this.onTap,
    this.isSelected = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      delay: delay,
      onTap: onTap,
      decoration: AppTheme.deviceCard(isSelected: isSelected),
      padding: padding ?? AppTheme.cardPadding,
      child: child,
    );
  }
}
