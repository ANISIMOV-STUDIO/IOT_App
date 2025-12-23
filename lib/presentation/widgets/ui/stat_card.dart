/// Stat Card - Simple card showing a single metric
/// Used for temperature, humidity, CO2, etc.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'app_card.dart';

/// Simple stat card with value and label
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final IconData? icon;
  final Color? valueColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.icon,
    this.valueColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const Spacer(),

          // Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 24, color: valueColor ?? AppColors.primary),
                const SizedBox(width: 8),
              ],
              Text(
                value,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppColors.textPrimary,
                  height: 1,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Temperature card with +/- controls
class TemperatureCard extends StatelessWidget {
  final String title;
  final double value;
  final double? minValue;
  final double? maxValue;
  final ValueChanged<double>? onChanged;

  const TemperatureCard({
    super.key,
    this.title = 'Температура',
    required this.value,
    this.minValue = 16,
    this.maxValue = 30,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with dropdown indicator
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
          const Spacer(),

          // Temperature value with controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Minus button
              _TempButton(
                icon: Icons.remove,
                onTap: onChanged != null && value > (minValue ?? 16)
                    ? () => onChanged!(value - 1)
                    : null,
              ),
              const SizedBox(width: 16),

              // Value
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.round().toString(),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1,
                    ),
                  ),
                  const Text(
                    '°C',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Plus button
              _TempButton(
                icon: Icons.add,
                onTap: onChanged != null && value < (maxValue ?? 30)
                    ? () => onChanged!(value + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TempButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _TempButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? AppColors.surfaceVariant
              : AppColors.textMuted.withValues(alpha: 0.1),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.primary : AppColors.textMuted,
        ),
      ),
    );
  }
}

/// Circular progress stat (like humidity gauge)
class CircularStatCard extends StatelessWidget {
  final String title;
  final double value;
  final double maxValue;
  final String unit;
  final Color? color;

  const CircularStatCard({
    super.key,
    required this.title,
    required this.value,
    this.maxValue = 100,
    this.unit = '%',
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / maxValue).clamp(0.0, 1.0);
    final displayColor = color ?? AppColors.primary;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
          const Spacer(),

          // Circular gauge
          Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 6,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(
                        displayColor.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  // Progress arc
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(displayColor),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  // Value text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value.round().toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: displayColor,
                          height: 1,
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
