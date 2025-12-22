import 'package:flutter/material.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';

/// Glass Badge/Chip
class GlassBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final bool isOutlined;

  const GlassBadge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? GlassColors.accentPrimary;
    final fgColor = textColor ?? (isOutlined ? badgeColor : Colors.white);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isOutlined ? badgeColor.withValues(alpha: 0.1) : badgeColor,
        borderRadius: BorderRadius.circular(8),
        border: isOutlined
            ? Border.all(color: badgeColor.withValues(alpha: 0.3))
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fgColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicBadge = GlassBadge;

/// Glass Progress Bar
class GlassProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color? activeColor;
  final Color? backgroundColor;
  final double borderRadius;

  const GlassProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.activeColor,
    this.backgroundColor,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final bgColor =
        backgroundColor ?? theme.colors.textTertiary.withValues(alpha: 0.2);
    final fgColor = activeColor ?? GlassColors.accentPrimary;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      fgColor,
                      fgColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: fgColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicProgressBar = GlassProgressBar;

/// Glass Loading Indicator
class GlassLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const GlassLoadingIndicator({
    super.key,
    this.size = 48,
    this.color,
  });

  @override
  State<GlassLoadingIndicator> createState() => _GlassLoadingIndicatorState();
}

class _GlassLoadingIndicatorState extends State<GlassLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? GlassColors.accentPrimary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Transform.rotate(
                angle: _controller.value * 6.28,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        color.withValues(alpha: 0),
                        color,
                      ],
                    ),
                  ),
                ),
              ),
              // Inner circle (mask)
              Container(
                width: widget.size - 8,
                height: widget.size - 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GlassTheme.of(context).colors.surface,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicLoadingIndicator = GlassLoadingIndicator;

// GlassMainContent is defined in glass_dashboard_shell.dart
