/// Example usage of HvacAnimatedCharts
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../hvac_animated_charts.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class AnimatedChartsExample extends StatefulWidget {
  const AnimatedChartsExample({super.key});

  @override
  State<AnimatedChartsExample> createState() => _AnimatedChartsExampleState();
}

class _AnimatedChartsExampleState extends State<AnimatedChartsExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Animated Charts'),
        backgroundColor: HvacColors.backgroundDark,
      ),
      body: ListView(
        padding: EdgeInsets.all(HvacSpacing.md),
        children: [
          // Temperature line chart
          HvacAnimatedLineChart(
            title: 'Temperature Over Time',
            spots: [
              FlSpot(0, 22),
              FlSpot(1, 23),
              FlSpot(2, 24),
              FlSpot(3, 23.5),
              FlSpot(4, 25),
              FlSpot(5, 24.5),
              FlSpot(6, 24),
            ],
            lineColor: HvacColors.primaryOrange,
          ),
          SizedBox(height: HvacSpacing.xl),

          // Energy consumption bar chart
          HvacAnimatedBarChart(
            title: 'Daily Energy Usage (kWh)',
            values: [45, 52, 48, 60, 55, 58, 50],
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            barColor: HvacColors.primaryBlue,
          ),
          SizedBox(height: HvacSpacing.xl),

          // Pulsing indicator
          Text(
            'Live Data Indicator:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          SizedBox(height: HvacSpacing.md),
          Row(
            children: [
              HvacPulsingDot(color: HvacColors.success),
              SizedBox(width: HvacSpacing.sm),
              Text(
                'Device Active',
                style: TextStyle(color: HvacColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
