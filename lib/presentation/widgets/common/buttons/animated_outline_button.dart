/// Secondary outlined button with hover effects
/// Web-optimized with border animations and cursor management
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_animated_button.dart';

class AnimatedOutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final bool isExpanded;
  final ButtonSize size;

  const AnimatedOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.borderColor,
    this.textColor,
    this.width,
    this.isExpanded = false,
    this.size = ButtonSize.medium,
  });

  @override
  State<AnimatedOutlineButton> createState() => _AnimatedOutlineButtonState();
}

class _AnimatedOutlineButtonState extends State<AnimatedOutlineButton>
    with TickerProviderStateMixin, AnimatedButtonMixin {
  late Animation<double> _borderAnimation;
  bool _isHovered = false;

  @override
  int get animationDuration => 200;

  @override
  bool get isButtonEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  void initState() {
    super.initState();

    // Access the animation controller from the mixin
    final controller = AnimationController(
      duration: Duration(milliseconds: animationDuration),
      vsync: this,
    );

    _borderAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    ));
    _borderController = controller;
  }

  late AnimationController _borderController;

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (!isButtonEnabled) return;

    setState(() => _isHovered = isHovered);

    if (isHovered) {
      _borderController.forward();
      if (enableHaptic) {
        HapticFeedback.selectionClick();
      }
    } else {
      _borderController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? HvacColors.primaryOrange;
    final textColor = widget.textColor ?? HvacColors.primaryOrange;

    return MouseRegion(
      cursor: mouseCursor,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: isButtonEnabled
            ? () {
                if (enableHaptic) {
                  HapticFeedback.lightImpact();
                }
                widget.onPressed!();
              }
            : null,
        child: AnimatedBuilder(
          animation: _borderAnimation,
          builder: (context, child) => _buildButtonContainer(
            borderColor,
            textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContainer(Color borderColor, Color textColor) {
    final effectiveColor = isButtonEnabled
        ? borderColor
        : borderColor.withValues(alpha: 0.5);
    final effectiveTextColor = isButtonEnabled
        ? textColor
        : textColor.withValues(alpha: 0.5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.isExpanded ? double.infinity : widget.width,
      height: widget.size.height,
      padding: widget.size.padding,
      decoration: BoxDecoration(
        color: _isHovered && isButtonEnabled
            ? effectiveColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(HvacRadius.mdR),
        border: Border.all(
          color: effectiveColor,
          width: _borderAnimation.value,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(HvacRadius.mdR),
          splashColor: effectiveColor.withValues(alpha: 0.2),
          highlightColor: effectiveColor.withValues(alpha: 0.1),
          onTap: isButtonEnabled ? widget.onPressed : null,
          child: Center(
            child: widget.isLoading
                ? _buildLoadingIndicator(effectiveTextColor)
                : _buildContent(effectiveTextColor),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(Color color) {
    return SizedBox(
      width: widget.size.iconSize,
      height: widget.size.iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: textColor,
            size: widget.size.iconSize,
          ),
          const SizedBox(width: HvacSpacing.smR),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: HvacTypography.buttonMedium.copyWith(
              color: textColor,
              fontSize: widget.size.fontSize,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

}