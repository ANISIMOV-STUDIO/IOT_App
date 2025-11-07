/// Outline Button for HVAC UI Kit
///
/// Professional outline/secondary button with:
/// - Corporate blue theme
/// - Animated border on hover
/// - Loading states
/// - Hover effects for web
/// - Accessibility support
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/typography.dart';
import 'hvac_primary_button.dart'; // For HvacButtonSize

/// Outline/secondary button component with corporate blue theme
///
/// Usage:
/// ```dart
/// HvacOutlineButton(
///   label: 'Cancel',
///   onPressed: () => _handleCancel(),
///   icon: Icons.close,
/// )
/// ```
class HvacOutlineButton extends StatefulWidget {
  /// Button label text
  final String label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Optional icon to show before label
  final IconData? icon;

  /// Show loading indicator instead of label
  final bool isLoading;

  /// Expand button to fill width
  final bool isExpanded;

  /// Custom width (if not expanded)
  final double? width;

  /// Custom height (defaults to size.height)
  final double? height;

  /// Button size variant
  final HvacButtonSize size;

  /// Enable haptic feedback
  final bool enableHaptic;

  /// Custom border color (defaults to accent)
  final Color? borderColor;

  /// Custom text color (defaults to accent)
  final Color? textColor;

  /// Custom padding
  final EdgeInsets? padding;

  const HvacOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.width,
    this.height,
    this.size = HvacButtonSize.medium,
    this.enableHaptic = true,
    this.borderColor,
    this.textColor,
    this.padding,
  });

  @override
  State<HvacOutlineButton> createState() => _HvacOutlineButtonState();
}

class _HvacOutlineButtonState extends State<HvacOutlineButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderAnimation;
  bool _isHovered = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _borderAnimation = Tween<double>(begin: 1.5, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (!_isEnabled) return;

    setState(() => _isHovered = isHovered);

    if (isHovered) {
      _controller.forward();
      if (widget.enableHaptic) {
        HapticFeedback.selectionClick();
      }
    } else {
      _controller.reverse();
    }
  }

  void _handleTap() {
    if (!_isEnabled) return;
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = widget.padding ?? widget.size.padding;
    final effectiveHeight = widget.height ?? widget.size.height;
    final borderColor = widget.borderColor ?? HvacColors.accent;
    final textColor = widget.textColor ?? HvacColors.accent;

    return MouseRegion(
      cursor:
          _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _borderAnimation,
          builder: (context, child) => _buildContainer(
            effectivePadding,
            effectiveHeight,
            borderColor,
            textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(
    EdgeInsets padding,
    double height,
    Color borderColor,
    Color textColor,
  ) {
    final effectiveBorderColor =
        _isEnabled ? borderColor : borderColor.withValues(alpha: 0.5);
    final effectiveTextColor =
        _isEnabled ? textColor : textColor.withValues(alpha: 0.5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.isExpanded ? double.infinity : widget.width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: _isHovered && _isEnabled
            ? effectiveBorderColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(HvacRadius.mdR),
        border: Border.all(
          color: effectiveBorderColor,
          width: _borderAnimation.value,
        ),
      ),
      child: Center(
        child: widget.isLoading
            ? _buildLoadingIndicator(effectiveTextColor)
            : _buildContent(effectiveTextColor),
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
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: textColor,
            size: widget.size.iconSize,
          ),
          const SizedBox(width: HvacSpacing.xs),
          Flexible(
            child: Text(
              widget.label,
              style: HvacTypography.buttonMedium.copyWith(
                color: textColor,
                fontSize: widget.size.fontSize,
                fontWeight: FontWeight.w600,
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
        color: textColor,
        fontSize: widget.size.fontSize,
        fontWeight: FontWeight.w600,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
