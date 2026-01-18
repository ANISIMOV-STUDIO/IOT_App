/// Operation Graph Painter - CustomPainter for graph curve rendering
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_radius.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';

/// Custom painter for the graph curve with smooth bezier interpolation
class OperationGraphPainter extends CustomPainter {

  OperationGraphPainter({
    required this.data,
    required this.color,
    this.hoveredIndex,
    this.highlightIndex,
  });
  final List<GraphDataPoint> data;
  final Color color;
  final int? hoveredIndex;
  final int? highlightIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      return;
    }

    final points = _calculatePoints(size);
    final stepX = size.width / (data.length - 1);

    _drawGridLines(canvas, size);
    _drawGradientFill(canvas, size, points, stepX);
    _drawCurve(canvas, points, stepX);
    _drawHighlightPoint(canvas, size, points);
  }

  List<Offset> _calculatePoints(Size size) {
    final maxValue = data.map((e) => e.value).reduce(math.max) + 4;
    final minValue = math.max(0, data.map((e) => e.value).reduce(math.min) - 4);
    final range = maxValue - minValue;
    final stepX = size.width / (data.length - 1);

    final points = <Offset>[];
    for (var i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - ((data[i].value - minValue) / range * size.height);
      points.add(Offset(x, y));
    }
    return points;
  }

  void _drawGridLines(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawGradientFill(Canvas canvas, Size size, List<Offset> points, double stepX) {
    final fillPath = Path()
    ..moveTo(0, size.height);

    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        fillPath.lineTo(points[i].dx, points[i].dy);
      } else {
        final cp1 = Offset(points[i - 1].dx + stepX / 3, points[i - 1].dy);
        final cp2 = Offset(points[i].dx - stepX / 3, points[i].dy);
        fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
      }
    }
    fillPath..lineTo(size.width, size.height)
    ..close();

    final fillGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withValues(alpha: 0.3),
        color.withValues(alpha: 0),
      ],
    );

    final fillPaint = Paint()
      ..shader = fillGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    canvas.drawPath(fillPath, fillPaint);
  }

  void _drawCurve(Canvas canvas, List<Offset> points, double stepX) {
    final curvePath = Path();
    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        curvePath.moveTo(points[i].dx, points[i].dy);
      } else {
        final cp1 = Offset(points[i - 1].dx + stepX / 3, points[i - 1].dy);
        final cp2 = Offset(points[i].dx - stepX / 3, points[i].dy);
        curvePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
      }
    }

    final curvePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(curvePath, curvePaint);
  }

  void _drawHighlightPoint(Canvas canvas, Size size, List<Offset> points) {
    final activeIndex = hoveredIndex ?? highlightIndex;
    if (activeIndex == null || activeIndex >= points.length) {
      return;
    }

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
      ..color = AppColors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, 2, centerPaint);

    // Value tooltip
    _drawTooltip(canvas, point, activeIndex);
  }

  void _drawTooltip(Canvas canvas, Offset point, int index) {
    final value = data[index].value.round();
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$value°',
        style: const TextStyle(
          fontSize: AppFontSizes.caption,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
    ..layout();

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

  @override
  bool shouldRepaint(covariant OperationGraphPainter oldDelegate) => oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.data != data ||
        oldDelegate.highlightIndex != highlightIndex;
}
