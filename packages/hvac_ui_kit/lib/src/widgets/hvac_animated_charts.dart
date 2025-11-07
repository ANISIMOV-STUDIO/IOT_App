/// HVAC UI Kit - Animated Charts
///
/// Enhanced chart animations and interactions
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/colors.dart';

/// Animated line chart with HVAC styling
class HvacAnimatedLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final Color? lineColor;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final bool showDots;
  final bool showGrid;
  final String? title;
  final Duration animationDuration;

  const HvacAnimatedLineChart({
    super.key,
    required this.spots,
    this.lineColor,
    this.gradientStartColor,
    this.gradientEndColor,
    this.showDots = true,
    this.showGrid = true,
    this.title,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: showGrid),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: HvacColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: HvacColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: lineColor ?? HvacColors.primaryOrange,
                  barWidth: 3,
                  dotData: FlDotData(show: showDots),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        (gradientStartColor ?? HvacColors.primaryOrange).withValues(alpha:0.3),
                        (gradientEndColor ?? HvacColors.primaryOrange).withValues(alpha:0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
            duration: animationDuration,
            curve: Curves.easeInOutCubic,
          ),
        ),
      ],
    );
  }
}

/// Animated bar chart with HVAC styling
class HvacAnimatedBarChart extends StatelessWidget {
  final List<double> values;
  final List<String>? labels;
  final Color? barColor;
  final String? title;
  final Duration animationDuration;

  const HvacAnimatedBarChart({
    super.key,
    required this.values,
    this.labels,
    this.barColor,
    this.title,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(
                values.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: values[index],
                      color: barColor ?? HvacColors.primaryOrange,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: HvacColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: labels != null,
                    getTitlesWidget: (value, meta) {
                      if (labels == null || value.toInt() >= labels!.length) {
                        return const Text('');
                      }
                      return Text(
                        labels![value.toInt()],
                        style: const TextStyle(
                          fontSize: 12,
                          color: HvacColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true),
            ),
            duration: animationDuration,
            curve: Curves.easeInOutCubic,
          ),
        ),
      ],
    );
  }
}

/// Pulse animation for current data point
class HvacPulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const HvacPulsingDot({
    super.key,
    this.color = Colors.orange,
    this.size = 12,
  });

  @override
  State<HvacPulsingDot> createState() => _HvacPulsingDotState();
}

class _HvacPulsingDotState extends State<HvacPulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size * _animation.value,
          height: widget.size * _animation.value,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha:0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
