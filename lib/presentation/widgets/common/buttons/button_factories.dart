/// Button Factory Methods
/// Convenience factories for creating common button types
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_accessible_button.dart';
import 'button_types.dart';

/// Factory for creating icon buttons
class AccessibleButtonFactory {
  AccessibleButtonFactory._();

  /// Create an icon button
  static BaseAccessibleButton icon({
    required VoidCallback? onPressed,
    required IconData icon,
    String? semanticLabel,
    String? tooltip,
    ButtonStyle? style,
    double size = 24.0,
    Color? color,
    bool loading = false,
  }) {
    return BaseAccessibleButton(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      style: style,
      type: ButtonType.icon,
      loading: loading,
      child: Icon(
        icon,
        size: size.r,
        color: color,
        semanticLabel: semanticLabel,
      ),
    );
  }

  /// Create a text button
  static BaseAccessibleButton text({
    required VoidCallback? onPressed,
    required String text,
    TextStyle? textStyle,
    String? semanticLabel,
    String? tooltip,
    ButtonStyle? style,
    bool loading = false,
    IconData? icon,
    CustomIconAlignment iconAlignment = CustomIconAlignment.start,
  }) {
    return BaseAccessibleButton(
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

  /// Create an elevated button
  static BaseAccessibleButton elevated({
    required VoidCallback? onPressed,
    required Widget child,
    String? semanticLabel,
    String? tooltip,
    ButtonStyle? style,
    bool loading = false,
    IconData? icon,
    CustomIconAlignment iconAlignment = CustomIconAlignment.start,
  }) {
    return BaseAccessibleButton(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      style: style,
      type: ButtonType.elevated,
      loading: loading,
      icon: icon,
      iconAlignment: iconAlignment,
      child: child,
    );
  }

  /// Create a filled button
  static BaseAccessibleButton filled({
    required VoidCallback? onPressed,
    required Widget child,
    String? semanticLabel,
    String? tooltip,
    ButtonStyle? style,
    bool loading = false,
    IconData? icon,
    CustomIconAlignment iconAlignment = CustomIconAlignment.start,
  }) {
    return BaseAccessibleButton(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      style: style,
      type: ButtonType.filled,
      loading: loading,
      icon: icon,
      iconAlignment: iconAlignment,
      child: child,
    );
  }

  /// Create an outlined button
  static BaseAccessibleButton outlined({
    required VoidCallback? onPressed,
    required Widget child,
    String? semanticLabel,
    String? tooltip,
    ButtonStyle? style,
    bool loading = false,
    IconData? icon,
    CustomIconAlignment iconAlignment = CustomIconAlignment.start,
  }) {
    return BaseAccessibleButton(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      style: style,
      type: ButtonType.outlined,
      loading: loading,
      icon: icon,
      iconAlignment: iconAlignment,
      child: child,
    );
  }

  /// Create a tonal button
  static BaseAccessibleButton tonal({
    required VoidCallback? onPressed,
    required Widget child,
    String? semanticLabel,
    String? tooltip,
    ButtonStyle? style,
    bool loading = false,
    IconData? icon,
    CustomIconAlignment iconAlignment = CustomIconAlignment.start,
  }) {
    return BaseAccessibleButton(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      style: style,
      type: ButtonType.tonal,
      loading: loading,
      icon: icon,
      iconAlignment: iconAlignment,
      child: child,
    );
  }
}