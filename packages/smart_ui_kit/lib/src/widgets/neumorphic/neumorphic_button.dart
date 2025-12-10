import 'package:flutter/material.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Neumorphic Button - Soft UI button with press animation
class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final NeumorphicButtonVariant variant;
  final NeumorphicButtonSize size;
  final double? width;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final Color? backgroundColor;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = NeumorphicButtonVariant.filled,
    this.size = NeumorphicButtonSize.medium,
    this.width,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
  });

  /// Icon-only button constructor
  const NeumorphicButton.icon({
    super.key,
    required IconData this.icon,
    this.onPressed,
    this.size = NeumorphicButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
  })  : child = const SizedBox.shrink(),
        variant = NeumorphicButtonVariant.filled,
        width = null;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  bool get _isEnabled => !widget.isDisabled && !widget.isLoading;

  void _handleTapDown(TapDownDetails details) {
    if (_isEnabled) setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isEnabled) {
      setState(() => _isPressed = false);
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final sizeConfig = _getSizeConfig();

    final bgColor = widget.backgroundColor ?? 
        (widget.variant == NeumorphicButtonVariant.primary 
            ? NeumorphicColors.accentPrimary 
            : theme.colors.cardSurface);

    final shadows = _isPressed 
        ? theme.shadows.concaveSmall 
        : theme.shadows.convexSmall;

    final opacity = widget.isDisabled ? 0.5 : 1.0;

    Widget content = widget.icon != null && widget.child is SizedBox
        ? Icon(widget.icon, size: sizeConfig.iconSize)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: sizeConfig.iconSize),
                SizedBox(width: NeumorphicSpacing.xs),
              ],
              if (widget.isLoading)
                SizedBox(
                  width: sizeConfig.iconSize,
                  height: sizeConfig.iconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _getContentColor(theme, bgColor),
                  ),
                )
              else
                DefaultTextStyle(
                  style: theme.typography.labelLarge.copyWith(
                    color: _getContentColor(theme, bgColor),
                  ),
                  child: widget.child,
                ),
            ],
          );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: widget.width ?? (widget.icon != null && widget.child is SizedBox 
              ? sizeConfig.height 
              : null),
          height: sizeConfig.height,
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.horizontalPadding,
            vertical: sizeConfig.verticalPadding,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            boxShadow: widget.isDisabled ? [] : shadows,
          ),
          child: Center(child: content),
        ),
      ),
    );
  }

  Color _getContentColor(NeumorphicThemeData theme, Color bgColor) {
    if (widget.variant == NeumorphicButtonVariant.primary ||
        widget.backgroundColor == NeumorphicColors.accentPrimary) {
      return Colors.white;
    }
    return theme.colors.textPrimary;
  }

  _ButtonSizeConfig _getSizeConfig() {
    switch (widget.size) {
      case NeumorphicButtonSize.small:
        return const _ButtonSizeConfig(
          height: 36,
          horizontalPadding: 16,
          verticalPadding: 8,
          iconSize: 18,
          borderRadius: 10,
        );
      case NeumorphicButtonSize.medium:
        return const _ButtonSizeConfig(
          height: 44,
          horizontalPadding: 20,
          verticalPadding: 12,
          iconSize: 20,
          borderRadius: 12,
        );
      case NeumorphicButtonSize.large:
        return const _ButtonSizeConfig(
          height: 52,
          horizontalPadding: 24,
          verticalPadding: 14,
          iconSize: 24,
          borderRadius: 14,
        );
    }
  }
}

class _ButtonSizeConfig {
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double borderRadius;

  const _ButtonSizeConfig({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.borderRadius,
  });
}

enum NeumorphicButtonVariant {
  filled,
  primary,
  outline,
}

enum NeumorphicButtonSize {
  small,
  medium,
  large,
}
