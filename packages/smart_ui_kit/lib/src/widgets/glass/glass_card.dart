import 'package:flutter/material.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';

/// Card variant styles
enum GlassCardVariant {
  elevated,
  flat,
  outlined,
  filled,
  convex,
  concave,
}

typedef NeumorphicCardVariant = GlassCardVariant;

/// Premium Glass Card - clean, minimal style
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final VoidCallback? onTap;
  final GlassCardVariant variant;
  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = 16.0,
    this.onTap,
    this.variant = GlassCardVariant.elevated,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final isDark = theme.isDark;

    final bgColor = backgroundColor ?? theme.colors.cardSurface;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    Widget card = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: variant == GlassCardVariant.elevated ||
                variant == GlassCardVariant.convex
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}

typedef NeumorphicCard = GlassCard;

/// Interactive glass card with hover effect
class GlassInteractiveCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? backgroundColor;

  const GlassInteractiveCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius = 16.0,
    this.backgroundColor,
  });

  @override
  State<GlassInteractiveCard> createState() => _GlassInteractiveCardState();
}

class _GlassInteractiveCardState extends State<GlassInteractiveCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final isDark = theme.isDark;

    final bgColor = widget.backgroundColor ?? theme.colors.cardSurface;
    final hoverColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.02);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isHovered ? hoverColor.withValues(alpha: 0.1) : bgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered
                  ? GlassColors.accentPrimary.withValues(alpha: 0.3)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05)),
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(16),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

typedef NeumorphicInteractiveCard = GlassInteractiveCard;
