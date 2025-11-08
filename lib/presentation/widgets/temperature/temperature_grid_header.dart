/// Temperature Grid Header
///
/// Header for temperature monitoring grid
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class TemperatureGridHeader extends StatelessWidget {
  const TemperatureGridHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                HvacColors.info.withValues(alpha: 0.2),
                HvacColors.info.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: HvacRadius.smRadius,
          ),
          child: const Icon(
            Icons.thermostat_outlined,
            color: HvacColors.info,
            size: 20.0,
          ),
        ),
        const SizedBox(width: 12.0),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Температуры',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Мониторинг и уставки',
                style: TextStyle(
                  fontSize: 12.0,
                  color: HvacColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
