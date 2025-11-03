/// Primary animated button with scale and haptic feedback
/// Web-optimized with hover states and cursor management
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_animated_button.dart';

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
  final ButtonSize size;

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
    this.size = ButtonSize.medium,
  });

  @override
  State<AnimatedPrimaryButton> createState() => _AnimatedPrimaryButtonState();
}

class _AnimatedPrimaryButtonState extends State<AnimatedPrimaryButton>
    with TickerProviderStateMixin, AnimatedButtonMixin {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  bool get enableHaptic => widget.enableHaptic;

  @override
  bool get isButtonEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  void handleTapDown(TapDownDetails details) {
    super.handleTapDown(details);
    if (isButtonEnabled) {
      setState(() => _isPressed = true);
    }
  }

  @override
  void handleTapUp(TapUpDetails details) {
    super.handleTapUp(details);
    setState(() => _isPressed = false);
  }

  @override
  void handleTapCancel() {
    super.handleTapCancel();
    setState(() => _isPressed = false);
  }

  void _handleHover(bool isHovered) {
    if (!isButtonEnabled) return;
    setState(() => _isHovered = isHovered);
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = widget.padding ?? widget.size.padding;
    final effectiveHeight = widget.height ?? widget.size.height.h;

    return MouseRegion(
      cursor: mouseCursor,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: handleTapDown,
        onTapUp: handleTapUp,
        onTapCancel: handleTapCancel,
        onTap: isButtonEnabled ? widget.onPressed : null,
        child: AnimatedBuilder(
          animation: scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: scaleAnimation.value,
            child: _buildButtonContainer(effectivePadding, effectiveHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContainer(EdgeInsets padding, double height) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.isExpanded ? double.infinity : widget.width,
      height: height,
      padding: padding,
      decoration: _buildDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(HvacRadius.mdR),
        splashColor: Colors.white.withValues(alpha: 0.2),
        highlightColor: Colors.white.withValues(alpha: 0.1),
        onTap: isButtonEnabled ? widget.onPressed : null,
        child: Center(
          child: widget.isLoading
              ? _buildLoadingIndicator()
              : _buildContent(),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    final isDisabled = !isButtonEnabled;

    return BoxDecoration(
      gradient: isDisabled
          ? null
          : LinearGradient(
              colors: _isHovered
                  ? [
                      HvacColors.primaryOrange.withValues(alpha: 0.9),
                      HvacColors.primaryOrangeDark.withValues(alpha: 0.9),
                    ]
                  : [
                      HvacColors.primaryOrange,
                      HvacColors.primaryOrangeDark,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      color: isDisabled ? HvacColors.backgroundCardBorder : null,
      borderRadius: BorderRadius.circular(HvacRadius.mdR),
      boxShadow: _buildShadows(),
    );
  }

  List<BoxShadow> _buildShadows() {
    if (_isPressed || !isButtonEnabled) return [];

    final shadowOpacity = _isHovered ? 0.4 : 0.3;
    return [
      BoxShadow(
        color: HvacColors.primaryOrange.withValues(alpha: shadowOpacity),
        blurRadius: _isHovered ? 16 : 12,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: HvacColors.primaryOrange.withValues(alpha: shadowOpacity * 0.5),
        blurRadius: _isHovered ? 28 : 24,
        offset: const Offset(0, 8),
      ),
    ];
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: widget.size.iconSize.r,
      height: widget.size.iconSize.r,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
            size: widget.size.iconSize.r,
          ),
          const SizedBox(width: HvacSpacing.smR),
          Flexible(
            child: Text(
              widget.label,
              style: HvacTypography.buttonMedium.copyWith(
                color: Colors.white,
                fontSize: widget.size.fontSize.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.label,
      style: HvacTypography.buttonMedium.copyWith(
        color: Colors.white,
        fontSize: widget.size.fontSize.sp,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}