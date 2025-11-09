/// Standard Glassmorphic Card
/// Production-ready card with animations and interactions
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Standard glassmorphic card with hover effects and animations
class GlassmorphicCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double blurAmount;
  final double borderOpacity;
  final Color? backgroundColor;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool enableAnimation;
  final bool enableHoverEffect;
  final Duration animationDuration;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.blurAmount = 10.0,
    this.borderOpacity = 0.1,
    this.backgroundColor,
    this.gradient,
    this.onTap,
    this.enableAnimation = true,
    this.enableHoverEffect = true,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  State<GlassmorphicCard> createState() => _GlassmorphicCardState();
}

class _GlassmorphicCardState extends State<GlassmorphicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverScale;
  late Animation<double> _shadowElevation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _hoverScale = Tween<double>(begin: 1.0, end: 1.02).animate(
        CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic));

    _shadowElevation = Tween<double>(begin: 4, end: 12).animate(
        CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (!widget.enableHoverEffect || !kIsWeb) return;

    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  List<BoxShadow> get _responsiveShadows {
    final elevation = _isHovered ? _shadowElevation.value : 4.0;
    return [
      BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: elevation,
          offset: Offset(0, elevation / 2)),
      if (_isHovered)
        BoxShadow(
            color: HvacColors.primaryBlue.withValues(alpha: 0.05),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget card = MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: AnimatedBuilder(
            animation: _hoverController,
            builder: (context, child) => Transform.scale(
                scale: _hoverScale.value,
                child: BaseGlassmorphicContainer(
                    width: widget.width,
                    height: widget.height,
                    margin: widget.margin,
                    padding: widget.padding,
                    blurAmount: widget.blurAmount,
                    borderOpacity: widget.borderOpacity,
                    backgroundColor: widget.backgroundColor,
                    gradient: widget.gradient,
                    boxShadow: _responsiveShadows,
                    child: widget.child))));

    // Add tap handler if provided
    if (widget.onTap != null) {
      card = InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(HvacRadius.lg),
          splashColor: HvacColors.primaryBlue.withValues(alpha: 0.1),
          highlightColor: HvacColors.primaryBlue.withValues(alpha: 0.05),
          child: card);
    }

    // Add entrance animation if enabled
    if (widget.enableAnimation) {
      card = card
          .animate()
          .fadeIn(duration: widget.animationDuration, curve: Curves.easeOut)
          .slideY(
              begin: 0.05,
              duration: widget.animationDuration,
              curve: Curves.easeOut);
    }

    return card;
  }
}

/// Elevated glassmorphic card variant with enhanced shadows
class ElevatedGlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final double elevation;

  const ElevatedGlassmorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.elevation = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        onTap: onTap,
        blurAmount: 15.0,
        borderOpacity: 0.15,
        child: child);
  }
}
