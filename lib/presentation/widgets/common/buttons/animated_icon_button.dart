/// Icon button with ripple effect and hover states
/// Web-optimized with cursor management and visual feedback
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? size;
  final String? tooltip;
  final bool enableHaptic;
  final bool showRipple;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.size,
    this.tooltip,
    this.enableHaptic = true,
    this.showRipple = true,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rippleAnimation;
  bool _isHovered = false;
  bool _showRipple = false;

  bool get enableHaptic => widget.enableHaptic;
  bool get isButtonEnabled => widget.onPressed != null;

  SystemMouseCursor get mouseCursor {
    return isButtonEnabled
      ? SystemMouseCursors.click
      : SystemMouseCursors.forbidden;
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!isButtonEnabled) return;

    if (enableHaptic) {
      HapticFeedback.lightImpact();
    }

    if (widget.showRipple) {
      setState(() => _showRipple = true);
      _animationController.forward().then((_) {
        if (mounted) {
          _animationController.reverse().then((_) {
            if (mounted) {
              setState(() => _showRipple = false);
            }
          });
        }
      });
    }

    widget.onPressed!();
  }

  void _handleHover(bool isHovered) {
    if (!isButtonEnabled) return;
    setState(() => _isHovered = isHovered);
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? 48.r;
    final iconColor = widget.iconColor ?? HvacColors.textPrimary;
    final backgroundColor = widget.backgroundColor ?? Colors.transparent;

    Widget button = MouseRegion(
      cursor: mouseCursor,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => _buildButton(
            size,
            iconColor,
            backgroundColor,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        preferBelow: false,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButton(double size, Color iconColor, Color backgroundColor) {
    final effectiveIconColor = isButtonEnabled
        ? iconColor
        : iconColor.withValues(alpha: 0.5);

    final effectiveBackgroundColor = _isHovered && isButtonEnabled
        ? backgroundColor == Colors.transparent
            ? iconColor.withValues(alpha: 0.1)
            : backgroundColor.withValues(alpha: 0.8)
        : backgroundColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          borderRadius: HvacRadius.fullRadius,
          splashColor: effectiveIconColor.withValues(alpha: 0.3),
          highlightColor: effectiveIconColor.withValues(alpha: 0.1),
          onTap: isButtonEnabled ? _handleTap : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ripple effect
              if (_showRipple && widget.showRipple)
                _buildRippleEffect(size, effectiveIconColor),
              // Icon
              _buildIcon(size, effectiveIconColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRippleEffect(double size, Color color) {
    return Opacity(
      opacity: 1 - _rippleAnimation.value,
      child: Transform.scale(
        scale: 1 + _rippleAnimation.value,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(double size, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Transform.scale(
        scale: _isHovered ? 1.1 : 1.0,
        child: Icon(
          widget.icon,
          color: color,
          size: size * 0.5,
        ),
      ),
    );
  }

}