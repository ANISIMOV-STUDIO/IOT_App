import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';

/// Temperature mode enum
enum TemperatureMode { heating, cooling, auto, dry }

/// Glass Temperature Dial - circular slider with glassmorphism
class GlassTemperatureDial extends StatefulWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final TemperatureMode mode;
  final String? label;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  const GlassTemperatureDial({
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
  State<GlassTemperatureDial> createState() => _GlassTemperatureDialState();
}

class _GlassTemperatureDialState extends State<GlassTemperatureDial>
    with SingleTickerProviderStateMixin {
  late double _currentValue;
  bool _isDragging = false;
  late AnimationController _glowController;

  static const double _startAngle = 135.0;
  static const double _sweepAngle = 270.0;
  static const double _trackWidth = 12.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(GlassTemperatureDial oldWidget) {
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

  Color get _primaryColor => switch (widget.mode) {
        TemperatureMode.heating => GlassColors.modeHeating,
        TemperatureMode.cooling => GlassColors.modeCooling,
        TemperatureMode.auto => GlassColors.modeAuto,
        TemperatureMode.dry => GlassColors.modeDry,
      };

  List<Color> get _gradientColors => switch (widget.mode) {
        TemperatureMode.heating => [
            const Color(0xFFFF6B6B),
            const Color(0xFFFF8E53)
          ],
        TemperatureMode.cooling => [
            const Color(0xFF38BDF8),
            const Color(0xFF0EA5E9)
          ],
        TemperatureMode.auto => [
            const Color(0xFF10B981),
            const Color(0xFF34D399)
          ],
        TemperatureMode.dry => [
            const Color(0xFFFBBF24),
            const Color(0xFFF59E0B)
          ],
      };

  double get _progress =>
      ((_currentValue - widget.minValue) / (widget.maxValue - widget.minValue))
          .clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Track background
              Positioned.fill(
                child: CustomPaint(
                  painter: _GlassTrackPainter(
                    trackWidth: _trackWidth,
                    isDark: theme.isDark,
                  ),
                ),
              ),

              // Progress arc with glow
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _GlassArcPainter(
                        progress: _progress,
                        trackWidth: _trackWidth,
                        gradientColors: _gradientColors,
                        glowIntensity:
                            _isDragging ? 0.6 : 0.3 + (_glowController.value * 0.15),
                      ),
                    );
                  },
                ),
              ),

              // Inner glass circle with value display
              ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: size * 0.58,
                    height: size * 0.58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: theme.isDark
                            ? [
                                const Color(0x33FFFFFF),
                                const Color(0x1AFFFFFF),
                              ]
                            : [
                                const Color(0xCCFFFFFF),
                                const Color(0x99FFFFFF),
                              ],
                      ),
                      border: Border.all(
                        color: theme.isDark
                            ? const Color(0x33FFFFFF)
                            : const Color(0x66FFFFFF),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_currentValue.round()}°',
                            style: TextStyle(
                              fontSize: size * 0.18,
                              fontWeight: FontWeight.w700,
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
                                  fontSize: size * 0.065,
                                  color: theme.colors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Draggable thumb
              Positioned.fill(
                child: MouseRegion(
                  cursor: _isDragging
                      ? SystemMouseCursors.grabbing
                      : SystemMouseCursors.grab,
                  child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      painter: _GlassThumbPainter(
                        progress: _progress,
                        trackWidth: _trackWidth,
                        color: _primaryColor,
                        isPressed: _isDragging,
                      ),
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

    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    var angle = math.atan2(dy, dx) * 180 / math.pi;

    angle = (angle + 360) % 360;

    double progress;
    if (angle >= _startAngle) {
      progress = (angle - _startAngle) / _sweepAngle;
    } else {
      progress = (angle + 360 - _startAngle) / _sweepAngle;
    }

    progress = progress.clamp(0.0, 1.0);

    final newValue =
        widget.minValue + progress * (widget.maxValue - widget.minValue);
    final roundedValue = (newValue * 2).round() / 2;

    if (roundedValue != _currentValue) {
      setState(() =>
          _currentValue = roundedValue.clamp(widget.minValue, widget.maxValue));
      widget.onChanged?.call(_currentValue);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() => _isDragging = false);
    widget.onChangeEnd?.call(_currentValue);
  }
}

// Backwards compatibility alias
typedef NeumorphicTemperatureDial = GlassTemperatureDial;

class _GlassTrackPainter extends CustomPainter {
  final double trackWidth;
  final bool isDark;

  _GlassTrackPainter({required this.trackWidth, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - trackWidth) / 2 - 8;

    const startAngle = 135 * math.pi / 180;
    const sweepAngle = 270 * math.pi / 180;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth
      ..strokeCap = StrokeCap.round
      ..color = isDark
          ? const Color(0x33FFFFFF)
          : const Color(0x1A000000);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );
  }

  @override
  bool shouldRepaint(_GlassTrackPainter oldDelegate) =>
      isDark != oldDelegate.isDark;
}

class _GlassArcPainter extends CustomPainter {
  final double progress;
  final double trackWidth;
  final List<Color> gradientColors;
  final double glowIntensity;

  _GlassArcPainter({
    required this.progress,
    required this.trackWidth,
    required this.gradientColors,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - trackWidth) / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const startAngle = 135 * math.pi / 180;
    final sweepAngle = 270 * math.pi / 180 * progress;

    if (progress > 0) {
      // Glow effect
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth + 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [
            gradientColors[0].withValues(alpha: glowIntensity),
            gradientColors[1].withValues(alpha: glowIntensity),
          ],
        ).createShader(rect);
      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);

      // Main arc
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth
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
  bool shouldRepaint(_GlassArcPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      glowIntensity != oldDelegate.glowIntensity;
}

class _GlassThumbPainter extends CustomPainter {
  final double progress;
  final double trackWidth;
  final Color color;
  final bool isPressed;

  _GlassThumbPainter({
    required this.progress,
    required this.trackWidth,
    required this.color,
    required this.isPressed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - trackWidth) / 2 - 8;

    const startAngle = 135 * math.pi / 180;
    final angle = startAngle + (270 * math.pi / 180 * progress);

    final thumbCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    final thumbRadius = isPressed ? 10.0 : 12.0;

    // Glow
    canvas.drawCircle(
      thumbCenter,
      thumbRadius + 6,
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Shadow
    canvas.drawCircle(
      thumbCenter + const Offset(0, 2),
      thumbRadius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // White background
    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      Paint()..color = Colors.white,
    );

    // Colored ring
    canvas.drawCircle(
      thumbCenter,
      thumbRadius - 3,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_GlassThumbPainter oldDelegate) =>
      progress != oldDelegate.progress || isPressed != oldDelegate.isPressed;
}
