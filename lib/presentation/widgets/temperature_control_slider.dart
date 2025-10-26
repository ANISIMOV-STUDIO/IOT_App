/// Temperature Control Slider
///
/// Circular slider for temperature control with modern design
library;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../generated/l10n/app_localizations.dart';

class TemperatureControlSlider extends StatefulWidget {
  final double targetTemp;
  final double currentTemp;
  final ValueChanged<double> onChanged;
  final bool enabled;
  final String mode;

  const TemperatureControlSlider({
    super.key,
    required this.targetTemp,
    required this.currentTemp,
    required this.onChanged,
    this.enabled = true,
    this.mode = 'auto',
  });

  @override
  State<TemperatureControlSlider> createState() =>
      _TemperatureControlSliderState();
}

class _TemperatureControlSliderState extends State<TemperatureControlSlider>
    with SingleTickerProviderStateMixin {
  late double _currentValue;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Angle constants - 270° arc from bottom-left to bottom-right
  static const double _totalSweep = 270.0; // total degrees of sweep

  @override
  void initState() {
    super.initState();
    _currentValue = widget.targetTemp;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TemperatureControlSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetTemp != oldWidget.targetTemp) {
      _currentValue = widget.targetTemp;
    }

    // Pause/resume animation based on enabled state
    if (!widget.enabled && oldWidget.enabled) {
      _pulseController.stop();
    } else if (widget.enabled && !oldWidget.enabled) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Convert touch position to temperature value
  double _getTempFromPosition(Offset center, Offset position) {
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;

    // Get angle in radians from atan2 (-π to π)
    double angle = math.atan2(dy, dx);

    // Convert to degrees and normalize to 0-360
    double degrees = angle * 180 / math.pi;
    if (degrees < 0) degrees += 360;

    // Our arc goes from 135° to 45° (405°)
    // Map the angle to progress along the arc
    double progress;

    if (degrees >= 135 && degrees <= 360) {
      // From 135° to 360° (first part of arc)
      progress = (degrees - 135) / _totalSweep;
    } else if (degrees >= 0 && degrees <= 45) {
      // From 0° to 45° (second part of arc, continuing from 360°)
      progress = (degrees + 360 - 135) / _totalSweep;
    } else {
      // Outside arc range (45° to 135°) - snap to nearest endpoint
      if (degrees > 45 && degrees < 90) {
        progress = 1.0; // Snap to max
      } else {
        progress = 0.0; // Snap to min
      }
    }

    // Clamp progress to valid range
    progress = progress.clamp(0.0, 1.0);

    // Map progress to temperature
    return AppConstants.minTemperature +
        (AppConstants.maxTemperature - AppConstants.minTemperature) * progress;
  }

  void _handlePanUpdate(Offset localPosition, Size size) {
    if (!widget.enabled) return;

    final center = Offset(size.width / 2, size.height / 2);
    final newValue = _getTempFromPosition(center, localPosition);

    setState(() {
      _currentValue = newValue;
    });
  }

  void _handlePanEnd() {
    if (!widget.enabled) return;
    widget.onChanged(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final modeColor = AppTheme.getModeColor(widget.mode);
    final modeGradient = AppTheme.getModeGradient(widget.mode, isDark: isDark);

    return Container(
      decoration: AppTheme.glassmorphicCard(
        isDark: isDark,
        borderRadius: 24,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.temperature,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.enabled ? l10n.adjustTargetTemperature : l10n.deviceIsOff,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppTheme.darkTextHint
                              : AppTheme.lightTextHint,
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Circular Slider - wrapped in Listener to prevent scroll
          Listener(
            onPointerSignal: (event) {
              // Prevent scroll when pointer is over slider
              if (event is PointerScrollEvent && widget.enabled) {
                // Block the scroll event
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulse animation
                if (widget.enabled)
                  AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              modeColor.withValues(alpha: 0.1),
                              modeColor.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

              // Gesture detector with custom paint - prevents scroll when dragging
              RawGestureDetector(
                gestures: <Type, GestureRecognizerFactory>{
                  PanGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
                    () => PanGestureRecognizer(),
                    (PanGestureRecognizer instance) {
                      instance
                        ..onUpdate = (details) {
                          _handlePanUpdate(details.localPosition, const Size(250, 250));
                        }
                        ..onEnd = (_) => _handlePanEnd();
                    },
                  ),
                  TapGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                    () => TapGestureRecognizer(),
                    (TapGestureRecognizer instance) {
                      instance
                        ..onTapUp = (details) {
                          _handlePanUpdate(details.localPosition, const Size(250, 250));
                          _handlePanEnd();
                        };
                    },
                  ),
                },
                behavior: HitTestBehavior.opaque,
                child: RepaintBoundary(
                  child: CustomPaint(
                    size: const Size(250, 250),
                    painter: _CircularSliderPainter(
                      value: _currentValue,
                      minValue: AppConstants.minTemperature,
                      maxValue: AppConstants.maxTemperature,
                      gradient: widget.enabled ? modeGradient : null,
                      trackColor: isDark
                          ? AppTheme.darkBorder.withValues(alpha: 0.3)
                          : AppTheme.lightBorder.withValues(alpha: 0.5),
                      isDark: isDark,
                    ),
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Target label
                            Text(
                              l10n.target,
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: isDark
                                            ? AppTheme.darkTextHint
                                            : AppTheme.lightTextHint,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                            ),
                            const SizedBox(height: 8),
                            // Temperature value
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => widget.enabled
                                      ? modeGradient.createShader(bounds)
                                      : LinearGradient(
                                          colors: [
                                            isDark
                                                ? AppTheme.darkTextSecondary
                                                : AppTheme.lightTextSecondary,
                                            isDark
                                                ? AppTheme.darkTextSecondary
                                                : AppTheme.lightTextSecondary,
                                          ],
                                        ).createShader(bounds),
                                  child: Text(
                                    _currentValue.toStringAsFixed(1),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                          color: Colors.white,
                                          letterSpacing: -2,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => widget.enabled
                                        ? modeGradient.createShader(bounds)
                                        : LinearGradient(
                                            colors: [
                                              isDark
                                                  ? AppTheme.darkTextSecondary
                                                  : AppTheme.lightTextSecondary,
                                              isDark
                                                  ? AppTheme.darkTextSecondary
                                                  : AppTheme.lightTextSecondary,
                                            ],
                                          ).createShader(bounds),
                                    child: Text(
                                      '°C',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Current temperature
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.darkSurface.withValues(alpha: 0.5)
                                    : AppTheme.lightSurface.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDark
                                      ? AppTheme.darkBorder.withValues(alpha: 0.3)
                                      : AppTheme.lightBorder.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.thermostat,
                                    size: 16,
                                    color: widget.enabled
                                        ? modeColor
                                        : (isDark
                                            ? AppTheme.darkTextSecondary
                                            : AppTheme.lightTextSecondary),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${widget.currentTemp.toStringAsFixed(1)}°C',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: widget.enabled
                                                  ? modeColor
                                                  : (isDark
                                                      ? AppTheme.darkTextSecondary
                                                      : AppTheme.lightTextSecondary),
                                            ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ),

          const SizedBox(height: 20),

          // Temperature range indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRangeIndicator(
                context,
                l10n.min,
                AppConstants.minTemperature,
                Icons.ac_unit,
                isDark,
              ),
              _buildRangeIndicator(
                context,
                l10n.max,
                AppConstants.maxTemperature,
                Icons.local_fire_department,
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangeIndicator(
    BuildContext context,
    String label,
    double value,
    IconData icon,
    bool isDark,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? AppTheme.darkTextHint : AppTheme.lightTextHint,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? AppTheme.darkTextHint : AppTheme.lightTextHint,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${value.toInt()}°C',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _CircularSliderPainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final LinearGradient? gradient;
  final Color trackColor;
  final bool isDark;

  _CircularSliderPainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    this.gradient,
    required this.trackColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;
    const startAngle = 135.0 * math.pi / 180.0; // 135° in radians
    const sweepAngle = 270.0 * math.pi / 180.0; // 270° sweep

    // Draw track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Draw progress
    if (gradient != null) {
      final progress = (value - minValue) / (maxValue - minValue);
      final progressAngle = sweepAngle * progress;

      final progressPaint = Paint()
        ..shader = gradient!.createShader(
          Rect.fromCircle(center: center, radius: radius),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        progressAngle,
        false,
        progressPaint,
      );

      // Draw thumb
      final thumbAngle = startAngle + progressAngle;
      final thumbX = center.dx + radius * math.cos(thumbAngle);
      final thumbY = center.dy + radius * math.sin(thumbAngle);

      // Shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(thumbX, thumbY + 2), 16, shadowPaint);

      // Main thumb circle
      final thumbPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(thumbX, thumbY), 16, thumbPaint);

      // Colored border
      final thumbBorderPaint = Paint()
        ..shader = gradient!.createShader(
          Rect.fromCircle(center: Offset(thumbX, thumbY), radius: 16),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      canvas.drawCircle(Offset(thumbX, thumbY), 14, thumbBorderPaint);
    }
  }

  @override
  bool shouldRepaint(_CircularSliderPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.gradient != gradient ||
        oldDelegate.trackColor != trackColor;
  }
}
