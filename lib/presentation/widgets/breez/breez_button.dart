/// BREEZ Button - Base button with premium animations and accessibility
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/app_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';

/// Base BREEZ button with premium animations
///
/// Единый базовый класс для всех кнопок приложения.
/// Поддерживает hover, press, loading состояния с плавными анимациями.
/// Включает accessibility (Semantics, Tooltip).
class BreezButton extends StatefulWidget {

  const BreezButton({
    required this.child,
    super.key,
    this.onTap,
    this.backgroundColor,
    this.hoverColor,
    this.pressedColor,
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
    this.enableHaptic = true,
    this.semanticLabel,
    this.tooltip,
    this.isButton = true,
  });
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? pressedColor; // Явный цвет при нажатии (для прозрачных кнопок)
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

  /// Включить тактильную обратную связь при нажатии
  final bool enableHaptic;

  /// Semantic label for screen readers (accessibility)
  final String? semanticLabel;

  /// Tooltip text shown on hover/long-press
  final String? tooltip;

  /// Whether this is a button (for Semantics)
  final bool isButton;

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
      duration: AppDurations.fast,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.96).animate(
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
    if (widget.enableScale) {
      _controller.forward();
    }
    // Тактильная обратная связь при нажатии
    if (widget.enableHaptic && widget.onTap != null) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails _) {
    // Задержка перед сбросом для видимого эффекта нажатия
    Future.delayed(AppDurations.instant, () {
      if (mounted) {
        setState(() => _isPressed = false);
        if (widget.enableScale) {
          _controller.reverse();
        }
      }
    });
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    if (widget.enableScale) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final bg = widget.backgroundColor ?? colors.buttonBg;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Touch target constraints
    final minTarget = widget.enforceMinTouchTarget ? AppSizes.minTouchTarget : 0.0;
    final buttonWidth = widget.width != null
        ? ((widget.width ?? 0) < minTarget ? minTarget : widget.width)
        : null;
    final buttonHeight = widget.height != null
        ? ((widget.height ?? 0) < minTarget ? minTarget : widget.height)
        : null;

    // State-based colors
    // pressedColor используется для прозрачных кнопок где lerp не работает
    final effectiveBg = _isPressed
        ? (widget.pressedColor ??
            Color.lerp(bg, isDark ? colors.text : colors.bg, 0.1)!)
        : _isHovered
            ? (widget.hoverColor ??
                Color.lerp(bg, isDark ? colors.text : colors.bg, 0.05)!)
            : bg;

    final effectiveBorder = widget.showBorder
        ? (_isHovered ? colors.borderAccent : colors.border)
        : Colors.transparent;

    // Hover glow for accent buttons
    final glowShadows = widget.enableGlow && _isHovered
        ? [
            BoxShadow(
              color: (widget.backgroundColor ?? colors.accent)
                  .withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: -2,
            )
          ]
        : widget.shadows;

    final isEnabled = !widget.isLoading && widget.onTap != null;

    Widget button = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
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
              // AnimatedContainer для плавного перехода цвета
              child: AnimatedContainer(
                duration: AppDurations.fast,
                curve: Curves.easeOut,
                width: buttonWidth,
                height: buttonHeight,
                constraints: BoxConstraints(
                  minHeight: minTarget,
                  minWidth: buttonWidth ?? 0,
                ),
                padding: widget.padding ??
                    const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: effectiveBg,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: widget.border ??
                      (widget.showBorder ? Border.all(color: effectiveBorder) : null),
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

    // Wrap with Semantics for accessibility
    if (widget.semanticLabel != null || widget.isButton) {
      button = Semantics(
        label: widget.semanticLabel,
        button: widget.isButton,
        enabled: isEnabled,
        child: button,
      );
    }

    // Wrap with Tooltip if provided
    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip,
        waitDuration: const Duration(milliseconds: 500),
        child: button,
      );
    }

    return button;
  }
}
