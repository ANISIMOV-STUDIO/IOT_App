/// Text Button for HVAC UI Kit
///
/// Lightweight text button with:
/// - Corporate blue theme
/// - Hover effects
/// - Loading states
/// - Accessibility support
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import 'hvac_primary_button.dart'; // For HvacButtonSize

/// Text button component (tertiary button style)
///
/// Usage:
/// ```dart
/// HvacTextButton(
///   label: 'Skip',
///   onPressed: () => _handleSkip(),
///   icon: Icons.arrow_forward,
/// )
/// ```
class HvacTextButton extends StatefulWidget {
  /// Button label text
  final String label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Optional icon to show before label
  final IconData? icon;

  /// Show loading indicator instead of label
  final bool isLoading;

  /// Button size variant
  final HvacButtonSize size;

  /// Enable haptic feedback
  final bool enableHaptic;

  /// Custom text color (defaults to accent)
  final Color? textColor;

  const HvacTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = HvacButtonSize.medium,
    this.enableHaptic = true,
    this.textColor,
  });

  @override
  State<HvacTextButton> createState() => _HvacTextButtonState();
}

class _HvacTextButtonState extends State<HvacTextButton> {
  bool _isHovered = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  void _handleHover(bool isHovered) {
    if (!_isEnabled) return;
    setState(() => _isHovered = isHovered);
    if (isHovered && widget.enableHaptic) {
      HapticFeedback.selectionClick();
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
    final textColor = widget.textColor ?? HvacColors.accent;
    final effectiveTextColor =
        _isEnabled ? textColor : textColor.withValues(alpha: 0.5);

    return MouseRegion(
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.sm,
            vertical: HvacSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: _isHovered && _isEnabled
                ? effectiveTextColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.isLoading
              ? _buildLoadingIndicator(effectiveTextColor)
              : _buildContent(effectiveTextColor),
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
          Text(
            widget.label,
            style: HvacTypography.buttonMedium.copyWith(
              color: textColor,
              fontSize: widget.size.fontSize,
              fontWeight: FontWeight.w600,
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
    );
  }
}

/// Icon Button for HVAC UI Kit
///
/// Circular icon button with:
/// - Corporate blue theme
/// - Hover effects
/// - Accessibility support

/// Icon button component
///
/// Usage:
/// ```dart
/// HvacIconButton(
///   icon: Icons.add,
///   onPressed: () => _handleAdd(),
///   tooltip: 'Add item',
/// )
/// ```
class HvacIconButton extends StatefulWidget {
  /// Icon to display
  final IconData icon;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Tooltip text
  final String? tooltip;

  /// Icon size
  final double? iconSize;

  /// Background color (null for transparent)
  final Color? backgroundColor;

  /// Icon color (defaults to accent)
  final Color? iconColor;

  /// Enable haptic feedback
  final bool enableHaptic;

  const HvacIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
    this.enableHaptic = true,
  });

  @override
  State<HvacIconButton> createState() => _HvacIconButtonState();
}

class _HvacIconButtonState extends State<HvacIconButton> {
  bool _isHovered = false;

  bool get _isEnabled => widget.onPressed != null;

  void _handleHover(bool isHovered) {
    if (!_isEnabled) return;
    setState(() => _isHovered = isHovered);
    if (isHovered && widget.enableHaptic) {
      HapticFeedback.selectionClick();
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
    final iconColor = widget.iconColor ?? HvacColors.accent;
    final effectiveIconColor =
        _isEnabled ? iconColor : iconColor.withValues(alpha: 0.5);
    final size = widget.iconSize ?? 24.0;

    final button = MouseRegion(
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size + 16,
          height: size + 16,
          decoration: BoxDecoration(
            color: widget.backgroundColor ??
                (_isHovered && _isEnabled
                    ? effectiveIconColor.withValues(alpha: 0.1)
                    : Colors.transparent),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            size: size,
            color: effectiveIconColor,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}
