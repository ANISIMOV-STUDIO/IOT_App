import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';

/// Energy consumption chart for dashboard
class EnergyConsumptionChart extends StatelessWidget {
  final List<double> hourlyData;
  final Color? lineColor;
  final Color? gradientColor;
  final double height;

  const EnergyConsumptionChart({
    super.key,
    required this.hourlyData,
    this.lineColor,
    this.gradientColor,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    final color = lineColor ?? NeumorphicColors.accentPrimary;
    final gradient = gradientColor ?? color;

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 4,
                getTitlesWidget: (value, meta) {
                  final hour = value.toInt();
                  if (hour % 4 != 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (hourlyData.length - 1).toDouble(),
          minY: 0,
          maxY: _maxY,
          lineBarsData: [
            LineChartBarData(
              spots: hourlyData.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: color,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    gradient.withValues(alpha: 0.3),
                    gradient.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  double get _maxY {
    if (hourlyData.isEmpty) return 5;
    final max = hourlyData.reduce((a, b) => a > b ? a : b);
    return (max * 1.2).ceilToDouble(); // Add 20% headroom
  }
}

/// Mini sparkline chart for compact displays
class MiniSparkline extends StatelessWidget {
  final List<double> data;
  final Color? color;
  final double height;
  final double width;

  const MiniSparkline({
    super.key,
    required this.data,
    this.color,
    this.height = 40,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(height: height, width: width);

    final lineColor = color ?? NeumorphicColors.accentPrimary;
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal;

    return SizedBox(
      height: height,
      width: width,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: range > 0 ? minVal - range * 0.1 : minVal - 1,
          maxY: range > 0 ? maxVal + range * 0.1 : maxVal + 1,
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: lineColor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    lineColor.withValues(alpha: 0.2),
                    lineColor.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }
}

/// Sample data generator for testing
class EnergyChartData {
  static List<double> generateSampleHourlyData() {
    // Simulates typical home energy consumption pattern
    return [
      0.8, 0.6, 0.5, 0.4, 0.4, 0.5, // 00:00 - 05:00 (night, low)
      0.9, 1.8, 2.5, 2.2, 1.8, 1.5, // 06:00 - 11:00 (morning peak)
      1.4, 1.6, 1.8, 2.0, 2.2, 2.8, // 12:00 - 17:00 (afternoon)
      3.2, 3.5, 3.0, 2.5, 1.8, 1.2, // 18:00 - 23:00 (evening peak)
    ];
  }

  static List<double> generateSampleWeeklyData() {
    return [32.5, 28.4, 35.2, 31.8, 29.5, 38.2, 25.6];
  }
}
