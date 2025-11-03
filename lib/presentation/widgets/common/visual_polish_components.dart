/// Visual Polish Components
/// Big Tech level UI details and polish elements
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/services/haptic_service.dart';

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
    this.activeColor = AppTheme.success, // Muted sea green
    this.inactiveColor = AppTheme.neutral200, // Gray for inactive (not bright red!)
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
                  width: widget.size.r * _pulseAnimation.value * 2,
                  height: widget.size.r * _pulseAnimation.value * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.2),
                  ),
                ),
              // Main dot
              Container(
                width: widget.size.r,
                height: widget.size.r,
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
          SizedBox(width: AppSpacing.smR),
          Text(
            label,
            style: AppTypography.captionMedium.copyWith(
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}

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
    this.backgroundColor = AppTheme.primaryOrange,
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
          horizontal: AppSpacing.smR,
          vertical: AppSpacing.xxsR,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppRadius.smR),
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
                size: 12.r,
                color: widget.backgroundColor,
              ),
              SizedBox(width: AppSpacing.xxsR),
            ],
            Text(
              widget.label,
              style: AppTypography.label.copyWith(
                color: widget.backgroundColor,
              ),
            ),
            if (widget.isNew) ...[
              SizedBox(width: AppSpacing.xxsR),
              Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  color: AppTheme.error,
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
        onTap: () {
          HapticService.instance.selection();
          widget.onTap!();
        },
        child: badge,
      );
    }

    if (widget.isNew) {
      badge = badge
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 2000.ms, delay: 1000.ms);
    }

    return badge;
  }
}

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
            height: widget.height.h,
            decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  AppTheme.backgroundCardBorder.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(widget.height.h / 2),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: constraints.maxWidth * _progressAnimation.value,
                    decoration: BoxDecoration(
                      gradient: widget.gradient ?? AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(widget.height.h / 2),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppTheme.primaryOrange.withValues(alpha: 0.3),
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
          SizedBox(height: AppSpacing.xsR),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) => Text(
              '${(_progressAnimation.value * 100).toInt()}%',
              style: AppTypography.captionBold.copyWith(
                color: AppTheme.primaryOrange,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Floating tooltip with animation
class FloatingTooltip extends StatefulWidget {
  final String message;
  final Widget child;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const FloatingTooltip({
    super.key,
    required this.message,
    required this.child,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  State<FloatingTooltip> createState() => _FloatingTooltipState();
}

class _FloatingTooltipState extends State<FloatingTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showTooltip() {
    setState(() => _isHovered = true);
    _controller.forward();
  }

  void _hideTooltip() {
    _controller.reverse().then((_) {
      if (mounted) {
        setState(() => _isHovered = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showTooltip(),
      onExit: (_) => _hideTooltip(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_isHovered)
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.smR,
                        vertical: AppSpacing.xsR,
                      ),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ??
                            AppTheme.backgroundCard,
                        borderRadius: BorderRadius.circular(AppRadius.smR),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.message,
                        style: widget.textStyle ?? AppTypography.caption,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Animated divider with gradient
class AnimatedDivider extends StatelessWidget {
  final double height;
  final EdgeInsets? margin;
  final Gradient? gradient;
  final bool animate;

  const AnimatedDivider({
    super.key,
    this.height = 1.0,
    this.margin,
    this.gradient,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget divider = Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient ??
            LinearGradient(
              colors: [
                Colors.transparent,
                AppTheme.backgroundCardBorder.withValues(alpha: 0.5),
                AppTheme.backgroundCardBorder.withValues(alpha: 0.5),
                Colors.transparent,
              ],
              stops: const [0.0, 0.2, 0.8, 1.0],
            ),
      ),
    );

    if (animate) {
      divider = divider
          .animate()
          .fadeIn(duration: 600.ms)
          .scaleX(begin: 0, end: 1, duration: 800.ms, curve: Curves.easeOut);
    }

    return divider;
  }
}