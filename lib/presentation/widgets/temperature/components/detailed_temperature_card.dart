/// Detailed temperature card component
///
/// Enhanced temperature display card for desktop layouts
/// with comprehensive information and visual hierarchy
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Detailed temperature card for desktop view
class DetailedTemperatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? value;
  final String description;
  final bool isPrimary;

  const DetailedTemperatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.description,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isPrimary ? 16.0 : 14.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: isPrimary
              ? HvacColors.neutral300.withValues(alpha: 0.3)
              : HvacColors.backgroundCardBorder,
          width: isPrimary ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: HvacColors.neutral300.withValues(alpha: 0.1),
                  borderRadius: HvacRadius.smRadius,
                ),
                child: Icon(
                  icon,
                  size: isPrimary ? 20.0 : 18.0,
                  color: HvacColors.neutral200,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: isPrimary ? 12.0 : 11.0,
                        fontWeight: FontWeight.w600,
                        color: HvacColors.textPrimary,
                      ),
                    ),
                    if (isPrimary) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 9.0,
                          color: HvacColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isPrimary ? 14.0 : 12.0),
          Text(
            value != null ? '${value!.toStringAsFixed(1)}°C' : '—',
            style: TextStyle(
              fontSize: isPrimary ? 32.0 : 24.0,
              fontWeight: FontWeight.w600,
              color: value != null
                  ? HvacColors.textPrimary
                  : HvacColors.textDisabled,
              letterSpacing: -1.5,
            ),
          ),
          if (!isPrimary && description.isNotEmpty) ...[
            const SizedBox(height: 4.0),
            Text(
              description,
              style: const TextStyle(
                fontSize: 9.0,
                color: HvacColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
