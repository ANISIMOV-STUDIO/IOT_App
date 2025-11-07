/// Glow Card Component
/// Animated glow effects with web optimizations
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Premium card with animated glow effect
class GlowCard extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final double glowIntensity;
  final Duration animationDuration;
  final bool enablePulse;
  final double borderRadius;

  const GlowCard({
    super.key,
    required this.child,
    this.glowColor = HvacColors.primaryOrange,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.glowIntensity = 1.0,
    this.animationDuration = const Duration(seconds: 2),
    this.enablePulse = true,
    this.borderRadius = HvacRadius.lg,
  });

  @override
  State<GlowCard> createState() => _GlowCardState();
}

class _GlowCardState extends State<GlowCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: widget.animationDuration, vsync: this);

    if (widget.enablePulse) {
      _controller.repeat(reverse: true);
    }

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _borderAnimation = Tween<double>(begin: 0.3, end: 0.6)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<BoxShadow> _buildGlowShadows() {
    final baseIntensity = widget.glowIntensity;
    final animValue = widget.enablePulse ? _glowAnimation.value : 0.5;

    // Optimize shadows for web
    if (kIsWeb && baseIntensity > 1.5) {
      return [
        BoxShadow(
            color: widget.glowColor.withValues(
                alpha:
                    (0.2 * baseIntensity) + (animValue * 0.1 * baseIntensity)),
            blurRadius: 15 * baseIntensity,
            spreadRadius: 2 * baseIntensity),
      ];
    }

    return [
      // Primary glow
      BoxShadow(
          color: widget.glowColor.withValues(
              alpha: (0.2 * baseIntensity) + (animValue * 0.2 * baseIntensity)),
          blurRadius: (20 + (animValue * 10)) * baseIntensity,
          spreadRadius: (animValue * 5) * baseIntensity),
      // Secondary subtle glow
      BoxShadow(
          color: widget.glowColor.withValues(
              alpha: (0.1 * baseIntensity) + (animValue * 0.1 * baseIntensity)),
          blurRadius: (30 + (animValue * 15)) * baseIntensity,
          spreadRadius: (animValue * 8) * baseIntensity),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget card = AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: BoxDecoration(
                color: HvacColors.backgroundCard,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                    color: widget.glowColor.withValues(
                        alpha: widget.enablePulse
                            ? _borderAnimation.value
                            : 0.4 * widget.glowIntensity),
                    width: 2 * widget.glowIntensity),
                boxShadow: _buildGlowShadows()),
            padding: widget.padding ?? const EdgeInsets.all(HvacSpacing.lg),
            child: widget.child));

    if (widget.onTap != null) {
      card = GestureDetector(
          onTap: widget.onTap,
          child: MouseRegion(
              cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
              child: card));
    }

    return card;
  }
}

/// Static glow card without animations for better performance
class StaticGlowCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final double glowIntensity;

  const StaticGlowCard({
    super.key,
    required this.child,
    this.glowColor = HvacColors.primaryBlue,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.glowIntensity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return GlowCard(
        glowColor: glowColor,
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        onTap: onTap,
        glowIntensity: glowIntensity,
        enablePulse: false,
        child: child);
  }
}

/// Neon glow card with vibrant effects
class NeonGlowCard extends StatelessWidget {
  final Widget child;
  final Color neonColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const NeonGlowCard({
    super.key,
    required this.child,
    required this.neonColor,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlowCard(
        glowColor: neonColor,
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        onTap: onTap,
        glowIntensity: 1.5,
        animationDuration: const Duration(milliseconds: 1500),
        child: child);
  }
}
