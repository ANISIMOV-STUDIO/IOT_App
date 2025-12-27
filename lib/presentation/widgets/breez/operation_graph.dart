/// Operation Graph Widget - Shows unit operation history
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/graph_data.dart';
import 'breez_card.dart';

export '../../../domain/entities/graph_data.dart';

/// Operation graph widget with smooth curve
class OperationGraph extends StatefulWidget {
  final List<GraphDataPoint> data;
  final GraphMetric selectedMetric;
  final ValueChanged<GraphMetric>? onMetricChanged;
  final double? highlightValue;
  final int? highlightIndex;

  const OperationGraph({
    super.key,
    required this.data,
    this.selectedMetric = GraphMetric.temperature,
    this.onMetricChanged,
    this.highlightValue,
    this.highlightIndex,
  });

  @override
  State<OperationGraph> createState() => _OperationGraphState();
}

class _OperationGraphState extends State<OperationGraph> {
  int? _hoveredIndex;

  String get _metricLabel {
    switch (widget.selectedMetric) {
      case GraphMetric.temperature:
        return 'ТЕМПЕРАТУРА';
      case GraphMetric.humidity:
        return 'ВЛАЖНОСТЬ';
      case GraphMetric.airflow:
        return 'ПОТОК ВОЗДУХА';
    }
  }

