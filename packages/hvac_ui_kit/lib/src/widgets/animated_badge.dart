/// Animated badge component with scale animation
library;

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/radius.dart';
import '../theme/typography.dart';

/// Animated badge component
class AnimatedBadge extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final bool isNew;
  final VoidCallback? onTap;

  const AnimatedBadge({
    super.key,
    required this.label,
    this.backgroundColor = HvacColors.accent,
    this.textColor = Colors.white,
    this.icon,
    this.isNew = false,
    this.onTap,
  });

  @override
  State<AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<AnimatedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: HvacSpacing.sm,
          vertical: HvacSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(HvacRadius.sm),
          border: Border.all(
            color: widget.backgroundColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                size: 12.0,
                color: widget.backgroundColor,
              ),
              SizedBox(width: HvacSpacing.xxs),
            ],
            Text(
              widget.label,
              style: HvacTypography.labelSmall.copyWith(
                color: widget.backgroundColor,
              ),
            ),
            if (widget.isNew) ...[
              SizedBox(width: HvacSpacing.xxs),
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
    );

    if (widget.onTap != null) {
      badge = GestureDetector(
        onTap: widget.onTap,
        child: badge,
      );
    }

    return badge;
  }
}
