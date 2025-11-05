/// Temperature display header component
///
/// Minimalist header with title and system status indicator
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Header with title and system status for temperature display
class TemperatureHeader extends StatelessWidget {
  final bool isMobile;
  final bool showDetails;
  final bool isSystemNormal;

  const TemperatureHeader({
    super.key,
    required this.isMobile,
    this.showDetails = false,
    required this.isSystemNormal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Simple icon without shimmer for calm look
        Container(
          width: isMobile ? 28.0 : 36.0,
          height: isMobile ? 28.0 : 36.0,
          decoration: BoxDecoration(
            color: HvacColors.neutral300.withValues(alpha: 0.1),
            borderRadius: HvacRadius.smRadius,
            border: Border.all(
              color: HvacColors.neutral300.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.thermostat_outlined,
            color: HvacColors.neutral200,
            size: isMobile ? 14.0 : 18.0,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Температуры',
                style: TextStyle(
                  fontSize: isMobile ? 13.0 : 15.0,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              if (showDetails) ...[
                const SizedBox(height: 2.0),
                const Text(
                  'Мониторинг и уставки',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: HvacColors.textTertiary,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ],
          ),
        ),
        _SystemStatusIndicator(isNormal: isSystemNormal),
      ],
    );
  }
}

/// System status indicator (minimalist)
class _SystemStatusIndicator extends StatelessWidget {
  final bool isNormal;

  const _SystemStatusIndicator({
    required this.isNormal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: isNormal
            ? HvacColors.success.withValues(alpha: 0.1)
            : HvacColors.warning.withValues(alpha: 0.1),
        borderRadius: HvacRadius.xsRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.0,
            height: 5.0,
            decoration: BoxDecoration(
              color: isNormal ? HvacColors.success : HvacColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 3.0),
          Text(
            isNormal ? 'Норма' : 'Проверка',
            style: TextStyle(
              fontSize: 9.0,
              fontWeight: FontWeight.w500,
              color: isNormal ? HvacColors.success : HvacColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}