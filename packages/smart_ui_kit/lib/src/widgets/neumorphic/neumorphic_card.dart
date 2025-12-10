import 'package:flutter/material.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Neumorphic Card - Base container with soft shadow effect
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isPressed;
  final VoidCallback? onTap;
  final NeumorphicCardVariant variant;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = NeumorphicSpacing.cardRadius,
    this.isPressed = false,
    this.onTap,
    this.variant = NeumorphicCardVariant.convex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final shadows = isPressed 
        ? theme.shadows.concaveMedium 
        : _getShadowsForVariant(theme);

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: width,
      height: height,
      padding: padding ?? NeumorphicSpacing.cardInsets,
      decoration: BoxDecoration(
        color: theme.colors.cardSurface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }

  List<BoxShadow> _getShadowsForVariant(NeumorphicThemeData theme) {
    switch (variant) {
      case NeumorphicCardVariant.convex:
        return theme.shadows.convexMedium;
      case NeumorphicCardVariant.flat:
        return theme.shadows.flat;
      case NeumorphicCardVariant.concave:
        return theme.shadows.concaveMedium;
    }
  }
}

/// Card variants for different visual effects
enum NeumorphicCardVariant {
  /// Raised appearance (default)
  convex,
  /// Minimal shadow
  flat,
  /// Inset/pressed appearance
  concave,
}

/// Neumorphic Card with hover/press animation
class NeumorphicInteractiveCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NeumorphicInteractiveCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = NeumorphicSpacing.cardRadius,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<NeumorphicInteractiveCard> createState() => 
      _NeumorphicInteractiveCardState();
}

class _NeumorphicInteractiveCardState extends State<NeumorphicInteractiveCard> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress: widget.onLongPress,
      child: NeumorphicCard(
        padding: widget.padding,
        width: widget.width,
        height: widget.height,
        borderRadius: widget.borderRadius,
        isPressed: _isPressed,
        child: widget.child,
      ),
    );
  }
}
