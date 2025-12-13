import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as np;
import '../../theme/tokens/neumorphic_colors.dart';

/// Temperature mode enum
enum TemperatureMode { heating, cooling, auto, dry }

/// Neumorphic Temperature Dial - fully custom circular slider
class NeumorphicTemperatureDial extends StatefulWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final TemperatureMode mode;
  final String? label;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  const NeumorphicTemperatureDial({
    super.key,
    required this.value,
    this.minValue = 10,
    this.maxValue = 30,
    this.mode = TemperatureMode.auto,
    this.label,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  State<NeumorphicTemperatureDial> createState() => _NeumorphicTemperatureDialState();
}

class _NeumorphicTemperatureDialState extends State<NeumorphicTemperatureDial>
    with SingleTickerProviderStateMixin {
  late double _currentValue;
  bool _isDragging = false;
  late AnimationController _glowController;

  // Arc configuration (matches linear slider: height = 20)
  static const double _startAngle = 135.0;
  static const double _sweepAngle = 270.0;
  static const double _trackWidth = 20.0; // Same as linear slider height

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(NeumorphicTemperatureDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging && widget.value != oldWidget.value) {
      _currentValue = widget.value;
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  // Colors based on mode
  Color get _primaryColor => switch (widget.mode) {
    TemperatureMode.heating => NeumorphicColors.modeHeating,
    TemperatureMode.cooling => NeumorphicColors.modeCooling,
    TemperatureMode.auto => NeumorphicColors.modeAuto,
    TemperatureMode.dry => NeumorphicColors.modeDry,
  };

  List<Color> get _gradientColors => switch (widget.mode) {
    TemperatureMode.heating => [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
    TemperatureMode.cooling => [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
    TemperatureMode.auto => [NeumorphicColors.accentPrimary, const Color(0xFF667EEA)],
    TemperatureMode.dry => [const Color(0xFFFECE00), const Color(0xFFFF9500)],
  };

  double get _progress =>
      ((_currentValue - widget.minValue) / (widget.maxValue - widget.minValue)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Track groove (concave ring) - same style as linear slider
              Positioned.fill(
                child: CustomPaint(
                  painter: _TrackPainter(trackWidth: _trackWidth),
                ),
              ),

              // Progress arc with gradient
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _ArcPainter(
                        progress: _progress,
                        trackWidth: _trackWidth,
                        gradientColors: _gradientColors,
                        glowIntensity: _isDragging ? 0.5 : 0.25 + (_glowController.value * 0.1),
                      ),
                    );
                  },
                ),
              ),

              // Inner neumorphic circle (convex) - center display
              np.Neumorphic(
                style: const np.NeumorphicStyle(
                  depth: 3,
                  intensity: 0.5,
                  boxShape: np.NeumorphicBoxShape.circle(),
                ),
                child: SizedBox(
                  width: size * 0.6,
                  height: size * 0.6,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_currentValue.round()}°',
                          style: TextStyle(
                            fontSize: size * 0.2,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                            height: 1,
                          ),
                        ),
                        if (widget.label != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              widget.label!,
                              style: TextStyle(
                                fontSize: size * 0.07,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Draggable thumb
              Positioned.fill(
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: CustomPaint(
                    painter: _ThumbPainter(
                      progress: _progress,
                      trackWidth: _trackWidth,
                      color: _primaryColor,
                      isPressed: _isDragging,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() => _isDragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final center = Offset(box.size.width / 2, box.size.height / 2);
    final position = details.localPosition;

    // Calculate angle from center
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    var angle = math.atan2(dy, dx) * 180 / math.pi;

    // Convert to our arc coordinate system (135° start, 270° sweep)
    angle = (angle + 360) % 360;

    // Map angle to progress (135° = 0%, 45° = 100%)
    double progress;
    if (angle >= _startAngle) {
      progress = (angle - _startAngle) / _sweepAngle;
    } else {
      progress = (angle + 360 - _startAngle) / _sweepAngle;
    }

    progress = progress.clamp(0.0, 1.0);

    final newValue = widget.minValue + progress * (widget.maxValue - widget.minValue);

    // Round to 0.5 increments
    final roundedValue = (newValue * 2).round() / 2;

    if (roundedValue != _currentValue) {
      setState(() => _currentValue = roundedValue.clamp(widget.minValue, widget.maxValue));
      widget.onChanged?.call(_currentValue);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() => _isDragging = false);
    widget.onChangeEnd?.call(_currentValue);
  }
}

/// Track groove painter (neumorphic concave ring)
class _TrackPainter extends CustomPainter {
  final double trackWidth;

  _TrackPainter({required this.trackWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - trackWidth) / 2 - 6;

    const startAngle = 135 * math.pi / 180;
    const sweepAngle = 270 * math.pi / 180;

    // Outer shadow (dark, bottom-right)
    final outerShadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.black.withValues(alpha: 0.08);
    canvas.drawArc(
      Rect.fromCircle(center: center + const Offset(1, 1), radius: radius),
      startAngle,
      sweepAngle,
      false,
      outerShadowPaint,
    );

    // Inner highlight (light, top-left)
    final innerHighlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.7);
    canvas.drawArc(
      Rect.fromCircle(center: center + const Offset(-1, -1), radius: radius),
      startAngle,
      sweepAngle,
      false,
      innerHighlightPaint,
    );

    // Main groove
    final groovePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE0E5EC);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      groovePaint,
    );
  }

  @override
  bool shouldRepaint(_TrackPainter oldDelegate) => false;
}

/// Arc progress painter
class _ArcPainter extends CustomPainter {
  final double progress;
  final double trackWidth;
  final List<Color> gradientColors;
  final double glowIntensity;

  _ArcPainter({
    required this.progress,
    required this.trackWidth,
    required this.gradientColors,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - trackWidth) / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const startAngle = 135 * math.pi / 180;
    final sweepAngle = 270 * math.pi / 180 * progress;

    if (progress > 0) {
      // Subtle glow
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth + 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [
            gradientColors[0].withValues(alpha: glowIntensity),
            gradientColors[1].withValues(alpha: glowIntensity),
          ],
        ).createShader(rect);
      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);

      // Main arc (3px padding each side, like linear slider)
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth - 6
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: gradientColors,
        ).createShader(rect);
      canvas.drawArc(rect, startAngle, sweepAngle, false, arcPaint);
    }
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      glowIntensity != oldDelegate.glowIntensity;
}

/// Thumb painter (matches linear slider thumb style)
class _ThumbPainter extends CustomPainter {
  final double progress;
  final double trackWidth;
  final Color color;
  final bool isPressed;

  _ThumbPainter({
    required this.progress,
    required this.trackWidth,
    required this.color,
    required this.isPressed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - trackWidth) / 2 - 6;

    const startAngle = 135 * math.pi / 180;
    final angle = startAngle + (270 * math.pi / 180 * progress);

    final thumbCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    // Same size as linear slider thumb (height + 8 = 28)
    final thumbRadius = isPressed ? 12.0 : 14.0;

    // Shadow
    canvas.drawCircle(
      thumbCenter + const Offset(0, 1.5),
      thumbRadius + 1,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // White background
    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      Paint()..color = Colors.white,
    );

    // Colored border
    canvas.drawCircle(
      thumbCenter,
      thumbRadius - 2,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Inner dot
    canvas.drawCircle(
      thumbCenter,
      5,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_ThumbPainter oldDelegate) =>
      progress != oldDelegate.progress || isPressed != oldDelegate.isPressed;
}
