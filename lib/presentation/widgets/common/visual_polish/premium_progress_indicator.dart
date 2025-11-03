/// Premium progress indicator with gradient and web animations
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// High-end progress indicator with gradient fill
class PremiumProgressIndicator extends StatefulWidget {
  final double value;
  final double height;
  final Color? backgroundColor;
  final Gradient? gradient;
  final bool showPercentage;
  final bool animate;
  final String? label;

  const PremiumProgressIndicator({
    super.key,
    required this.value,
    this.height = 8.0,
    this.backgroundColor,
    this.gradient,
    this.showPercentage = false,
    this.animate = true,
    this.label,
  });

  @override
  State<PremiumProgressIndicator> createState() =>
      _PremiumProgressIndicatorState();
}

class _PremiumProgressIndicatorState extends State<PremiumProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _updateAnimation(0.0, widget.value.clamp(0.0, 1.0));
    if (widget.animate) _controller.forward();
  }

  void _updateAnimation(double from, double to) {
    _progressAnimation = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant PremiumProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _updateAnimation(
        oldWidget.value.clamp(0.0, 1.0),
        widget.value.clamp(0.0, 1.0),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(widget.label!,
                style: HvacTypography.captionMedium
                    .copyWith(color: HvacColors.textSecondary)),
            SizedBox(height: HvacSpacing.xxs.h),
          ],
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (_, __) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _isHovered ? widget.height.h * 1.2 : widget.height.h,
              decoration: BoxDecoration(
                color: widget.backgroundColor ??
                    HvacColors.backgroundCardBorder.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(widget.height.h),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: LayoutBuilder(
                builder: (_, constraints) => Stack(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: constraints.maxWidth * _progressAnimation.value,
                    decoration: BoxDecoration(
                      gradient: widget.gradient ?? HvacColors.primaryGradient,
                      borderRadius: BorderRadius.circular(widget.height.h),
                      boxShadow: [
                        BoxShadow(
                          color: HvacColors.primaryOrange
                              .withValues(alpha: _isHovered ? 0.4 : 0.3),
                          blurRadius: _isHovered ? 12 : 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
          if (widget.showPercentage) ...[
            SizedBox(height: HvacSpacing.xs.h),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (_, __) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(_progressAnimation.value * 100).toInt()}%',
                    style: HvacTypography.captionBold.copyWith(
                      color: _isHovered
                          ? HvacColors.primaryOrange
                          : HvacColors.primaryOrange.withValues(alpha: 0.8),
                    ),
                  ),
                  if (_progressAnimation.value >= 1.0)
                    Icon(Icons.check_circle,
                        size: 14.r, color: HvacColors.success),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}