  String get _metricUnit {
    switch (widget.selectedMetric) {
      case GraphMetric.temperature:
        return '°C';
      case GraphMetric.humidity:
        return '%';
      case GraphMetric.airflow:
        return 'м³/ч';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    // Calculate statistics
    final values = widget.data.map((e) => e.value).toList();
    final currentValue = values.isNotEmpty ? values.last : 0.0;
    final minValue = values.isNotEmpty ? values.reduce(math.min) : 0.0;
    final maxValue = values.isNotEmpty ? values.reduce(math.max) : 0.0;
    final avgValue = values.isNotEmpty
        ? values.reduce((a, b) => a + b) / values.length
        : 0.0;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and current value
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _metricLabel,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          currentValue.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1,
                            color: colors.text,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _metricUnit,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Metric tabs
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MetricTab(
                    icon: Icons.thermostat_outlined,
                    label: 'Темп',
                    isSelected: widget.selectedMetric == GraphMetric.temperature,
                    onTap: () => widget.onMetricChanged?.call(GraphMetric.temperature),
                  ),
                  const SizedBox(width: 8),
                  _MetricTab(
                    icon: Icons.water_drop_outlined,
                    label: 'Влаж',
                    isSelected: widget.selectedMetric == GraphMetric.humidity,
                    onTap: () => widget.onMetricChanged?.call(GraphMetric.humidity),
                  ),
                  const SizedBox(width: 8),
                  _MetricTab(
                    icon: Icons.air,
                    label: 'Поток',
                    isSelected: widget.selectedMetric == GraphMetric.airflow,
                    onTap: () => widget.onMetricChanged?.call(GraphMetric.airflow),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Statistics row
          Row(
            children: [
              _StatBadge(
                label: 'Мин',
                value: '${minValue.toStringAsFixed(1)}$_metricUnit',
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              _StatBadge(
                label: 'Макс',
                value: '${maxValue.toStringAsFixed(1)}$_metricUnit',
                color: AppColors.accentRed,
              ),
              const SizedBox(width: 8),
              _StatBadge(
                label: 'Сред',
                value: '${avgValue.toStringAsFixed(1)}$_metricUnit',
                color: AppColors.accentGreen,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Graph area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const yAxisWidth = 28.0;
                return Row(
                  children: [
                    // Y-axis labels
                    _buildYAxis(),

                    // Graph
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: MouseRegion(
                              onHover: (event) {
                                final index = _getIndexFromPosition(
                                  event.localPosition.dx,
                                  constraints.maxWidth - yAxisWidth,
                                );
                                setState(() => _hoveredIndex = index);
                              },
                              onExit: (_) => setState(() => _hoveredIndex = null),
                              child: CustomPaint(
                                size: Size(
                                  constraints.maxWidth - yAxisWidth,
                                  constraints.maxHeight - 30,
                                ),
                                painter: _GraphPainter(
                                  data: widget.data,
                                  color: AppColors.accent,
                                  hoveredIndex: _hoveredIndex,
                                  highlightIndex: widget.highlightIndex,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // X-axis labels
                          _buildXAxis(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int? _getIndexFromPosition(double dx, double width) {
    if (widget.data.isEmpty) return null;
    final stepWidth = width / (widget.data.length - 1);
    final index = (dx / stepWidth).round();
    if (index >= 0 && index < widget.data.length) {
      return index;
    }
    return null;
  }

  Widget _buildYAxis() {
    final colors = BreezColors.of(context);
    final maxValue = widget.data.isEmpty
        ? 30
        : widget.data.map((e) => e.value).reduce(math.max).ceil();
    final minValue = widget.data.isEmpty
        ? 0
        : widget.data.map((e) => e.value).reduce(math.min).floor();

    return SizedBox(
      width: 28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${maxValue + 2}',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: colors.textMuted.withValues(alpha: 0.6),
            ),
          ),
          Text(
            '${((maxValue + minValue) / 2).round()}',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: colors.textMuted.withValues(alpha: 0.6),
            ),
          ),
          Text(
            '${minValue - 2 < 0 ? 0 : minValue - 2}',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: colors.textMuted.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXAxis() {
    final colors = BreezColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.data.map((point) {
        return Text(
          point.label,
          style: TextStyle(
            fontSize: 10,
            color: colors.textMuted,
          ),
        );
      }).toList(),
    );
  }
}

/// Statistic badge
class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.indicator),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Metric selection tab
class _MetricTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _MetricTab({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      backgroundColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.15)
          : Colors.transparent,
      hoverColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.25)
          : colors.buttonBg,
      border: Border.all(
        color: isSelected ? AppColors.accent.withValues(alpha: 0.4) : colors.border,
        width: 1,
      ),
      shadows: isSelected
          ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? AppColors.accent : colors.textMuted,
          ),
          const SizedBox(height: 3),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: isSelected ? AppColors.accent : colors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the graph curve
class _GraphPainter extends CustomPainter {
  final List<GraphDataPoint> data;
  final Color color;
  final int? hoveredIndex;
  final int? highlightIndex;

  _GraphPainter({
    required this.data,
    required this.color,
    this.hoveredIndex,
    this.highlightIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.map((e) => e.value).reduce(math.max) + 4;
    final minValue = math.max(0, data.map((e) => e.value).reduce(math.min) - 4);
    final range = maxValue - minValue;

    final stepX = size.width / (data.length - 1);

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - ((data[i].value - minValue) / range * size.height);
      points.add(Offset(x, y));
    }

    // Draw grid lines (horizontal)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw gradient fill
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        fillPath.lineTo(points[i].dx, points[i].dy);
      } else {
        final cp1 = Offset(
          points[i - 1].dx + stepX / 3,
          points[i - 1].dy,
        );
        final cp2 = Offset(
          points[i].dx - stepX / 3,
          points[i].dy,
        );
        fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withValues(alpha: 0.3),
        color.withValues(alpha: 0.0),
      ],
    );

    final fillPaint = Paint()
      ..shader = fillGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    canvas.drawPath(fillPath, fillPaint);

    // Draw curve
    final curvePath = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        curvePath.moveTo(points[i].dx, points[i].dy);
      } else {
        final cp1 = Offset(
          points[i - 1].dx + stepX / 3,
          points[i - 1].dy,
        );
        final cp2 = Offset(
          points[i].dx - stepX / 3,
          points[i].dy,
        );
        curvePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
      }
    }

    final curvePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(curvePath, curvePaint);

    // Draw highlight point
    final activeIndex = hoveredIndex ?? highlightIndex;
    if (activeIndex != null && activeIndex < points.length) {
      final point = points[activeIndex];

      // Vertical line
      final linePaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(point.dx, 0),
        Offset(point.dx, size.height),
        linePaint,
      );

      // Outer glow
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(point, 12, glowPaint);

      // Outer circle
      final outerPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, 8, outerPaint);

      // Inner circle
      final innerPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, 5, innerPaint);

      // Center dot
      final centerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, 2, centerPaint);

      // Value tooltip
      final value = data[activeIndex].value.round();
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$value°',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final tooltipRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(point.dx, point.dy - 28),
          width: textPainter.width + 16,
          height: 24,
        ),
        const Radius.circular(AppRadius.button),
      );

      final tooltipPaint = Paint()..color = color;
      canvas.drawRRect(tooltipRect, tooltipPaint);

      textPainter.paint(
        canvas,
        Offset(
          point.dx - textPainter.width / 2,
          point.dy - 28 - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) {
    return oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.data != data ||
        oldDelegate.highlightIndex != highlightIndex;
  }
}
