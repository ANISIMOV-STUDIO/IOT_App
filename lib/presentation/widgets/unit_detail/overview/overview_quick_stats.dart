/// Quick Stats Widget
///
/// Displays runtime, energy, temperature, and humidity stats in a row layout
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../domain/entities/hvac_unit.dart';

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
              child: HvacStatCard(
                title: 'Время работы',
                value: '2ч 15м',
                icon: Icons.access_time,
                iconColor: HvacColors.info,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: HvacStatCard(
                title: 'Энергия',
                value: '350 Вт',
                icon: Icons.bolt,
                iconColor: HvacColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),

        // Temperature and Humidity row
        Row(
          children: [
            Expanded(
              child: HvacStatCard(
                title: 'Температура притока',
                value: '${unit.supplyAirTemp?.toInt() ?? 0}°C',
                icon: Icons.thermostat,
                iconColor: HvacColors.success,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: HvacStatCard(
                title: 'Влажность',
                value: '${unit.humidity.toInt()}%',
                icon: Icons.water_drop,
                iconColor: HvacColors.info,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
