/// Base Accessible Button Component
/// Core accessible button with web enhancements
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'button_types.dart';

/// Base accessible button with minimum touch target and semantic support
class BaseAccessibleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final String? semanticLabel;
  final String? tooltip;
  final ButtonStyle? style;
  final bool enableHapticFeedback;
  final bool autofocus;
  final FocusNode? focusNode;
  final double minHeight;
  final double minWidth;
  final EdgeInsetsGeometry? padding;
  final ButtonType type;
  final bool loading;
  final IconData? icon;
  final CustomIconAlignment iconAlignment;

  const BaseAccessibleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.semanticLabel,
    this.tooltip,
    this.style,
    this.enableHapticFeedback = true,
    this.autofocus = false,
    this.focusNode,
    this.minHeight = 48.0, // WCAG minimum
    this.minWidth = 48.0, // WCAG minimum
    this.padding,
    this.type = ButtonType.elevated,
    this.loading = false,
    this.icon,
    this.iconAlignment = CustomIconAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = _getEffectiveStyle(context, theme);

    Widget button = _buildButton(context, theme, effectiveStyle);

    // Web enhancements
    if (kIsWeb) {
      button = MouseRegion(
        cursor: (onPressed != null && !loading)
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: button);
    }

    // Wrap with tooltip if provided
    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(
        message: tooltip!,
        child: button);
    }

    // Wrap with semantics
    button = Semantics(
      button: true,
      enabled: onPressed != null && !loading,
      label: semanticLabel,
      hint: loading ? 'Loading' : null,
      child: button);

    // Ensure minimum touch target
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: minHeight,
        minWidth: minWidth),
      child: button);
  }

  Widget _buildButton(
      BuildContext context, ThemeData theme, ButtonStyle effectiveStyle) {
    final effectiveChild = loading
        ? _buildLoadingIndicator(context, theme)
        : _buildButtonContent(context);

    final onPressedWithHaptic = onPressed != null && !loading
        ? () {
            if (enableHapticFeedback && !kIsWeb) {
              HapticFeedback.lightImpact();
            }
            onPressed!();
          }
        : null;

    final onLongPressWithHaptic = onLongPress != null && !loading
        ? () {
            if (enableHapticFeedback && !kIsWeb) {
              HapticFeedback.mediumImpact();
            }
            onLongPress!();
          }
        : null;

    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressedWithHaptic,
          onLongPress: onLongPressWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          child: effectiveChild);

      case ButtonType.filled:
        return FilledButton(
          onPressed: onPressedWithHaptic,
          onLongPress: onLongPressWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          child: effectiveChild);

      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressedWithHaptic,
          onLongPress: onLongPressWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          child: effectiveChild);

      case ButtonType.text:
        return TextButton(
          onPressed: onPressedWithHaptic,
          onLongPress: onLongPressWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          child: effectiveChild);

      case ButtonType.icon:
        return IconButton(
          onPressed: onPressedWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          icon: effectiveChild);

      case ButtonType.tonal:
        return FilledButton.tonal(
          onPressed: onPressedWithHaptic,
          onLongPress: onLongPressWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          child: effectiveChild);
    }
  }

  Widget _buildButtonContent(BuildContext context) {
    if (icon != null && type != ButtonType.icon) {
      final iconWidget = Icon(
        icon,
        size: ResponsiveUtils.scaledIconSize(context, 20));

      const spacing = SizedBox(width: HvacSpacing.xs);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: iconAlignment == CustomIconAlignment.start
            ? [iconWidget, spacing, Flexible(child: child)]
            : [Flexible(child: child), spacing, iconWidget]);
    }

    return child;
  }

  Widget _buildLoadingIndicator(BuildContext context, ThemeData theme) {
    final size = type == ButtonType.icon ? 20.0 : 16.0;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          theme.colorScheme.onPrimary)));
  }

  ButtonStyle _getEffectiveStyle(BuildContext context, ThemeData theme) {
    final defaultStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size(minWidth, minHeight)),
      padding: WidgetStateProperty.all(
        padding ??
            EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.scaledSpacing(context, HvacSpacing.md),
              vertical: ResponsiveUtils.scaledSpacing(context, HvacSpacing.sm))),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.scaledBorderRadius(context, HvacRadius.md)))));

    return style?.merge(defaultStyle) ?? defaultStyle;
  }
}