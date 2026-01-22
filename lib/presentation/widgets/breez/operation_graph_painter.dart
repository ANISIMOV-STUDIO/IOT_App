/// Operation Graph Painter - CustomPainter for graph curve rendering
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Painter constants for graph rendering
abstract class _PainterConstants {
  static const double lineWidth = 1.5;
  static const double gridLineWidth = 0.5;
  static const double gridOpacity = AppColors.opacityVerySubtle;
  static const double highlightOuterRadius = 6;
  static const double highlightInnerRadius = 4;
  static const double highlightCenterRadius = 2;
  static const double tooltipHeight = 22;
  static const double tooltipPaddingH = AppSpacing.xs;
}

// =============================================================================
// PAINTER
// =============================================================================

/// Custom painter for the graph curve with smooth bezier interpolation
///
/// Supports both single-line (legacy) and multi-line modes.
class OperationGraphPainter extends CustomPainter {

  OperationGraphPainter({
    required this.data,
    required this.color,
    this.hoveredIndex,
    this.highlightIndex,
    this.drawProgress = 1.0,
    this.multiSeries,
  });

  /// Single series data (legacy API)
  final List<GraphDataPoint> data;

  /// Primary color for single series
  final Color color;

  /// Hovered point index
  final int? hoveredIndex;

  /// Highlighted point index
  final int? highlightIndex;

  /// Draw animation progress (0.0 - 1.0)
  final double drawProgress;

  /// Multiple series for multi-line mode
  final List<GraphSeries>? multiSeries;

  /// Check if using multi-series mode
  bool get _isMultiSeries => multiSeries != null && multiSeries!.isNotEmpty;

  /// Get all data points for range calculation (from all visible series)
  List<GraphDataPoint> get _allDataPoints {
    if (_isMultiSeries) {
      return multiSeries!
          .where((s) => s.isVisible)
          .expand((s) => s.data)
          .toList();
    }
    return data;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final allPoints = _allDataPoints;
    if (allPoints.isEmpty) {
      return;
    }

    _drawGridLines(canvas, size);

    if (_isMultiSeries) {
      // Draw each visible series
      for (final series in multiSeries!) {
        if (series.isVisible && series.data.isNotEmpty) {
          final points = _calculatePointsForData(size, series.data);
          final stepX = size.width / (series.data.length - 1);
          _drawCurveWithColor(canvas, points, stepX, series.color);
        }
      }
      // Draw highlight for first visible series with data
      final firstVisible = multiSeries!.where((s) => s.isVisible && s.data.isNotEmpty).firstOrNull;
      if (firstVisible != null) {
        final points = _calculatePointsForData(size, firstVisible.data);
        _drawHighlightPointWithColor(canvas, size, points, firstVisible.color, firstVisible.data);
      }
    } else {
      // Legacy single series mode
      final points = _calculatePoints(size);
      final stepX = size.width / (data.length - 1);
      _drawCurve(canvas, points, stepX);
      _drawHighlightPoint(canvas, size, points);
    }
  }

  List<Offset> _calculatePoints(Size size) => _calculatePointsForData(size, data);

  List<Offset> _calculatePointsForData(Size size, List<GraphDataPoint> seriesData) {
    final allPoints = _allDataPoints;
    final maxValue = allPoints.map((e) => e.value).reduce(math.max) + 4;
    final minValue = math.max(0, allPoints.map((e) => e.value).reduce(math.min) - 4);
    final range = maxValue - minValue;
    final stepX = size.width / (seriesData.length - 1);

    final points = <Offset>[];
    for (var i = 0; i < seriesData.length; i++) {
      final x = i * stepX;
      final y = size.height - ((seriesData[i].value - minValue) / range * size.height);
      points.add(Offset(x, y));
    }
    return points;
  }

