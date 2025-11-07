/// Error icon widget component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'error_types.dart';

class ErrorIconWidget extends StatelessWidget {
  final IconData? icon;
  final ErrorType type;
  final double size;
  final Color? color;

  const ErrorIconWidget({
    super.key,
    this.icon,
    required this.type,
    this.size = 72.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIcon = icon ?? _getIconForType();
    final iconColor = color ?? _getColorForType(theme);

    return Container(
      width: size * 1.5,
      height: size * 1.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withValues(alpha: 0.1),
      ),
      child: Icon(
        effectiveIcon,
        size: size,
        color: iconColor,
        semanticLabel: 'Error icon',
      ),
    );
  }

  IconData _getIconForType() {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off_rounded;
      case ErrorType.server:
        return Icons.cloud_off_rounded;
      case ErrorType.permission:
        return Icons.lock_outline_rounded;
      case ErrorType.validation:
        return Icons.warning_amber_rounded;
      case ErrorType.authentication:
        return Icons.person_off_rounded;
      case ErrorType.timeout:
        return Icons.hourglass_empty_rounded;
      case ErrorType.notFound:
        return Icons.search_off_rounded;
      case ErrorType.offline:
        return Icons.signal_wifi_off_rounded;
      case ErrorType.general:
      default:
        return Icons.error_outline_rounded;
    }
  }

  Color _getColorForType(ThemeData theme) {
    switch (type) {
      case ErrorType.network:
      case ErrorType.offline:
        return HvacColors.warning;
      case ErrorType.server:
      case ErrorType.timeout:
        return HvacColors.error;
      case ErrorType.permission:
      case ErrorType.authentication:
        return HvacColors.info;
      case ErrorType.validation:
        return HvacColors.warning;
      case ErrorType.notFound:
        return HvacColors.textSecondary;
      case ErrorType.general:
      default:
        return HvacColors.error;
    }
  }
}