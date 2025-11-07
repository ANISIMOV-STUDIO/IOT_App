/// Accessibility Helper Functions
///
/// Provides utilities for consistent accessibility across the app
/// Follows WCAG 2.1 Level AA guidelines
library;

import 'package:flutter/material.dart';

/// Helper class for accessibility
class AccessibilityHelpers {
  AccessibilityHelpers._();

  /// Wraps an IconButton with proper semantic labels
  static Widget semanticIconButton({
    required IconButton iconButton,
    required String label,
    String? hint,
    bool isButton = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      child: iconButton,
    );
  }

  /// Creates a semantic icon button from scratch
  static Widget createSemanticIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String label,
    String? hint,
    Color? color,
    double? iconSize,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: onPressed != null,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: iconSize),
        padding: padding,
        constraints: constraints,
      ),
    );
  }

  /// Wraps a Switch with proper semantic labels
  static Widget semanticSwitch({
    required bool value,
    required ValueChanged<bool>? onChanged,
    required String label,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      toggled: value,
      enabled: onChanged != null,
      child: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  /// Wraps any interactive widget with semantic information
  static Widget semanticInteractive({
    required Widget child,
    required String label,
    String? hint,
    bool button = false,
    bool slider = false,
    bool toggled = false,
    bool enabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: button,
      slider: slider,
      toggled: toggled,
      enabled: enabled,
      child: child,
    );
  }

  /// Wraps an image with semantic label
  static Widget semanticImage({
    required Widget image,
    required String label,
    bool isDecorative = false,
  }) {
    if (isDecorative) {
      return ExcludeSemantics(child: image);
    }
    return Semantics(
      label: label,
      image: true,
      child: image,
    );
  }

  /// Announces a message to screen readers
  /// Use ScaffoldMessenger for visible announcements
  static void announce(BuildContext context, String message) {
    // For screen reader announcements, wrap widgets with Semantics(liveRegion: true)
    // This is a placeholder - actual implementation would use platform channels
    // For now, we'll use SnackBar which is also accessible
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Common semantic hints for actions
  static const String tapToOpen = 'Double tap to open';
  static const String tapToClose = 'Double tap to close';
  static const String tapToEdit = 'Double tap to edit';
  static const String tapToDelete = 'Double tap to delete';
  static const String tapToToggle = 'Double tap to toggle';
  static const String tapToRefresh = 'Double tap to refresh';
  static const String swipeToRefresh = 'Swipe down to refresh';
  static const String tapToNavigate = 'Double tap to navigate';
}
