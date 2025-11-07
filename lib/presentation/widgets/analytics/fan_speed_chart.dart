/// Fan Speed Chart Widget
///
/// Pie chart widget for displaying fan speed distribution
/// Extracted from analytics_screen.dart to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class FanSpeedChart extends StatelessWidget {
  const FanSpeedChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.lgR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(HvacRadius.mdR),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Распределение скорости вентиляторов',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: HvacSpacing.lgR),
          SizedBox(
            height: 200.0,
            child: PieChart(
              PieChartData(
                sections: _generateSections(),
                sectionsSpace: 2,
                centerSpaceRadius: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    return [
      PieChartSectionData(
        color: HvacColors.success,
        value: 30,
        title: '30%\nНизкая',
        radius: 80.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: HvacColors.info,
        value: 45,
        title: '45%\nСредняя',
        radius: 80.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: HvacColors.warning,
        value: 20,
        title: '20%\nВысокая',
        radius: 80.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: HvacColors.error,
        value: 5,
        title: '5%\nМакс',
        radius: 80.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }
}
