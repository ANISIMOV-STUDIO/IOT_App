/// Gradient Card Component
/// Premium gradient effects with web-optimized animations
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Premium gradient card with hover animations
class GradientCard extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool enableHoverEffect;
  final bool enableShadow;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double borderRadius;

  const GradientCard({
    super.key,
    required this.child,
    required this.colors,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.enableHoverEffect = true,
    this.enableShadow = true,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.borderRadius = HvacRadius.lg,
  }) : assert(colors.length >= 2, 'Gradient requires at least 2 colors');

  @override
  State<GradientCard> createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: kIsWeb ? 1.03 : 1.02, // Slightly more scale on web
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic));

    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (!widget.enableHoverEffect) return;

    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  List<BoxShadow>? _buildResponsiveShadows() {
    if (!widget.enableShadow) return null;

    const baseBlur = 12.0;
    const hoverBlur = 20.0;
    const baseOffset = 4.0;
    const hoverOffset = 8.0;

    return [
      BoxShadow(
        color: widget.colors.first.withValues(
          alpha: 0.3 * (1 + _shadowAnimation.value * 0.3)),
        blurRadius: baseBlur + (hoverBlur - baseBlur) * _shadowAnimation.value,
        offset: Offset(
          0,
          baseOffset + (hoverOffset - baseOffset) * _shadowAnimation.value)),
      BoxShadow(
        color: widget.colors.last.withValues(
          alpha: 0.15 * (1 + _shadowAnimation.value * 0.5)),
        blurRadius: (baseBlur * 2) +
            ((hoverBlur * 1.6) - (baseBlur * 2)) * _shadowAnimation.value,
        offset: Offset(
          0,
          (baseOffset * 2) +
              ((hoverOffset * 2) - (baseOffset * 2)) * _shadowAnimation.value)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: kIsWeb ? (_) => _handleHover(true) : null,
      onExit: kIsWeb ? (_) => _handleHover(false) : null,
      cursor: widget.onTap != null && kIsWeb
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: !kIsWeb && widget.enableHoverEffect
            ? (_) => _handleHover(true)
            : null,
        onTapUp: !kIsWeb && widget.enableHoverEffect
            ? (_) => _handleHover(false)
            : null,
        onTapCancel: !kIsWeb && widget.enableHoverEffect
            ? () => _handleHover(false)
            : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.colors,
                  begin: widget.begin,
                  end: widget.end),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: _buildResponsiveShadows()),
              padding: widget.padding ?? const EdgeInsets.all(HvacSpacing.lg),
              child: child!)),
          child: widget.child)));
  }
}

