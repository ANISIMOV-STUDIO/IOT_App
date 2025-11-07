/// Premium progress indicator with smooth animations
library;

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Premium progress indicator
class PremiumProgressIndicator extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color? backgroundColor;
  final Gradient? gradient;
  final bool showPercentage;
  final bool animate;

  const PremiumProgressIndicator({
    super.key,
    required this.value,
    this.height = 8.0,
    this.backgroundColor,
    this.gradient,
    this.showPercentage = false,
    this.animate = true,
  });

  @override
  State<PremiumProgressIndicator> createState() =>
      _PremiumProgressIndicatorState();
}

class _PremiumProgressIndicatorState extends State<PremiumProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PremiumProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.value,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) => Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  HvacColors.backgroundCardBorder.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: constraints.maxWidth * _progressAnimation.value,
                    decoration: BoxDecoration(
                      gradient: widget.gradient ?? HvacColors.primaryGradient,
                      borderRadius: BorderRadius.circular(widget.height / 2),
                      boxShadow: [
                        BoxShadow(
                          color: HvacColors.accent.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.showPercentage) ...[
          const SizedBox(height: HvacSpacing.xs),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) => Text(
              '${(_progressAnimation.value * 100).toInt()}%',
              style: HvacTypography.caption.copyWith(
                color: HvacColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
