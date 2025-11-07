/// Primary Button for HVAC UI Kit
///
/// Professional primary button with:
/// - Corporate blue theme
/// - Smooth animations and haptic feedback
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

/// Size variants for buttons
enum HvacButtonSize {
  small(height: 40.0, fontSize: 14.0, iconSize: 16.0, padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
  medium(height: 48.0, fontSize: 16.0, iconSize: 20.0, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
  large(height: 56.0, fontSize: 18.0, iconSize: 24.0, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14));

  const HvacButtonSize({
    required this.height,
    required this.fontSize,
    required this.iconSize,
    required this.padding,
  });

  final double height;
  final double fontSize;
  final double iconSize;
  final EdgeInsets padding;
}

/// Primary button component with corporate blue theme
///
/// Usage:
/// ```dart
/// HvacPrimaryButton(
///   label: 'Submit',
///   onPressed: () => _handleSubmit(),
///   icon: Icons.check,
///   isLoading: _isLoading,
/// )
/// ```
class HvacPrimaryButton extends StatefulWidget {
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

  /// Custom padding
  final EdgeInsets? padding;

  const HvacPrimaryButton({
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
    this.padding,
  });

  @override
  State<HvacPrimaryButton> createState() => _HvacPrimaryButtonState();
}

class _HvacPrimaryButtonState extends State<HvacPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    _controller.forward();
    setState(() => _isPressed = true);
    if (widget.enableHaptic) {
      HapticFeedback.selectionClick();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  void _handleHover(bool isHovered) {
    if (!_isEnabled) return;
    setState(() => _isHovered = isHovered);
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = widget.padding ?? widget.size.padding;
    final effectiveHeight = widget.height ?? widget.size.height;

    return MouseRegion(
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _isEnabled ? widget.onPressed : null,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildContainer(effectivePadding, effectiveHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(EdgeInsets padding, double height) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.isExpanded ? double.infinity : widget.width,
      height: height,
      padding: padding,
      decoration: _buildDecoration(),
      child: Center(
        child: widget.isLoading ? _buildLoadingIndicator() : _buildContent(),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    if (!_isEnabled) {
      return BoxDecoration(
        color: HvacColors.backgroundCardBorder,
        borderRadius: BorderRadius.circular(HvacRadius.mdR),
      );
    }

    return BoxDecoration(
      gradient: LinearGradient(
        colors: _isHovered
            ? [
                HvacColors.accent.withValues(alpha: 0.9),
                HvacColors.accentDark.withValues(alpha: 0.9),
              ]
            : [HvacColors.accent, HvacColors.accentDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(HvacRadius.mdR),
      boxShadow: _buildShadows(),
    );
  }

  List<BoxShadow> _buildShadows() {
    if (_isPressed || !_isEnabled) return [];

    final shadowOpacity = _isHovered ? 0.4 : 0.3;
    return [
      BoxShadow(
        color: HvacColors.accent.withValues(alpha: shadowOpacity),
        blurRadius: _isHovered ? 16 : 12,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: HvacColors.accent.withValues(alpha: shadowOpacity * 0.5),
        blurRadius: _isHovered ? 28 : 24,
        offset: const Offset(0, 8),
      ),
    ];
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: widget.size.iconSize,
      height: widget.size.iconSize,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(HvacColors.textPrimary),
      ),
    );
  }

  Widget _buildContent() {
    final textColor = _isEnabled ? HvacColors.textPrimary : HvacColors.textDisabled;

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
          SizedBox(width: HvacSpacing.xs),
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
