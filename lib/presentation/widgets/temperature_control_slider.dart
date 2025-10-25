/// Temperature Control Slider
///
/// Circular slider for temperature control (inspired by reference)
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';
import '../../core/theme/app_theme.dart';

class TemperatureControlSlider extends StatefulWidget {
  final double currentTemp;
  final double targetTemp;
  final ValueChanged<double> onChanged;
  final bool enabled;

  const TemperatureControlSlider({
    super.key,
    required this.currentTemp,
    required this.targetTemp,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<TemperatureControlSlider> createState() =>
      _TemperatureControlSliderState();
}

class _TemperatureControlSliderState extends State<TemperatureControlSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.targetTemp;
  }

  @override
  void didUpdateWidget(TemperatureControlSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetTemp != oldWidget.targetTemp) {
      _currentValue = widget.targetTemp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Temperature Control',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 280,
              height: 280,
              child: CustomPaint(
                painter: _CircularSliderPainter(
                  value: _currentValue,
                  currentTemp: widget.currentTemp,
                  minValue: AppConstants.minTemperature,
                  maxValue: AppConstants.maxTemperature,
                  enabled: widget.enabled,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Target',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentValue.toStringAsFixed(0),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 56,
                                  color: widget.enabled
                                      ? AppTheme.primaryColor
                                      : AppTheme.textSecondary,
                                ),
                          ),
                          Text(
                            '°C',
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: widget.enabled
                                          ? AppTheme.primaryColor
                                          : AppTheme.textSecondary,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Current: ${widget.currentTemp.toStringAsFixed(1)}°C',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Slider(
              value: _currentValue,
              min: AppConstants.minTemperature,
              max: AppConstants.maxTemperature,
              divisions: ((AppConstants.maxTemperature -
                          AppConstants.minTemperature) *
                      2)
                  .toInt(),
              label: '${_currentValue.toStringAsFixed(1)}°C',
              onChanged: widget.enabled
                  ? (value) {
                      setState(() {
                        _currentValue = value;
                      });
                    }
                  : null,
              onChangeEnd: widget.enabled
                  ? (value) {
                      widget.onChanged(value);
                    }
                  : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppConstants.minTemperature.toInt()}°C',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${AppConstants.maxTemperature.toInt()}°C',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularSliderPainter extends CustomPainter {
  final double value;
  final double currentTemp;
  final double minValue;
  final double maxValue;
  final bool enabled;

  _CircularSliderPainter({
    required this.value,
    required this.currentTemp,
    required this.minValue,
    required this.maxValue,
    required this.enabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;

    // Background circle
    final bgPaint = Paint()
      ..color = enabled
          ? AppTheme.textHint.withOpacity(0.2)
          : AppTheme.textHint.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progress = (value - minValue) / (maxValue - minValue);
    final sweepAngle = 2 * math.pi * progress;

    final progressPaint = Paint()
      ..color = enabled ? AppTheme.primaryColor : AppTheme.textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Current temperature indicator
    if (enabled) {
      final currentProgress = (currentTemp - minValue) / (maxValue - minValue);
      final currentAngle = -math.pi / 2 + 2 * math.pi * currentProgress;
      final indicatorX = center.dx + radius * math.cos(currentAngle);
      final indicatorY = center.dy + radius * math.sin(currentAngle);

      final indicatorPaint = Paint()
        ..color = AppTheme.heatColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(indicatorX, indicatorY),
        8,
        indicatorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircularSliderPainter oldDelegate) {
    return value != oldDelegate.value ||
        currentTemp != oldDelegate.currentTemp ||
        enabled != oldDelegate.enabled;
  }
}
