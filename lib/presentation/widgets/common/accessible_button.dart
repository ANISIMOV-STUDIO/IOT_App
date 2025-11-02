import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/responsive_utils.dart';

/// Accessible button with minimum touch target and semantic support
class AccessibleButton extends StatelessWidget {
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
  final IconAlignment iconAlignment;

  const AccessibleButton({
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
    this.iconAlignment = IconAlignment.start,
  });

  factory AccessibleButton.icon({
    required VoidCallback? onPressed,
    required IconData icon,
    String? semanticLabel,
    String? tooltip,
    ButtonStyle? style,
    double size = 24.0,
    Color? color,
    bool loading = false,
  }) {
    return AccessibleButton(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      style: style,
      type: ButtonType.icon,
      loading: loading,
      child: Icon(
        icon,
        size: size,
        color: color,
        semanticLabel: semanticLabel,
      ),
    );
  }

  factory AccessibleButton.text({
    required VoidCallback? onPressed,
    required String text,
    TextStyle? textStyle,
    String? semanticLabel,
    String? tooltip,
    ButtonStyle? style,
    bool loading = false,
    IconData? icon,
    IconAlignment iconAlignment = IconAlignment.start,
  }) {
    return AccessibleButton(
      onPressed: onPressed,
      semanticLabel: semanticLabel ?? text,
      tooltip: tooltip,
      style: style,
      type: ButtonType.text,
      loading: loading,
      icon: icon,
      iconAlignment: iconAlignment,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = _getEffectiveStyle(context, theme);

    Widget button = _buildButton(context, theme, effectiveStyle);

    // Wrap with tooltip if provided
    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    // Wrap with semantics
    button = Semantics(
      button: true,
      enabled: onPressed != null && !loading,
      label: semanticLabel,
      hint: loading ? 'Loading' : null,
      child: button,
    );

    // Ensure minimum touch target
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: minHeight,
        minWidth: minWidth,
      ),
      child: button,
    );
  }

  Widget _buildButton(BuildContext context, ThemeData theme, ButtonStyle effectiveStyle) {
    final effectiveChild = loading
        ? _buildLoadingIndicator(context, theme)
        : _buildButtonContent(context);

    final onPressedWithHaptic = onPressed != null && !loading
        ? () {
            if (enableHapticFeedback) {
              HapticFeedback.lightImpact();
            }
            onPressed!();
          }
        : null;

    final onLongPressWithHaptic = onLongPress != null && !loading
        ? () {
            if (enableHapticFeedback) {
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
          child: effectiveChild,
        );

      case ButtonType.filled:
        return FilledButton(
          onPressed: onPressedWithHaptic,
          onLongPress: onLongPressWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          child: effectiveChild,
        );

      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressedWithHaptic,
          onLongPress: onLongPressWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          child: effectiveChild,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: onPressedWithHaptic,
          onLongPress: onLongPressWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          child: effectiveChild,
        );

      case ButtonType.icon:
        return IconButton(
          onPressed: onPressedWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          icon: effectiveChild,
        );

      case ButtonType.tonal:
        return FilledButton.tonal(
          onPressed: onPressedWithHaptic,
          onLongPress: onLongPressWithHaptic,
          style: effectiveStyle,
          autofocus: autofocus,
          focusNode: focusNode,
          child: effectiveChild,
        );
    }
  }

  Widget _buildButtonContent(BuildContext context) {
    if (icon != null && type != ButtonType.icon) {
      final iconWidget = Icon(
        icon,
        size: ResponsiveUtils.scaledIconSize(context, 20),
      );

      const spacing = SizedBox(width: AppSpacing.xs);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: iconAlignment == IconAlignment.start
            ? [iconWidget, spacing, Flexible(child: child)]
            : [Flexible(child: child), spacing, iconWidget],
      );
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
          theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  ButtonStyle _getEffectiveStyle(BuildContext context, ThemeData theme) {
    final defaultStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size(minWidth, minHeight)),
      padding: WidgetStateProperty.all(
        padding ??
            EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.scaledSpacing(context, AppSpacing.md),
              vertical: ResponsiveUtils.scaledSpacing(context, AppSpacing.sm),
            ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.scaledBorderRadius(context, AppSpacing.md),
          ),
        ),
      ),
    );

    return style?.merge(defaultStyle) ?? defaultStyle;
  }
}

/// Accessible icon button with minimum touch target
class AccessibleIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String semanticLabel;
  final String? tooltip;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final bool enableHapticFeedback;
  final bool loading;
  final double minTouchTarget;
  final ButtonStyle? style;
  final bool selected;
  final Widget? selectedIcon;

  const AccessibleIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.semanticLabel,
    this.tooltip,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
    this.enableHapticFeedback = true,
    this.loading = false,
    this.minTouchTarget = 48.0,
    this.style,
    this.selected = false,
    this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.onSurface;
    final effectiveIcon = selected && selectedIcon != null ? selectedIcon! : Icon(
      icon,
      size: ResponsiveUtils.scaledIconSize(context, size),
      color: effectiveColor,
      semanticLabel: semanticLabel,
    );

    Widget button = Material(
      color: backgroundColor ?? Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed != null && !loading
            ? () {
                if (enableHapticFeedback) {
                  HapticFeedback.lightImpact();
                }
                onPressed!();
              }
            : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: minTouchTarget,
          height: minTouchTarget,
          alignment: Alignment.center,
          child: loading
              ? SizedBox(
                  width: size * 0.8,
                  height: size * 0.8,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                  ),
                )
              : effectiveIcon,
        ),
      ),
    );

    // Wrap with tooltip if provided
    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    // Wrap with semantics
    return Semantics(
      button: true,
      enabled: onPressed != null && !loading,
      label: semanticLabel,
      hint: loading ? 'Loading' : null,
      selected: selected,
      child: button,
    );
  }
}

/// Floating action button with accessibility
class AccessibleFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String semanticLabel;
  final String? tooltip;
  final bool extended;
  final Widget? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool mini;
  final bool loading;
  final Object? heroTag;

  const AccessibleFAB({
    super.key,
    required this.onPressed,
    required this.child,
    required this.semanticLabel,
    this.tooltip,
    this.extended = false,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.mini = false,
    this.loading = false,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget fab;

    if (extended && label != null) {
      fab = FloatingActionButton.extended(
        onPressed: onPressed != null && !loading ? () {
          HapticFeedback.lightImpact();
          onPressed!();
        } : null,
        icon: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              )
            : child,
        label: label!,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        heroTag: heroTag,
      );
    } else {
      fab = FloatingActionButton(
        onPressed: onPressed != null && !loading ? () {
          HapticFeedback.lightImpact();
          onPressed!();
        } : null,
        mini: mini,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        heroTag: heroTag,
        child: loading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              )
            : child,
      );
    }

    // Wrap with tooltip if provided
    if (tooltip != null && tooltip!.isNotEmpty) {
      fab = Tooltip(
        message: tooltip!,
        child: fab,
      );
    }

    // Wrap with semantics
    return Semantics(
      button: true,
      enabled: onPressed != null && !loading,
      label: semanticLabel,
      hint: loading ? 'Loading' : null,
      child: fab,
    );
  }
}

/// Button types
enum ButtonType {
  elevated,
  filled,
  outlined,
  text,
  icon,
  tonal,
}