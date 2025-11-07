/// Animated badge with elastic animations and web hover states
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../core/services/haptic_service.dart';

/// Premium badge with elastic entry animation
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
    this.backgroundColor = HvacColors.primaryOrange,
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
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
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
                Icon(widget.icon, size: 12.0, color: widget.backgroundColor),
                const SizedBox(width: HvacSpacing.xxs),
              ],
              Text(
                widget.label,
                style: HvacTypography.label.copyWith(
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
          HapticService.instance.selection();
          widget.onTap!();
        },
        child: badge,
      );
    }

    if (widget.isNew) {
      badge =
          badge.animate(onPlay: (controller) => controller.repeat()).shimmer(
                duration: 2000.ms,
                delay: 1000.ms,
                color: widget.backgroundColor.withValues(alpha: 0.1),
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
