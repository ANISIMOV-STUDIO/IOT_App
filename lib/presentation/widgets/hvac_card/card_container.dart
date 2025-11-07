/// Card container with web-responsive hover effects
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Animated container for HVAC card with hover effects
class HvacCardContainer extends StatefulWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget child;
  final bool enableAnimation;

  const HvacCardContainer({
    super.key,
    required this.isSelected,
    required this.child,
    this.onTap,
    this.enableAnimation = true,
  });

  @override
  State<HvacCardContainer> createState() => _HvacCardContainerState();
}

class _HvacCardContainerState extends State<HvacCardContainer>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    if (widget.isSelected) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(HvacCardContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _glowController.repeat(reverse: true);
      } else {
        _glowController.stop();
      }
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  BoxDecoration _getDecoration() {
    final baseGradient = widget.isSelected
        ? HvacColors.primaryGradient
        : const LinearGradient(
            colors: [HvacColors.cardDark, HvacColors.cardDark],
          );

    final borderColor = _isHovered
        ? HvacColors.primaryOrange.withValues(alpha: 0.6)
        : Colors.transparent;

    final shadowColor = widget.isSelected
        ? HvacColors.primaryOrange.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.1);

    return BoxDecoration(
      gradient: baseGradient,
      borderRadius: BorderRadius.circular(HvacSpacing.lg),
      border: Border.all(
        color: borderColor,
        width: _isHovered ? 2 : 0,
      ),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          blurRadius: _isHovered ? 24.0 : (widget.isSelected ? 20.0 : 10.0),
          offset:
              Offset(0, _isHovered ? 12.0 : (widget.isSelected ? 10.0 : 5.0)),
        ),
        if (widget.isSelected)
          BoxShadow(
            color: HvacColors.primaryOrange.withValues(
              alpha: 0.1 + (_glowAnimation.value * 0.1),
            ),
            blurRadius: 30.0,
            spreadRadius: _glowAnimation.value * 10.0,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget container = MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _isPressed = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.98 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(
                  horizontal: HvacSpacing.md,
                  vertical: HvacSpacing.sm,
                ),
                decoration: _getDecoration(),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );

    if (widget.enableAnimation) {
      return container
          .animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.1, end: 0);
    }

    return container;
  }
}
