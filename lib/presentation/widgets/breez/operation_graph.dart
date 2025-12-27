/// Operation Graph Widget - Shows unit operation history
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with metric switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Обзор',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
              ),
              // Metric tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.buttonBg,
                  borderRadius: BorderRadius.circular(AppColors.buttonRadius),
                ),
                child: Row(
                  children: [
                    _MetricTab(
                      label: 'Температура',
                      isSelected: widget.selectedMetric == GraphMetric.temperature,
                      onTap: () => widget.onMetricChanged?.call(GraphMetric.temperature),
                    ),
                    _MetricTab(
                      label: 'Влажность',
                      isSelected: widget.selectedMetric == GraphMetric.humidity,
                      onTap: () => widget.onMetricChanged?.call(GraphMetric.humidity),
                    ),
                    _MetricTab(
                      label: 'Поток',
                      isSelected: widget.selectedMetric == GraphMetric.airflow,
                      onTap: () => widget.onMetricChanged?.call(GraphMetric.airflow),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Graph area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    // Y-axis labels
                    SizedBox(
                      width: 40,
                      child: _buildYAxis(),
                    ),

                    // Graph
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: MouseRegion(
                              onHover: (event) {
                                final index = _getIndexFromPosition(
                                  event.localPosition.dx,
                                  constraints.maxWidth - 40,
                                );
                                setState(() => _hoveredIndex = index);
                              },
                              onExit: (_) => setState(() => _hoveredIndex = null),
                              child: CustomPaint(
                                size: Size(constraints.maxWidth - 40, constraints.maxHeight - 30),
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${maxValue + 2}',
          style: TextStyle(fontSize: 9, color: colors.textMuted),
        ),
        Text(
          '${((maxValue + minValue) / 2).round()}',
          style: TextStyle(fontSize: 9, color: colors.textMuted),
        ),
        Text(
          '${minValue - 2 < 0 ? 0 : minValue - 2}',
          style: TextStyle(fontSize: 9, color: colors.textMuted),
        ),
      ],
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

/// Metric selection tab
class _MetricTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _MetricTab({
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? colors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(AppColors.buttonRadius),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? colors.text : colors.textMuted,
            ),
          ),
        ),
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

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (int i = 0; i < 4; i++) {
      final y = size.height * i / 3;
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
        Radius.circular(AppColors.buttonRadius),
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
