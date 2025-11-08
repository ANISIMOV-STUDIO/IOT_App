/// Animated Card Widget for HVAC UI Kit
///
/// Provides entrance animations using built-in Flutter animations
library;

import 'package:flutter/material.dart';
import '../../theme/decorations.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';

/// Card with entrance animations
///
/// Features:
/// - Fade-in and slide-up entrance animations
/// - Configurable delay for staggered animations
/// - Optional tap interaction
/// - Custom decoration support
/// - Can disable animations
///
/// Usage:
/// ```dart
/// HvacAnimatedCard(
///   delay: Duration(milliseconds: 100),
///   onTap: () => handleTap(),
///   child: Text('Content'),
/// )
/// ```
class HvacAnimatedCard extends StatefulWidget {
  /// Child widget to display in the card
  final Widget child;

  /// Animation delay (for staggered animations)
  final Duration delay;

  /// Tap callback
  final VoidCallback? onTap;

  /// Custom decoration (defaults to HvacDecorations.card())
  final BoxDecoration? decoration;

  /// Card padding (defaults to HvacSpacing.cardPadding)
  final EdgeInsets? padding;

  /// Enable/disable entrance animation
  final bool enableAnimation;

  /// Fade-in animation duration
  final Duration fadeInDuration;

  /// Slide-in animation duration
  final Duration slideInDuration;

  /// Animation curve
  final Curve animationCurve;

  /// Slide vertical offset in pixels
  final double slideOffset;

  const HvacAnimatedCard({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.onTap,
    this.decoration,
    this.padding,
    this.enableAnimation = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.slideInDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeOutCubic,
    this.slideOffset = 20.0,
  });

  @override
  State<HvacAnimatedCard> createState() => _HvacAnimatedCardState();
}

class _HvacAnimatedCardState extends State<HvacAnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.slideInDuration,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          widget.fadeInDuration.inMilliseconds /
              widget.slideInDuration.inMilliseconds,
          curve: widget.animationCurve,
        ),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );

    if (widget.enableAnimation) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: widget.decoration ?? HvacDecorations.card(),
      padding: widget.padding ?? HvacSpacing.cardPadding,
      child: widget.child,
    );

    if (widget.onTap != null) {
      card = InkWell(
        onTap: widget.onTap,
        borderRadius: HvacRadius.lgRadius,
        child: card,
      );
    }

    if (!widget.enableAnimation) {
      return card;
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Transform.translate(
        offset: _slideAnimation.value,
        child: card,
      ),
    );
  }
}

/// Animated device card with selection state
///
/// Specialized card for HVAC device displays with selection highlighting
///
/// Usage:
/// ```dart
/// HvacAnimatedDeviceCard(
///   isSelected: true,
///   delay: Duration(milliseconds: 100),
///   onTap: () => selectDevice(),
///   child: DeviceContent(),
/// )
/// ```
class HvacAnimatedDeviceCard extends StatelessWidget {
  /// Child widget to display in the card
  final Widget child;

  /// Animation delay
  final Duration delay;

  /// Tap callback
  final VoidCallback? onTap;

  /// Whether the device is selected
  final bool isSelected;

  /// Card padding (defaults to HvacSpacing.cardPadding)
  final EdgeInsets? padding;

  /// Enable/disable entrance animation
  final bool enableAnimation;

  const HvacAnimatedDeviceCard({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.onTap,
    this.isSelected = false,
    this.padding,
    this.enableAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return HvacAnimatedCard(
      delay: delay,
      onTap: onTap,
      decoration: HvacDecorations.card(
        // Use elevated card for selected state
        shadow: isSelected ? null : null,
      ),
      padding: padding ?? HvacSpacing.cardPadding,
      enableAnimation: enableAnimation,
      child: child,
    );
  }
}

/// Grid of animated cards with staggered entrance animations
///
/// Automatically calculates delays for staggered effect
///
/// Usage:
/// ```dart
/// HvacAnimatedCardGrid(
///   cards: [
///     Card1(),
///     Card2(),
///   ],
///   staggerDelay: Duration(milliseconds: 80),
/// )
/// ```
class HvacAnimatedCardGrid extends StatelessWidget {
  /// List of widgets to display in cards
  final List<Widget> cards;

  /// Delay between each card animation
  final Duration staggerDelay;

  /// Cross-axis count for grid
  final int crossAxisCount;

  /// Cross-axis spacing
  final double crossAxisSpacing;

  /// Main-axis spacing
  final double mainAxisSpacing;

  /// Child aspect ratio
  final double childAspectRatio;

  const HvacAnimatedCardGrid({
    super.key,
    required this.cards,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.crossAxisCount = 2,
    this.crossAxisSpacing = HvacSpacing.md,
    this.mainAxisSpacing = HvacSpacing.md,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];

        // If card is already HvacAnimatedCard, use it as-is
        if (card is HvacAnimatedCard) {
          return card;
        }

        // Otherwise, wrap in animated card with staggered delay
        return HvacAnimatedCard(
          delay: staggerDelay * index,
          child: card,
        );
      },
    );
  }
}

/// List of animated cards with staggered entrance animations
///
/// Usage:
/// ```dart
/// HvacAnimatedCardList(
///   cards: [
///     Card1(),
///     Card2(),
///   ],
///   staggerDelay: Duration(milliseconds: 80),
/// )
/// ```
class HvacAnimatedCardList extends StatelessWidget {
  /// List of widgets to animate
  final List<Widget> cards;

  /// Delay between each card animation
  final Duration staggerDelay;

  /// Spacing between cards
  final double spacing;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Whether to shrink wrap the list
  final bool shrinkWrap;

  const HvacAnimatedCardList({
    super.key,
    required this.cards,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.spacing = HvacSpacing.md,
    this.physics,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final card = cards[index];

        // If card is already HvacAnimatedCard, use it as-is
        if (card is HvacAnimatedCard) {
          return card;
        }

        // Otherwise, wrap in animated card with staggered delay
        return HvacAnimatedCard(
          delay: staggerDelay * index,
          child: card,
        );
      },
    );
  }
}
