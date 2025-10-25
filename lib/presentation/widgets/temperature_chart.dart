/// Temperature Chart
///
/// Line chart displaying temperature history using fl_chart
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/temperature_reading.dart';

class TemperatureChart extends StatelessWidget {
  final List<TemperatureReading> readings;
  final double targetTemp;

  const TemperatureChart({
    super.key,
    required this.readings,
    required this.targetTemp,
  });

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temperature History (24h)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                _buildChartData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildChartData() {
    final spots = readings.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.temperature,
      );
    }).toList();

    // Calculate min/max for Y axis
    final temps = readings.map((r) => r.temperature).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b) - 2;
    final maxTemp = temps.reduce((a, b) => a > b ? a : b) + 2;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: readings.length / 6,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}°',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: readings.length / 6,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= readings.length) {
                return const SizedBox.shrink();
              }
              final time = readings[index].timestamp;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  DateFormat('HH:mm').format(time),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              );
            },
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      minX: 0,
      maxX: readings.length.toDouble() - 1,
      minY: minTemp,
      maxY: maxTemp,
      lineBarsData: [
        // Actual temperature line
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppTheme.primaryColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.primaryColor.withOpacity(0.1),
          ),
        ),
        // Target temperature line
        LineChartBarData(
          spots: [
            FlSpot(0, targetTemp),
            FlSpot(readings.length.toDouble() - 1, targetTemp),
          ],
          isCurved: false,
          color: AppTheme.heatColor,
          barWidth: 2,
          isStrokeCapRound: true,
          dashArray: [5, 5],
          dotData: const FlDotData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              if (spot.barIndex == 0) {
                // Actual temperature
                final reading = readings[spot.x.toInt()];
                return LineTooltipItem(
                  '${reading.temperature.toStringAsFixed(1)}°C\n${DateFormat('HH:mm').format(reading.timestamp)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                // Target temperature
                return LineTooltipItem(
                  'Target: ${targetTemp.toStringAsFixed(1)}°C',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            }).toList();
          },
        ),
      ),
    );
  }
}
