/// Analytics Content Widget
///
/// Orchestrates the layout of all analytics charts and summaries
/// Single Responsibility: Content layout and composition
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/temperature_reading.dart';
import '../../../domain/entities/hvac_unit.dart';
import 'analytics_summary_grid.dart';
import 'analytics_temperature_chart.dart';
import 'analytics_animated_chart_wrapper.dart';
import 'energy_chart.dart';
import 'fan_speed_chart.dart';
import 'humidity_chart.dart';

class AnalyticsContent extends StatelessWidget {
  final HvacUnit unit;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final List<TemperatureReading> temperatureData;
  final List<TemperatureReading> humidityData;
  final bool isLoading;

  const AnalyticsContent({
    super.key,
    required this.unit,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.temperatureData,
    required this.humidityData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AnalyticsSummaryGrid(),
            const SizedBox(height: HvacSpacing.mdR),
            AnalyticsAnimatedChartWrapper(
              index: 0,
              isLoading: isLoading,
              child: AnalyticsTemperatureChart(
                data: temperatureData,
                isLoading: isLoading,
              ),
            ),
            const SizedBox(height: HvacSpacing.lgR),
            AnalyticsAnimatedChartWrapper(
              index: 1,
              isLoading: isLoading,
              child: HumidityChart(
                readings: humidityData,
              ),
            ),
            const SizedBox(height: HvacSpacing.lgR),
            AnalyticsAnimatedChartWrapper(
              index: 2,
              isLoading: isLoading,
              child: const EnergyChart(),
            ),
            const SizedBox(height: HvacSpacing.lgR),
            AnalyticsAnimatedChartWrapper(
              index: 3,
              isLoading: isLoading,
              child: const FanSpeedChart(),
            ),
          ],
        ),
      ),
    );
  }
}