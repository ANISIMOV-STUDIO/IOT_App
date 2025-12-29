/// Airflow Slider with custom styling
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// Airflow slider (supply/exhaust) with custom Slider theme
class AirflowSlider extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int>? onChanged;
  final Color color;
  final IconData icon;

  const AirflowSlider({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    required this.color,
    required this.icon,
  });

  @override
  State<AirflowSlider> createState() => _AirflowSliderState();
}

class _AirflowSliderState extends State<AirflowSlider>
    with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  late AnimationController _fanController;

  @override
  void initState() {
    super.initState();
    _fanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _updateFanSpeed();
  }

  @override
  void didUpdateWidget(AirflowSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateFanSpeed();
    }
  }

  void _updateFanSpeed() {
    if (widget.value > 0) {
      // Speed based on value: higher value = faster rotation
      final duration = (2000 - (widget.value * 15)).clamp(200, 2000);
      _fanController.duration = Duration(milliseconds: duration);
      _fanController.repeat();
    } else {
      _fanController.stop();
    }
  }

  @override
  void dispose() {
    _fanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(widget.icon, size: 12, color: widget.color),
                  const SizedBox(width: 6),
                  BreezLabel(widget.label),
                ],
              ),
              Text(
                '${widget.value}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Slider with animated fan thumb overlay
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Base slider (no animation rebuild)
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: widget.color,
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                    thumbColor: Colors.transparent,
                    overlayColor: widget.color.withValues(alpha: 0.2),
                    trackHeight: 10,
                    trackShape: _StyledTrackShape(
                      activeColor: widget.color,
                      isActive: widget.value > 0,
                    ),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                    ),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                  ),
                  child: Slider(
                    value: widget.value.toDouble(),
                    min: 0,
                    max: 100,
                    mouseCursor: _isDragging
                        ? SystemMouseCursors.grabbing
                        : SystemMouseCursors.grab,
                    onChangeStart: widget.onChanged != null
                        ? (_) => setState(() => _isDragging = true)
                        : null,
                    onChangeEnd: widget.onChanged != null
                        ? (_) => setState(() => _isDragging = false)
                        : null,
                    onChanged: widget.onChanged != null
                        ? (v) => widget.onChanged?.call(v.round())
                        : null,
                  ),
                ),
                // Animated fan overlay (separate layer)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _fanController,
                      builder: (context, _) {
                        final thumbX = 12 + (constraints.maxWidth - 24) * (widget.value / 100);
                        return CustomPaint(
                          painter: _FanOverlayPainter(
                            thumbX: thumbX,
                            rotation: _fanController.value * 2 * math.pi,
                            color: widget.color,
                            isActive: widget.value > 0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Fan overlay painter (separate from slider for performance)
class _FanOverlayPainter extends CustomPainter {
  final double thumbX;
  final double rotation;
  final Color color;
  final bool isActive;

  // Константы для внешнего вида вентилятора
  static const double radius = 12;
  static const int bladeCount = 3;

  const _FanOverlayPainter({
    required this.thumbX,
    required this.rotation,
    required this.color,
    this.isActive = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(thumbX, size.height / 2);

    // Outer circle (border)
    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.darkCard
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 1, bgPaint);

    // Fan blades
    final bladeFillPaint = Paint()
      ..color = isActive ? color.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final bladeStrokePaint = Paint()
      ..color = isActive ? color : Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    for (int i = 0; i < bladeCount; i++) {
      canvas.save();
      canvas.rotate(i * (2 * math.pi / bladeCount));

      final path = Path();
      const bladeLength = radius - 2;
      const bladeWidth = 5.0;

      path.moveTo(0, -3);
      path.cubicTo(
        bladeWidth, -bladeLength * 0.3,
        bladeWidth * 0.8, -bladeLength * 0.7,
        1.5, -bladeLength,
      );
      path.cubicTo(
        0, -bladeLength + 1,
        0, -bladeLength + 1,
        -1.5, -bladeLength,
      );
      path.cubicTo(
        -bladeWidth * 0.8, -bladeLength * 0.7,
        -bladeWidth, -bladeLength * 0.3,
        0, -3,
      );
      path.close();

      canvas.drawPath(path, bladeFillPaint);
      canvas.drawPath(path, bladeStrokePaint);
      canvas.restore();
    }

    canvas.restore();

    // Center hub
    final hubFillPaint = Paint()
      ..color = isActive ? color : Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    final hubStrokePaint = Paint()
      ..color = isActive ? Colors.white : Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 3.5, hubFillPaint);
    canvas.drawCircle(center, 3.5, hubStrokePaint);

    // Glow effect
    if (isActive) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, radius, glowPaint);
    }
  }

  @override
  bool shouldRepaint(_FanOverlayPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.thumbX != thumbX ||
        oldDelegate.isActive != isActive ||
        oldDelegate.color != color;
  }
}

/// Custom styled track shape with border
class _StyledTrackShape extends SliderTrackShape {
  final Color activeColor;
  final bool isActive;

  const _StyledTrackShape({
    required this.activeColor,
    this.isActive = true,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 10;
    final trackLeft = offset.dx + 12;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width - 24;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    final canvas = context.canvas;
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );

    final trackHeight = trackRect.height;
    final radius = trackHeight / 2;

    // Background track with border
    final bgRect = RRect.fromRectAndRadius(trackRect, Radius.circular(radius));

    // Background fill
    final bgFillPaint = Paint()
      ..color = AppColors.darkCard
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bgRect, bgFillPaint);

    // Background stroke
    final bgStrokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(bgRect, bgStrokePaint);

    // Active track
    final activeTrackWidth = thumbCenter.dx - trackRect.left;
    if (activeTrackWidth > 0) {
      final activeRect = Rect.fromLTWH(
        trackRect.left,
        trackRect.top,
        activeTrackWidth.clamp(0, trackRect.width),
        trackHeight,
      );
      final activeRRect = RRect.fromRectAndRadius(
        activeRect,
        Radius.circular(radius),
      );

      // Active glow (behind)
      if (isActive) {
        final glowPaint = Paint()
          ..color = activeColor.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        canvas.drawRRect(activeRRect, glowPaint);
      }

      // Active fill
      final activeFillPaint = Paint()
        ..color = activeColor.withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(activeRRect, activeFillPaint);

      // Active stroke
      final activeStrokePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(activeRRect, activeStrokePaint);
    }
  }
}

/// Supply airflow slider (blue)
class SupplyAirflowSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int>? onChanged;

  const SupplyAirflowSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AirflowSlider(
      label: 'Приток',
      value: value,
      onChanged: onChanged,
      color: AppColors.accent,
      icon: Icons.arrow_downward_rounded,
    );
  }
}

/// Exhaust airflow slider (orange)
class ExhaustAirflowSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int>? onChanged;

  const ExhaustAirflowSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AirflowSlider(
      label: 'Вытяжка',
      value: value,
      onChanged: onChanged,
      color: AppColors.accentOrange,
      icon: Icons.arrow_upward_rounded,
    );
  }
}
