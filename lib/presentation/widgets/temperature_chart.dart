/// Temperature Chart
///
/// Modern line chart with gradient fills using fl_chart
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/temperature_reading.dart';

class TemperatureChart extends StatefulWidget {
  final List<TemperatureReading> readings;
  final double targetTemp;
  final String mode;

  const TemperatureChart({
    super.key,
    required this.readings,
    required this.targetTemp,
    this.mode = 'auto',
  });

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.readings.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modeColor = AppTheme.getModeColor(widget.mode);
    final modeGradient = AppTheme.getModeGradient(widget.mode, isDark: isDark);

    return Container(
      decoration: AppTheme.glassmorphicCard(
        isDark: isDark,
        borderRadius: 24,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature History',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last 24 hours',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppTheme.darkTextHint
                              : AppTheme.lightTextHint,
                        ),
                  ),
                ],
              ),
              // Legend
              Row(
                children: [
                  _buildLegendItem(
                    'Current',
                    modeColor,
                    isDark,
                    isSolid: true,
                  ),
                  const SizedBox(width: 16),
                  _buildLegendItem(
                    'Target',
                    isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                    isDark,
                    isDashed: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Chart
          SizedBox(
            height: 220,
            child: LineChart(
              _buildChartData(modeColor, modeGradient, isDark),
              duration: const Duration(milliseconds: 250),
            ),
          ),

          const SizedBox(height: 24),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                'Average',
                _calculateAverage(),
                Icons.analytics_outlined,
                isDark,
                modeColor,
              ),
              Container(
                width: 1,
                height: 40,
                color: (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                    .withOpacity(0.3),
              ),
              _buildStatItem(
                context,
                'Min',
                _calculateMin(),
                Icons.arrow_downward_rounded,
                isDark,
                Colors.blue,
              ),
              Container(
                width: 1,
                height: 40,
                color: (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                    .withOpacity(0.3),
              ),
              _buildStatItem(
                context,
                'Max',
                _calculateMax(),
                Icons.arrow_upward_rounded,
                isDark,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    String label,
    Color color,
    bool isDark, {
    bool isSolid = false,
    bool isDashed = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: isSolid ? color : null,
            border: isDashed ? Border.all(color: color, width: 2) : null,
            borderRadius: BorderRadius.circular(2),
          ),
          child: isDashed
              ? CustomPaint(
                  painter: _DashedLinePainter(color: color),
                )
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    double value,
    IconData icon,
    bool isDark,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppTheme.darkTextHint : AppTheme.lightTextHint,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}°C',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  LineChartData _buildChartData(
    Color modeColor,
    LinearGradient modeGradient,
    bool isDark,
  ) {
    final spots = widget.readings.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.temperature,
      );
    }).toList();

    // Calculate min/max for Y axis with padding
    final temps = widget.readings.map((r) => r.temperature).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b) - 2;
    final maxTemp = temps.reduce((a, b) => a > b ? a : b) + 2;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 2,
        verticalInterval: widget.readings.length / 6,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                .withOpacity(0.2),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                .withOpacity(0.2),
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
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '${value.toInt()}°',
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.darkTextHint
                        : AppTheme.lightTextHint,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
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
            interval: widget.readings.length / 6,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= widget.readings.length) {
                return const SizedBox.shrink();
              }
              final time = widget.readings[index].timestamp;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  DateFormat('HH:mm').format(time),
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.darkTextHint
                        : AppTheme.lightTextHint,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
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
          color: (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
              .withOpacity(0.3),
          width: 1.5,
        ),
      ),
      minX: 0,
      maxX: widget.readings.length.toDouble() - 1,
      minY: minTemp,
      maxY: maxTemp,
      lineBarsData: [
        // Actual temperature line with gradient
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: modeGradient,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: _touchedIndex == index ? 5 : 0,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: modeColor,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                modeGradient.colors[0].withOpacity(0.3),
                modeGradient.colors[1].withOpacity(0.1),
                modeGradient.colors[1].withOpacity(0.0),
              ],
            ),
          ),
        ),
        // Target temperature line (dashed)
        LineChartBarData(
          spots: [
            FlSpot(0, widget.targetTemp),
            FlSpot(widget.readings.length.toDouble() - 1, widget.targetTemp),
          ],
          isCurved: false,
          color: isDark
              ? AppTheme.darkTextSecondary
              : AppTheme.lightTextSecondary,
          barWidth: 2,
          isStrokeCapRound: true,
          dashArray: [8, 4],
          dotData: const FlDotData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (event, response) {
          setState(() {
            if (response?.lineBarSpots != null &&
                response!.lineBarSpots!.isNotEmpty) {
              _touchedIndex = response.lineBarSpots![0].spotIndex;
            } else {
              _touchedIndex = null;
            }
          });
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: modeColor,
          tooltipRoundedRadius: 12,
          tooltipPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              if (spot.barIndex == 0) {
                // Actual temperature
                final reading = widget.readings[spot.x.toInt()];
                return LineTooltipItem(
                  '${reading.temperature.toStringAsFixed(1)}°C\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat('HH:mm').format(reading.timestamp),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 11,
                      ),
                    ),
                  ],
                );
              } else {
                // Target temperature
                return LineTooltipItem(
                  'Target: ${widget.targetTemp.toStringAsFixed(1)}°C',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }
            }).toList();
          },
        ),
      ),
    );
  }

  double _calculateAverage() {
    if (widget.readings.isEmpty) return 0;
    final sum = widget.readings.fold<double>(
      0,
      (sum, reading) => sum + reading.temperature,
    );
    return sum / widget.readings.length;
  }

  double _calculateMin() {
    if (widget.readings.isEmpty) return 0;
    return widget.readings
        .map((r) => r.temperature)
        .reduce((a, b) => a < b ? a : b);
  }

  double _calculateMax() {
    if (widget.readings.isEmpty) return 0;
    return widget.readings
        .map((r) => r.temperature)
        .reduce((a, b) => a > b ? a : b);
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 3;
    const dashSpace = 2;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
