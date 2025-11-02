/// Temperature Info Card Widget
///
/// Small card for displaying temperature values (setpoint, room, outdoor)
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TemperatureInfoCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? valueColor;

  const TemperatureInfoCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 24,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 8),
          ],
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
