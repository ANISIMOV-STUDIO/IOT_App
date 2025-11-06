/// Hero Temperature Card Widget
///
/// Displays the main temperature with gradient border and pulsing status indicator
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../domain/entities/hvac_unit.dart';
import '../../../../domain/entities/ventilation_mode.dart';

class OverviewHeroTemperature extends StatelessWidget {
  final HvacUnit unit;

  const OverviewHeroTemperature({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final temp = unit.supplyAirTemp?.toInt() ?? 0;
    return HvacGradientBorder(
      gradientColors: const [
        HvacColors.primaryOrange,
        HvacColors.info,
      ],
      borderWidth: 3,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.thermostat,
                  color: HvacColors.primaryOrange,
                  size: 28.0,
                ),
                const SizedBox(width: 12.0),
                Text(
                  'Текущая температура',
                  style: HvacTypography.titleLarge.copyWith(
                    fontSize: 16.0,
                    color: HvacColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (unit.power)
                  const HvacPulsingDot(
                    color: HvacColors.success,
                    size: 12,
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            HvacTemperatureHero(
              tag: 'unit_temp_${unit.id}',
              temperature: '$temp°C',
              style: const TextStyle(
                fontSize: 52.0,
                fontWeight: FontWeight.w700,
                color: HvacColors.textPrimary,
                height: 1,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Режим: ${unit.ventMode != null ? _getModeDisplayName(unit.ventMode!) : "Не установлен"}',
              style: HvacTypography.bodyMedium.copyWith(
                fontSize: 14.0,
                color: HvacColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getModeDisplayName(VentilationMode mode) {
    return switch (mode) {
      VentilationMode.basic => 'Базовый',
      VentilationMode.intensive => 'Интенсивный',
      VentilationMode.economic => 'Экономичный',
      VentilationMode.maximum => 'Максимальный',
      VentilationMode.kitchen => 'Кухня',
      VentilationMode.fireplace => 'Камин',
      VentilationMode.vacation => 'Отпуск',
      VentilationMode.custom => 'Пользовательский',
    };
  }
}