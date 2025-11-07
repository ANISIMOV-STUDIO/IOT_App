/// Error Icon Component
///
/// Displays appropriate icon based on error type
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'error_types.dart';

/// Error icon widget
class ErrorIcon extends StatelessWidget {
  final ErrorType type;
  final IconData? customIcon;
  final double? size;

  const ErrorIcon({
    super.key,
    required this.type,
    this.customIcon,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIcon = customIcon ?? _getIconForType(type);
    final iconSize = size ?? 72.0.w;
    final iconColor = _getColorForType(theme, type);

    return Container(
      width: iconSize * 1.5,
      height: iconSize * 1.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withValues(alpha: 0.1),
      ),
      child: Icon(
        effectiveIcon,
        size: iconSize,
        color: iconColor,
        semanticLabel: 'Error icon',
      ),
    );
  }

  IconData _getIconForType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off_rounded;
      case ErrorType.server:
        return Icons.cloud_off_rounded;
      case ErrorType.permission:
        return Icons.lock_outline_rounded;
      case ErrorType.notFound:
        return Icons.search_off_rounded;
      case ErrorType.timeout:
        return Icons.timer_off_rounded;
      case ErrorType.validation:
        return Icons.warning_amber_rounded;
      case ErrorType.authentication:
        return Icons.person_off_rounded;
      case ErrorType.offline:
        return Icons.signal_wifi_off_rounded;
      case ErrorType.general:
        return Icons.error_outline_rounded;
    }
  }

  Color _getColorForType(ThemeData theme, ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Colors.orange;
      case ErrorType.server:
        return theme.colorScheme.error;
      case ErrorType.permission:
        return Colors.amber;
      case ErrorType.notFound:
        return Colors.grey;
      case ErrorType.timeout:
        return Colors.deepOrange;
      case ErrorType.validation:
        return Colors.amber;
      case ErrorType.authentication:
        return Colors.blue;
      case ErrorType.offline:
        return Colors.orange;
      case ErrorType.general:
        return theme.colorScheme.error;
    }
  }
}