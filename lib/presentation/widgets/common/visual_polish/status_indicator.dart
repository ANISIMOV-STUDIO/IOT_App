/// Premium status indicator with glow effect
/// Supports web with hover states and responsive sizing
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Status indicator with animated pulse and glow effects
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
  bool _isHovered = false;

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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.diagonal3Values(
          _isHovered ? 1.1 : 1.0,
          _isHovered ? 1.1 : 1.0,
          1.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect with web optimization
                  if (widget.isActive && widget.enablePulse)
                    Container(
                      width: widget.size * _pulseAnimation.value * 2,
                      height: widget.size * _pulseAnimation.value * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(alpha: _isHovered ? 0.3 : 0.2),
                      ),
                    ),
                  // Main dot with enhanced shadow on hover
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: _isHovered ? color.withValues(alpha: 0.9) : color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: _isHovered ? 0.7 : 0.5),
                          blurRadius: _isHovered ? widget.size * 1.5 : widget.size,
                          spreadRadius: _isHovered ? 3 : 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showLabel) ...[
              const SizedBox(width: HvacSpacing.xs),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: HvacTypography.captionMedium.copyWith(
                  color: _isHovered ? color.withValues(alpha: 0.9) : color,
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}