/// Animated badge component with elastic animations and interactive states
library;

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/radius.dart';
import '../theme/typography.dart';

/// Premium animated badge with elastic entry animation, hover states, and press feedback
///
/// Features:
/// - Elastic scale-in animation on mount
/// - Hover effects with scale and shadow
/// - Press feedback with scale animation
/// - Optional 'new' indicator with pulse
/// - Optional tap callback with haptic feedback support
/// - Customizable colors and icon
///
/// Example:
/// ```dart
/// AnimatedBadge(
///   label: 'Premium',
///   backgroundColor: HvacColors.primaryOrange,
///   icon: Icons.star,
///   isNew: true,
///   onTap: () => print('Badge tapped'),
///   onTapHaptic: () => HapticFeedback.selectionClick(),
/// )
/// ```
class AnimatedBadge extends StatefulWidget {
  /// Badge text label
  final String label;

  /// Background color (used with transparency)
  final Color backgroundColor;

  /// Text color (typically unused, text uses backgroundColor)
  final Color textColor;

  /// Optional leading icon
  final IconData? icon;

  /// Show 'new' indicator dot with pulse animation
  final bool isNew;

  /// Tap callback
  final VoidCallback? onTap;

  /// Optional haptic feedback callback (called before onTap)
  /// Example: () => HapticFeedback.selectionClick()
  final VoidCallback? onTapHaptic;

  const AnimatedBadge({
    super.key,
    required this.label,
    this.backgroundColor = HvacColors.accent,
    this.textColor = Colors.white,
    this.icon,
    this.isNew = false,
    this.onTap,
    this.onTapHaptic,
  });

  @override
  State<AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<AnimatedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget badge = ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.diagonal3Values(
            _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0),
            _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0),
            1.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.sm,
            vertical: HvacSpacing.xs,
          ),
          decoration: _buildDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 12.0,
                  color: widget.backgroundColor,
                ),
                const SizedBox(width: HvacSpacing.xxs),
              ],
              Text(
                widget.label,
                style: HvacTypography.labelSmall.copyWith(
                  color: widget.backgroundColor,
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (widget.isNew) ...[
                const SizedBox(width: HvacSpacing.xxs),
                Container(
                  width: 6.0,
                  height: 6.0,
                  decoration: const BoxDecoration(
                    color: HvacColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (widget.onTap != null) {
      badge = GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          widget.onTapHaptic?.call();
          widget.onTap!();
        },
        child: badge,
      );
    }

    return badge;
  }

  BoxDecoration _buildDecoration() => BoxDecoration(
        color: widget.backgroundColor.withValues(
          alpha: _isHovered ? 0.25 : 0.2,
        ),
        borderRadius: BorderRadius.circular(HvacRadius.sm),
        border: Border.all(
          color: widget.backgroundColor.withValues(
            alpha: _isHovered ? 0.5 : 0.3,
          ),
          width: _isHovered ? 1.5 : 1,
        ),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: widget.backgroundColor.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      );
}