  void _drawGridLines(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.white.withValues(alpha: _PainterConstants.gridOpacity)
      ..strokeWidth = _PainterConstants.gridLineWidth
      ..style = PaintingStyle.stroke;

    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawCurve(Canvas canvas, List<Offset> points, double stepX) {
    _drawCurveWithColor(canvas, points, stepX, color);
  }

  void _drawCurveWithColor(Canvas canvas, List<Offset> points, double stepX, Color lineColor) {
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
      ..color = lineColor
      ..strokeWidth = _PainterConstants.lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Apply draw animation progress
    if (drawProgress < 1.0) {
      final pathMetrics = curvePath.computeMetrics().first;
      final extractPath = pathMetrics.extractPath(
        0,
        pathMetrics.length * drawProgress,
      );
      canvas.drawPath(extractPath, curvePaint);
    } else {
      canvas.drawPath(curvePath, curvePaint);
    }
  }

  void _drawHighlightPoint(Canvas canvas, Size size, List<Offset> points) =>
      _drawHighlightPointWithColor(canvas, size, points, color, data);

  void _drawHighlightPointWithColor(
    Canvas canvas,
    Size size,
    List<Offset> points,
    Color highlightColor,
    List<GraphDataPoint> seriesData,
  ) {
    final activeIndex = hoveredIndex ?? highlightIndex;
    if (activeIndex == null || activeIndex >= points.length) {
      return;
    }

    final point = points[activeIndex];

    // Vertical line - minimalist dashed style
    final linePaint = Paint()
      ..color = highlightColor.withValues(alpha: AppColors.opacitySubtle)
      ..strokeWidth = _PainterConstants.gridLineWidth;
    canvas.drawLine(
      Offset(point.dx, 0),
      Offset(point.dx, size.height),
      linePaint,
    );

    // Outer circle - simple border
    final outerPaint = Paint()
      ..color = highlightColor.withValues(alpha: AppColors.opacityLow)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, _PainterConstants.highlightOuterRadius, outerPaint);

    // Inner circle - solid color
    final innerPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, _PainterConstants.highlightInnerRadius, innerPaint);

    // Center dot - white accent
    final centerPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, _PainterConstants.highlightCenterRadius, centerPaint);

    // Value tooltip - draw tooltip using series color and data
    _drawTooltipWithColor(canvas, size, point, activeIndex, highlightColor, seriesData);
  }

  void _drawTooltipWithColor(
    Canvas canvas,
    Size size,
    Offset point,
    int index,
    Color tooltipColor,
    List<GraphDataPoint> seriesData,
  ) {
    final value = seriesData[index].value.round();
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
    )..layout();

    final tooltipWidth = textPainter.width + _PainterConstants.tooltipPaddingH * 2;
    const tooltipOffset = _PainterConstants.tooltipHeight + AppSpacing.xxs;

    // Check if tooltip would go beyond top edge — if so, draw below the point
    final drawAbove = point.dy - tooltipOffset - _PainterConstants.tooltipHeight / 2 > 0;
    final tooltipCenterY = drawAbove
        ? point.dy - tooltipOffset
        : point.dy + tooltipOffset;

    // Clamp horizontal position to stay within bounds
    final halfWidth = tooltipWidth / 2;
    final clampedX = point.dx.clamp(halfWidth, size.width - halfWidth);

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(clampedX, tooltipCenterY),
        width: tooltipWidth,
        height: _PainterConstants.tooltipHeight,
      ),
      const Radius.circular(AppRadius.chip),
    );

    final tooltipPaint = Paint()..color = tooltipColor;
    canvas.drawRRect(tooltipRect, tooltipPaint);

    textPainter.paint(
      canvas,
      Offset(
        clampedX - textPainter.width / 2,
        tooltipCenterY - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant OperationGraphPainter oldDelegate) =>
      oldDelegate.hoveredIndex != hoveredIndex ||
      oldDelegate.data != data ||
      oldDelegate.highlightIndex != highlightIndex ||
      oldDelegate.drawProgress != drawProgress ||
      oldDelegate.multiSeries != multiSeries;
}
