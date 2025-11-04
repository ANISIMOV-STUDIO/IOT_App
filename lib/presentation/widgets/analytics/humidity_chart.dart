/// Humidity Chart Widget
///
/// Chart widget for displaying humidity history
/// Extracted from analytics_screen.dart to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/temperature_reading.dart';

class HumidityChart extends StatelessWidget {
  final List<TemperatureReading> readings;

  const HumidityChart({
    super.key,
    required this.readings,
  });

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
          Text(
            'История влажности',
            style: HvacTypography.titleMedium.copyWith(
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: HvacSpacing.lgR),
          SizedBox(
            height: 200.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: HvacColors.backgroundCardBorder,
                      strokeWidth: 1,
                    );
                  },
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
                      reservedSize: 30,
                      interval: 6,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 ||
                            value.toInt() >= readings.length) {
                          return const Text('');
                        }
                        final reading = readings[value.toInt()];
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            '${reading.timestamp.hour}:00',
                            style: HvacTypography.captionSmall.copyWith(
                              color: HvacColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: HvacTypography.captionSmall.copyWith(
                            color: HvacColors.textSecondary,
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
                minX: 0,
                maxX: (readings.length - 1).toDouble(),
                minY: 30,
                maxY: 70,
                lineBarsData: [
                  LineChartBarData(
                    spots: readings
                        .asMap()
                        .entries
                        .map((e) => FlSpot(
                              e.key.toDouble(),
                              e.value.temperature
                            ))
                        .toList(),
                    isCurved: true,
                    color: HvacColors.info,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: HvacColors.info.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}