/// Accessible Floating Action Button Component
/// FAB with accessibility and web enhancements
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        onPressed: onPressed != null && !loading
            ? () {
                if (!kIsWeb) {
                  HapticFeedback.lightImpact();
                }
                onPressed!();
              }
            : null,
        icon: loading
            ? SizedBox(
                width: 20.0,
                height: 20.0,
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
        onPressed: onPressed != null && !loading
            ? () {
                if (!kIsWeb) {
                  HapticFeedback.lightImpact();
                }
                onPressed!();
              }
            : null,
        mini: mini,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        heroTag: heroTag,
        child: loading
            ? SizedBox(
                width: 24.0,
                height: 24.0,
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

    // Web enhancements
    if (kIsWeb) {
      fab = MouseRegion(
        cursor: (onPressed != null && !loading)
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: fab,
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