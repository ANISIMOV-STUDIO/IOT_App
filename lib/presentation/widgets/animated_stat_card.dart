/// Animated Stat Card Widget
///
/// Card with animated value changes
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
class AnimatedStatCard extends StatefulWidget {
  final String label;
  final String value;
  final String? previousValue;
  final IconData icon;
  final Color color;
  final String? trend; // '+2.5°C' or '-10%'

  const AnimatedStatCard({
    super.key,
    required this.label,
    required this.value,
    this.previousValue,
    required this.icon,
    required this.color,
    this.trend,
  });

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedStatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(HvacSpacing.md),
              decoration: HvacDecorations.card(
                shadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(HvacSpacing.xs),
                        decoration: HvacDecorations.iconContainer(
                          color: widget.color,
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: HvacSpacing.sm),
                      Expanded(
                        child: Text(
                          widget.label,
                          style: HvacTypography.labelLarge.copyWith(
                            color: HvacColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: HvacSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.value,
                        style: HvacTypography.headlineMedium.copyWith(
                          color: widget.color,
                        ),
                      ),
                      if (widget.trend != null) ...[
                        const SizedBox(width: HvacSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: HvacSpacing.xxs + 2,
                            vertical: 2,
                          ),
                          decoration: HvacDecorations.badgeSmall(
                            color: widget.trend!.startsWith('+')
                                ? HvacColors.success
                                : HvacColors.error,
                            filled: false,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.trend!.startsWith('+')
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 12,
                                color: widget.trend!.startsWith('+')
                                    ? HvacColors.success
                                    : HvacColors.error,
                              ),
                              const SizedBox(width: HvacSpacing.xxs),
                              Text(
                                widget.trend!,
                                style: HvacTypography.captionSmall.copyWith(
                                  color: widget.trend!.startsWith('+')
                                      ? HvacColors.success
                                      : HvacColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
