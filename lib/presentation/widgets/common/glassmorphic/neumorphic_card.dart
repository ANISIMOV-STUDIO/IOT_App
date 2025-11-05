/// Neumorphic Card Component
/// Depth-based design with responsive shadows
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Neumorphic style card with depth effects
class NeumorphicCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool isPressed;
  final double depth;
  final Color? backgroundColor;
  final double borderRadius;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.isPressed = false,
    this.depth = 4.0,
    this.backgroundColor,
    this.borderRadius = HvacRadius.lg,
  });

  @override
  State<NeumorphicCard> createState() => _NeumorphicCardState();
}

class _NeumorphicCardState extends State<NeumorphicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _depthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this);

    _depthAnimation = Tween<double>(
      begin: widget.depth,
      end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  List<BoxShadow> _buildNeumorphicShadows(double depth) {
    final responsiveDepth = depth;
    final blurRadius = depth * 2;

    return [
      // Dark shadow (bottom-right)
      BoxShadow(
        color: Colors.black.withValues(alpha: kIsWeb ? 0.15 : 0.2),
        blurRadius: blurRadius,
        offset: Offset(responsiveDepth, responsiveDepth)),
      // Light shadow (top-left)
      BoxShadow(
        color: (widget.backgroundColor ?? HvacColors.backgroundCard)
            .withValues(alpha: 0.7),
        blurRadius: blurRadius,
        offset: Offset(-responsiveDepth, -responsiveDepth)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? HvacColors.backgroundCard;

    Widget card = AnimatedBuilder(
      animation: _depthAnimation,
      builder: (context, child) => Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _buildNeumorphicShadows(_depthAnimation.value)),
        padding: widget.padding ?? const EdgeInsets.all(HvacSpacing.lg),
        child: widget.child));

    if (widget.onTap != null) {
      card = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: MouseRegion(
          cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
          child: card));
    }

    return card;
  }
}

/// Soft neumorphic card variant with subtle effects
class SoftNeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const SoftNeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      onTap: onTap,
      depth: 2.0,
      backgroundColor: HvacColors.backgroundCard,
      child: child);
  }
}

/// Concave neumorphic card with inset appearance
class ConcaveNeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double depth;
  final Color? backgroundColor;

  const ConcaveNeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.depth = 4.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? HvacColors.backgroundCard;
    final responsiveDepth = depth;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(HvacRadius.lg),
        boxShadow: [
          // Inner shadow effect for concave appearance
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: responsiveDepth,
            offset: Offset(-responsiveDepth / 2, -responsiveDepth / 2)),
          BoxShadow(
            color: bgColor.withValues(alpha: 0.9),
            blurRadius: responsiveDepth,
            offset: Offset(responsiveDepth / 2, responsiveDepth / 2)),
        ]),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HvacRadius.lg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              bgColor.withValues(alpha: 0.95),
              bgColor,
            ])),
        padding: padding ?? const EdgeInsets.all(HvacSpacing.lg),
        child: child));
  }
}