/// Quick Stats Widget
///
/// Displays runtime, energy, temperature, and humidity stats in a row layout
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../domain/entities/hvac_unit.dart';
import '../unit_stat_card.dart';

class OverviewQuickStats extends StatelessWidget {
  final HvacUnit unit;

  const OverviewQuickStats({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Runtime and Energy row
        const Row(
          children: [
            Expanded(
              child: UnitStatCard(
                label: 'Время работы',
                value: '2ч 15м',
                icon: Icons.access_time,
                color: HvacColors.info,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: UnitStatCard(
                label: 'Энергия',
                value: '350 Вт',
                icon: Icons.bolt,
                color: HvacColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),

        // Temperature and Humidity row
        Row(
          children: [
            Expanded(
              child: UnitStatCard(
                label: 'Температура притока',
                value: '${unit.supplyAirTemp?.toInt() ?? 0}°C',
                icon: Icons.thermostat,
                color: HvacColors.success,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: UnitStatCard(
                label: 'Влажность',
                value: '${unit.humidity.toInt()}%',
                icon: Icons.water_drop,
                color: HvacColors.info,
              ),
            ),
          ],
        ),
      ],
    );
  }
}