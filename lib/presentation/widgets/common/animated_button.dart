/// Animated Button Components
/// Big Tech level button interactions with smooth animations and haptic feedback
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';

/// Primary animated button with scale and haptic feedback
class AnimatedPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final bool enableHaptic;

  const AnimatedPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.width,
    this.height,
    this.enableHaptic = true,
  });

  @override
  State<AnimatedPrimaryButton> createState() => _AnimatedPrimaryButtonState();
}

class _AnimatedPrimaryButtonState extends State<AnimatedPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null || widget.isLoading) return;

    setState(() => _isPressed = true);
    _controller.forward();

    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed == null || widget.isLoading) return;

    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (widget.onPressed == null || widget.isLoading) return;

    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.isExpanded ? double.infinity : widget.width,
            height: widget.height ?? 56.h,
            padding: widget.padding ??
                EdgeInsets.symmetric(
                  horizontal: AppSpacing.lgR,
                  vertical: AppSpacing.mdR,
                ),
            decoration: BoxDecoration(
              gradient: isDisabled
                  ? null
                  : const LinearGradient(
                      colors: [
                        AppTheme.primaryOrange,
                        AppTheme.primaryOrangeDark,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              color: isDisabled
                  ? AppTheme.backgroundCardBorder
                  : null,
              borderRadius: BorderRadius.circular(AppRadius.mdR),
              boxShadow: _isPressed || isDisabled
                  ? []
                  : [
                      BoxShadow(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Center(
              child: widget.isLoading
                  ? _buildLoadingIndicator()
                  : _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 20.r,
      height: 20.r,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: Colors.white,
            size: 20.r,
          ),
          SizedBox(width: AppSpacing.smR),
          Text(
            widget.label,
            style: AppTypography.buttonMedium.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.label,
      style: AppTypography.buttonMedium.copyWith(
        color: Colors.white,
      ),
    );
  }
}

/// Secondary outlined button with hover effects
class AnimatedOutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? borderColor;
  final Color? textColor;

  const AnimatedOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.borderColor,
    this.textColor,
  });

  @override
  State<AnimatedOutlineButton> createState() => _AnimatedOutlineButtonState();
}

class _AnimatedOutlineButtonState extends State<AnimatedOutlineButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _borderAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward();
      HapticFeedback.selectionClick();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? AppTheme.primaryOrange;
    final textColor = widget.textColor ?? AppTheme.primaryOrange;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.isLoading || widget.onPressed == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                widget.onPressed!();
              },
        child: AnimatedBuilder(
          animation: _borderAnimation,
          builder: (context, child) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 48.h,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lgR,
              vertical: AppSpacing.smR,
            ),
            decoration: BoxDecoration(
              color: _isHovered
                  ? borderColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.mdR),
              border: Border.all(
                color: borderColor,
                width: _borderAnimation.value,
              ),
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: textColor,
                            size: 20.r,
                          ),
                          SizedBox(width: AppSpacing.smR),
                        ],
                        Text(
                          widget.label,
                          style: AppTypography.buttonMedium.copyWith(
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon button with ripple effect
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? size;
  final String? tooltip;
  final bool enableHaptic;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.size,
    this.tooltip,
    this.enableHaptic = true,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
    ));
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onPressed == null) return;

    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }

    _controller.forward().then((_) {
      _controller.reverse();
    });

    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? 48.r;
    final iconColor = widget.iconColor ?? AppTheme.textPrimary;
    final backgroundColor = widget.backgroundColor ?? Colors.transparent;

    Widget button = GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ripple effect
              if (_rippleAnimation.value > 0)
                Opacity(
                  opacity: 1 - _rippleAnimation.value,
                  child: Transform.scale(
                    scale: 1 + _rippleAnimation.value,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: iconColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              // Icon
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Icon(
                  widget.icon,
                  color: iconColor,
                  size: size * 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Floating action button with animation
class AnimatedFAB extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final bool mini;

  const AnimatedFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.mini = false,
  });

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
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
    final size = widget.mini ? 48.r : 56.r;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onPressed();
        },
        child: Container(
          width: widget.label != null ? null : size,
          height: size,
          padding: widget.label != null
              ? EdgeInsets.symmetric(horizontal: AppSpacing.lgR)
              : null,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(
              widget.label != null ? AppRadius.xlR : size / 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: widget.mini ? 20.r : 24.r,
              ),
              if (widget.label != null) ...[
                SizedBox(width: AppSpacing.smR),
                Text(
                  widget.label!,
                  style: AppTypography.buttonMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}