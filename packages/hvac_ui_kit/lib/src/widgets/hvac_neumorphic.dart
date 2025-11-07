/// HVAC UI Kit - Neumorphism Design
///
/// Soft 3D UI with shadows and highlights
library;

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

/// Neumorphic container with soft shadows
class HvacNeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double borderRadius;
  final bool isPressed;
  final Color? color;

  const HvacNeumorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 12,
    this.isPressed = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? HvacColors.backgroundCard;

    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(HvacSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? [
                // Inner shadows (pressed state)
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.05),
                  offset: const Offset(-2, -2),
                  blurRadius: 4,
                  spreadRadius: -2,
                ),
              ]
            : [
                // Outer shadows (normal state)
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(6, 6),
                  blurRadius: 12,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.05),
                  offset: const Offset(-6, -6),
                  blurRadius: 12,
                ),
              ],
      ),
      child: child,
    );
  }
}

/// Neumorphic button with press animation
class HvacNeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? color;

  const HvacNeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.color,
  });

  @override
  State<HvacNeumorphicButton> createState() => _HvacNeumorphicButtonState();
}

class _HvacNeumorphicButtonState extends State<HvacNeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: HvacNeumorphicContainer(
          width: widget.width,
          height: widget.height,
          borderRadius: widget.borderRadius,
          isPressed: _isPressed,
          color: widget.color,
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

/// Neumorphic icon button
class HvacNeumorphicIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;

  const HvacNeumorphicIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return HvacNeumorphicButton(
      width: size,
      height: size,
      onPressed: onPressed,
      color: backgroundColor,
      child: Icon(
        icon,
        color: iconColor ?? HvacColors.textPrimary,
        size: size * 0.5,
      ),
    );
  }
}

/// Neumorphic toggle button
class HvacNeumorphicToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? activeChild;
  final Widget? inactiveChild;

  const HvacNeumorphicToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.activeChild,
    this.inactiveChild,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: HvacNeumorphicContainer(
        isPressed: value,
        color: value
            ? HvacColors.primaryOrange.withOpacity(0.2)
            : HvacColors.backgroundCard,
        padding: EdgeInsets.all(HvacSpacing.sm),
        child: value
            ? (activeChild ?? Icon(Icons.check, color: HvacColors.primaryOrange))
            : (inactiveChild ?? Icon(Icons.close, color: HvacColors.textSecondary)),
      ),
    );
  }
}

/// Neumorphic card
class HvacNeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const HvacNeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: HvacNeumorphicContainer(
        width: width,
        height: height,
        padding: padding ?? EdgeInsets.all(HvacSpacing.lg),
        child: child,
      ),
    );
  }
}
