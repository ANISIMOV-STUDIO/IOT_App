/// Energy Chart Widget
///
/// Bar chart widget for displaying energy consumption
/// Extracted from analytics_screen.dart to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class EnergyChart extends StatelessWidget {
  const EnergyChart({super.key});

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
            'Энергопотребление',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: HvacSpacing.lgR),
          SizedBox(
            height: 200.0,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 400,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} Вт',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const hours = ['00', '04', '08', '12', '16', '20'];
                        if (value.toInt() < hours.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              hours[value.toInt()],
                              style: const TextStyle(
                                color: HvacColors.textSecondary,
                                fontSize: 10.0,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}W',
                          style: const TextStyle(
                            color: HvacColors.textSecondary,
                            fontSize: 10.0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: HvacColors.backgroundCardBorder,
                    width: 1,
                  ),
                ),
                barGroups: _generateBarGroups(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: HvacColors.backgroundCardBorder,
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 250, color: HvacColors.warning)],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 300, color: HvacColors.warning)],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 350, color: HvacColors.warning)],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(toY: 380, color: HvacColors.warning)],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [BarChartRodData(toY: 320, color: HvacColors.warning)],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [BarChartRodData(toY: 280, color: HvacColors.warning)],
      ),
    ];
  }
}
