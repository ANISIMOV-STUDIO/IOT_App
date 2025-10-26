/// Temperature Control Slider
///
/// Modern circular slider with gradient
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';

class TemperatureControlSlider extends StatefulWidget {
  final double currentTemp;
  final double targetTemp;
  final ValueChanged<double> onChanged;
  final bool enabled;
  final String mode;

  const TemperatureControlSlider({
    super.key,
    required this.currentTemp,
    required this.targetTemp,
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

  @override
  void initState() {
    super.initState();
    _currentValue = widget.targetTemp;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final modeColor = AppTheme.getModeColor(widget.mode);
    final modeGradient = AppTheme.getModeGradient(widget.mode, isDark: isDark);

    return Container(
      decoration: AppTheme.glassmorphicCard(
        isDark: isDark,
        borderRadius: 24,
      ),
      padding: const EdgeInsets.all(32),
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
              if (widget.enabled)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: modeGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: modeColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppTheme.getModeIcon(widget.mode),
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.mode.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 40),

          // Circular Slider
          Stack(
            alignment: Alignment.center,
            children: [
              // Animated pulse effect
              if (widget.enabled)
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              modeColor.withOpacity(0.1),
                              modeColor.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

              // Custom Circular Slider
              GestureDetector(
                onPanUpdate: widget.enabled
                    ? (details) {
                        final RenderBox box = context.findRenderObject() as RenderBox;
                        final center = Offset(box.size.width / 2, 280 / 2);
                        final position = details.localPosition - center;
                        final angle = math.atan2(position.dy, position.dx);

                        // Convert angle to temperature (135° to 405° range)
                        double normalizedAngle = angle + math.pi / 2;
                        if (normalizedAngle < 0) normalizedAngle += 2 * math.pi;

                        // Map to 270° range starting at 135°
                        const startAngle = 3 * math.pi / 4;
                        const endAngle = startAngle + 3 * math.pi / 2;

                        if (normalizedAngle >= startAngle || normalizedAngle <= endAngle - 2 * math.pi) {
                          double tempAngle = normalizedAngle;
                          if (tempAngle < startAngle) tempAngle += 2 * math.pi;

                          final progress = (tempAngle - startAngle) / (3 * math.pi / 2);
                          final newTemp = AppConstants.minTemperature +
                              (AppConstants.maxTemperature - AppConstants.minTemperature) * progress;

                          setState(() {
                            _currentValue = newTemp.clamp(
                              AppConstants.minTemperature,
                              AppConstants.maxTemperature,
                            );
                          });
                        }
                      }
                    : null,
                onPanEnd: widget.enabled
                    ? (_) => widget.onChanged(_currentValue)
                    : null,
                child: CustomPaint(
                  size: const Size(280, 280),
                  painter: _CircularSliderPainter(
                    value: _currentValue,
                    minValue: AppConstants.minTemperature,
                    maxValue: AppConstants.maxTemperature,
                    gradient: widget.enabled ? modeGradient : null,
                    trackColor: isDark
                        ? AppTheme.darkBorder.withOpacity(0.3)
                        : AppTheme.lightBorder.withOpacity(0.5),
                    isDark: isDark,
                  ),
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Target Temperature
                          Text(
                            l10n.target,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppTheme.darkTextHint
                                      : AppTheme.lightTextHint,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    widget.enabled
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
                                        fontSize: 64,
                                        color: Colors.white,
                                        height: 1,
                                        letterSpacing: -2,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      widget.enabled
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

                          // Current Temperature
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppTheme.darkSurface.withOpacity(0.5)
                                  : AppTheme.lightSurface.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: widget.enabled
                                    ? modeColor.withOpacity(0.3)
                                    : (isDark
                                            ? AppTheme.darkBorder
                                            : AppTheme.lightBorder)
                                        .withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.thermostat_rounded,
                                  size: 18,
                                  color: widget.enabled
                                      ? modeColor
                                      : (isDark
                                          ? AppTheme.darkTextHint
                                          : AppTheme.lightTextHint),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.current('${widget.currentTemp.toStringAsFixed(1)}°C'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
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
            ],
          ),

          const SizedBox(height: 32),

          // Temperature Range Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRangeIndicator(
                context,
                l10n.min,
                AppConstants.minTemperature,
                Icons.ac_unit_rounded,
                isDark,
              ),
              Container(
                width: 1,
                height: 40,
                color: (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                    .withOpacity(0.3),
              ),
              _buildRangeIndicator(
                context,
                l10n.max,
                AppConstants.maxTemperature,
                Icons.local_fire_department_rounded,
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
    const startAngle = -math.pi * 3 / 4;
    const sweepAngle = math.pi * 3 / 2;

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

      final thumbPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(thumbX, thumbY), 8, thumbPaint);

      final thumbBorderPaint = Paint()
        ..shader = gradient!.createShader(
          Rect.fromCircle(center: Offset(thumbX, thumbY), radius: 8),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawCircle(Offset(thumbX, thumbY), 8, thumbBorderPaint);
    }
  }

  @override
  bool shouldRepaint(_CircularSliderPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.gradient != gradient ||
        oldDelegate.trackColor != trackColor;
  }
}
