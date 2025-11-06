/// Temperature Chart Widget
///
/// Displays a 24-hour temperature chart with animated lines
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../domain/entities/hvac_unit.dart';

class OverviewTemperatureChart extends StatelessWidget {
  final HvacUnit unit;

  const OverviewTemperatureChart({
    super.key,
    required this.unit,
  });

  /// Generate mock temperature data for the last 24 hours
  List<FlSpot> _generateTemperatureData() {
    final baseTemp = unit.supplyAirTemp ?? 22.0;
    final spots = <FlSpot>[];

    for (int i = 0; i < 24; i++) {
      final variance = (i % 3) * 0.8 - 0.4; // Small variations
      spots.add(FlSpot(i.toDouble(), baseTemp + variance));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart,
                color: HvacColors.primaryOrange,
                size: 20.0,
              ),
              const SizedBox(width: 12.0),
              Text(
                'Температура за 24 часа',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.0,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          HvacAnimatedLineChart(
            spots: _generateTemperatureData(),
            lineColor: HvacColors.primaryOrange,
            gradientStartColor: HvacColors.primaryOrange,
            gradientEndColor: HvacColors.info,
            showDots: false,
            showGrid: true,
          ),
        ],
      ),
    );
  }
}