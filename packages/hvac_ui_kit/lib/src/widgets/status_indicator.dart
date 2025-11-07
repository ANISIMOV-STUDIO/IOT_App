/// Premium status indicator with glow and pulse animation
library;

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Premium status indicator with glow
class StatusIndicator extends StatefulWidget {
  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final bool showLabel;
  final bool enablePulse;

  const StatusIndicator({
    super.key,
    required this.isActive,
    this.activeLabel = 'Активно',
    this.inactiveLabel = 'Отключено',
    this.activeColor = HvacColors.success,
    this.inactiveColor = HvacColors.neutral200,
    this.size = 8.0,
    this.showLabel = true,
    this.enablePulse = true,
  });

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive && widget.enablePulse) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && widget.enablePulse) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive ? widget.activeColor : widget.inactiveColor;
    final label = widget.isActive ? widget.activeLabel : widget.inactiveLabel;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) => Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              if (widget.isActive && widget.enablePulse)
                Container(
                  width: widget.size * _pulseAnimation.value * 2,
                  height: widget.size * _pulseAnimation.value * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.2),
                  ),
                ),
              // Main dot
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: widget.size,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.showLabel) ...[
          const SizedBox(width: HvacSpacing.sm),
          Text(
            label,
            style: HvacTypography.caption.copyWith(
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}
