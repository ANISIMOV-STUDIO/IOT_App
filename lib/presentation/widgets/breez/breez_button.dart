/// BREEZ Button - Base button with premium animations
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';

/// Минимальный размер touch target по Material Design
const double kMinTouchTarget = 48.0;

/// Base BREEZ button with premium animations
///
/// Единый базовый класс для всех кнопок приложения.
/// Поддерживает hover, press, loading состояния с плавными анимациями.
class BreezButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? hoverColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double borderRadius;
  final List<BoxShadow>? shadows;
  final Border? border;
  final bool isLoading;
  final bool showBorder;
  final bool enableScale;
  final bool enableGlow;
  final bool enforceMinTouchTarget;

  const BreezButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.hoverColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppRadius.button,
    this.shadows,
    this.border,
    this.isLoading = false,
    this.showBorder = true,
    this.enableScale = true,
    this.enableGlow = false,
    this.enforceMinTouchTarget = true,
  });

  @override
  State<BreezButton> createState() => _BreezButtonState();
}

class _BreezButtonState extends State<BreezButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    // Spring-like scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    if (widget.enableScale) _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    if (widget.enableScale) _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    if (widget.enableScale) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final bg = widget.backgroundColor ?? colors.buttonBg;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Touch target constraints (only enforce if enforceMinTouchTarget is true)
    final minTarget = widget.enforceMinTouchTarget ? kMinTouchTarget : 0.0;
    final buttonWidth = widget.width != null
        ? ((widget.width ?? 0) < minTarget ? minTarget : widget.width)
        : null;
    final buttonHeight = widget.height != null
        ? ((widget.height ?? 0) < minTarget ? minTarget : widget.height)
        : null;

    // State-based colors
    final effectiveBg = _isPressed
        ? Color.lerp(bg, isDark ? Colors.white : Colors.black, 0.1)!
        : _isHovered
            ? (widget.hoverColor ?? Color.lerp(bg, isDark ? Colors.white : Colors.black, 0.05)!)
            : bg;

    final effectiveBorder = widget.showBorder
        ? (_isHovered ? colors.borderAccent : colors.border)
        : Colors.transparent;

    // Hover glow for accent buttons
    final glowShadows = widget.enableGlow && _isHovered
        ? [BoxShadow(
            color: (widget.backgroundColor ?? AppColors.accent).withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: -2,
          )]
        : widget.shadows;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.isLoading || widget.onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final scale = widget.enableScale ? _scaleAnimation.value : 1.0;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                constraints: BoxConstraints(
                  minHeight: minTarget,
                  minWidth: buttonWidth ?? 0,
                ),
                padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: effectiveBg,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: widget.showBorder ? Border.all(color: effectiveBorder) : null,
                  boxShadow: glowShadows,
                ),
                child: child,
              ),
            );
          },
          child: widget.isLoading
              ? Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.text),
                    ),
                  ),
                )
              : widget.child,
        ),
      ),
    );
  }
}
