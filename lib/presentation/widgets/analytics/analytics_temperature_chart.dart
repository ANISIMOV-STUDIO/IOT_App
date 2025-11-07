/// Analytics Temperature Chart Widget
///
/// Temperature history chart with animated line visualization
/// Extracted from analytics_screen.dart to respect SOLID principles
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/entities/temperature_reading.dart';

class AnalyticsTemperatureChart extends StatelessWidget {
  final List<TemperatureReading> data;
  final bool isLoading;

  const AnalyticsTemperatureChart({
    super.key,
    required this.data,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.temperature))
        .toList();

    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.show_chart,
                color: HvacColors.primaryOrange,
                size: 20.0,
              ),
              SizedBox(width: HvacSpacing.xsR),
              Text(
                'История температуры',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.lgR),
          HvacAnimatedLineChart(
            spots: spots,
            lineColor: HvacColors.primaryOrange,
            gradientStartColor: HvacColors.primaryOrange,
            gradientEndColor: HvacColors.primaryOrange,
            showDots: true,
            showGrid: true,
            animationDuration: const Duration(milliseconds: 1200),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300.0,
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150.0,
            height: 16.0,
            decoration: BoxDecoration(
              color: HvacColors.backgroundElevated,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: HvacSpacing.lgR),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: HvacColors.backgroundElevated,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
