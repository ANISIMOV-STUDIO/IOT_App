/// Text button with underline animation and hover effects
/// Web-optimized for link-style interactions
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_animated_button.dart';

class AnimatedTextButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? textColor;
  final bool showUnderline;
  final bool isLoading;
  final ButtonSize size;
  final MainAxisAlignment alignment;

  const AnimatedTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.textColor,
    this.showUnderline = true,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  State<AnimatedTextButton> createState() => _AnimatedTextButtonState();
}

class _AnimatedTextButtonState extends State<AnimatedTextButton>
    with TickerProviderStateMixin, AnimatedButtonMixin {
  late AnimationController _underlineController;
  late Animation<double> _underlineAnimation;
  bool _isHovered = false;

  @override
  bool get isButtonEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  double get pressedScale => 0.98;

  @override
  void initState() {
    super.initState();
    _initUnderlineAnimation();
  }

  void _initUnderlineAnimation() {
    _underlineController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _underlineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _underlineController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _underlineController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (!isButtonEnabled) return;

    setState(() => _isHovered = isHovered);

    if (widget.showUnderline) {
      if (isHovered) {
        _underlineController.forward();
      } else {
        _underlineController.reverse();
      }
    }
  }

  void _handleTap() {
    if (!isButtonEnabled) return;

    if (enableHaptic) {
      HapticFeedback.selectionClick();
    }
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.textColor ?? HvacColors.primaryOrange;
    final effectiveTextColor = isButtonEnabled
        ? (_isHovered ? textColor.withValues(alpha: 0.8) : textColor)
        : textColor.withValues(alpha: 0.5);

    return MouseRegion(
      cursor: mouseCursor,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: handleTapDown,
        onTapUp: handleTapUp,
        onTapCancel: handleTapCancel,
        onTap: isButtonEnabled ? _handleTap : null,
        child: AnimatedBuilder(
          animation: scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: scaleAnimation.value,
            child: _buildButton(effectiveTextColor),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(Color textColor) {
    return Container(
      padding: widget.size.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.isLoading)
            _buildLoadingIndicator(textColor)
          else
            _buildContent(textColor),
          if (widget.showUnderline) _buildUnderline(textColor),
        ],
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    return InkWell(
      borderRadius: BorderRadius.circular(HvacRadius.smR),
      splashColor: textColor.withValues(alpha: 0.1),
      highlightColor: textColor.withValues(alpha: 0.05),
      onTap: isButtonEnabled ? widget.onPressed : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.xsR,
          vertical: HvacSpacing.xxsR,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: widget.alignment,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: textColor,
                size: widget.size.iconSize.r,
              ),
              const SizedBox(width: HvacSpacing.xsR),
            ],
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: HvacTypography.buttonMedium.copyWith(
                color: textColor,
                fontSize: widget.size.fontSize.sp,
                decoration: _isHovered && !widget.showUnderline
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(Color color) {
    return SizedBox(
      width: widget.size.iconSize.r,
      height: widget.size.iconSize.r,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildUnderline(Color color) {
    return AnimatedBuilder(
      animation: _underlineAnimation,
      builder: (context, child) => Container(
        height: 2,
        width: _underlineAnimation.value * 100,
        margin: const EdgeInsets.only(top: HvacSpacing.xxsR),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}