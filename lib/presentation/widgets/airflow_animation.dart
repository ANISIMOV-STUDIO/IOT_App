/// Airflow Animation Widget
///
/// Animated visualization of air flow
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
class AirflowAnimation extends StatefulWidget {
  final bool isActive;
  final int speed; // 0-100

  const AirflowAnimation({
    super.key,
    required this.isActive,
    required this.speed,
  });

  @override
  State<AirflowAnimation> createState() => _AirflowAnimationState();
}

class _AirflowAnimationState extends State<AirflowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _getAnimationDuration()),
      vsync: this,
    );
    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AirflowAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
    if (widget.speed != oldWidget.speed) {
      _controller.duration = Duration(milliseconds: _getAnimationDuration());
      if (widget.isActive) {
        _controller.repeat();
      }
    }
  }

  int _getAnimationDuration() {
    // Faster animation for higher speed
    return (3000 - (widget.speed * 20)).clamp(500, 3000);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(HvacSpacing.lgR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Supply air (left to right)
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: _buildAirflowLine(
              color: HvacColors.info,
              label: 'Приток',
            ),
          ),

          // Exhaust air (right to left)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: _buildAirflowLine(
              color: HvacColors.warning,
              label: 'Вытяжка',
              reversed: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirflowLine({
    required Color color,
    required String label,
    bool reversed = false,
  }) {
    return Row(
      children: [
        if (!reversed) ...[
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _AirflowPainter(
                  progress: _controller.value,
                  color: color,
                  reversed: reversed,
                  isActive: widget.isActive,
                ),
                size: const Size(double.infinity, 10),
              );
            },
          ),
        ),
        if (reversed) ...[
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _AirflowPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool reversed;
  final bool isActive;

  _AirflowPainter({
    required this.progress,
    required this.color,
    required this.reversed,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw base line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Draw moving arrows
    const arrowCount = 5;
    final spacing = size.width / arrowCount;

    for (int i = 0; i < arrowCount; i++) {
      double position = (i * spacing + progress * size.width) % size.width;
      if (reversed) {
        position = size.width - position;
      }

      _drawArrow(
        canvas,
        Offset(position, size.height / 2),
        arrowPaint,
        reversed,
      );
    }
  }

  void _drawArrow(Canvas canvas, Offset position, Paint paint, bool reversed) {
    final path = Path();
    const size = 6.0;
    final direction = reversed ? -1 : 1;

    path.moveTo(position.dx, position.dy);
    path.lineTo(position.dx - size * direction, position.dy - size / 2);
    path.lineTo(position.dx - size * direction, position.dy + size / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AirflowPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isActive != isActive;
  }
}
