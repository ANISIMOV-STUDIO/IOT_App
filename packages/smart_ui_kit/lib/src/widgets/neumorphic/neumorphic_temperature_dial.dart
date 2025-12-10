import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Neumorphic Temperature Dial - Circular thermostat control
class NeumorphicTemperatureDial extends StatefulWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final ValueChanged<double>? onChanged;
  final String? label;
  final TemperatureMode mode;
  final double size;

  const NeumorphicTemperatureDial({
    super.key,
    required this.value,
    this.minValue = 10,
    this.maxValue = 30,
    this.onChanged,
    this.label,
    this.mode = TemperatureMode.heating,
    this.size = NeumorphicSpacing.temperatureDialSize,
  });

  @override
  State<NeumorphicTemperatureDial> createState() => _NeumorphicTemperatureDialState();
}

class _NeumorphicTemperatureDialState extends State<NeumorphicTemperatureDial> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(NeumorphicTemperatureDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value;
    }
  }

  void _handlePanUpdate(DragUpdateDetails details, Offset center) {
    if (widget.onChanged == null) return;

    final position = details.localPosition - center;
    var angle = math.atan2(position.dy, position.dx);
    
    // Convert angle to value (map -135° to 135° => minValue to maxValue)
    // Adjust for dial starting position
    angle = angle + math.pi / 2; // Rotate so top is 0
    if (angle < -math.pi) angle += 2 * math.pi;
    if (angle > math.pi) angle -= 2 * math.pi;

    // Map angle (-135° to 135°) to value range
    const startAngle = -math.pi * 0.75; // -135°
    const endAngle = math.pi * 0.75;    // 135°
    const totalAngle = endAngle - startAngle;

    if (angle >= startAngle && angle <= endAngle) {
      final normalizedAngle = (angle - startAngle) / totalAngle;
      final newValue = widget.minValue + 
          normalizedAngle * (widget.maxValue - widget.minValue);
      
      setState(() {
        _currentValue = newValue.clamp(widget.minValue, widget.maxValue);
      });
      widget.onChanged?.call(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onPanUpdate: (details) => _handlePanUpdate(
          details, 
          Offset(widget.size / 2, widget.size / 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring with shadow
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colors.cardSurface,
                boxShadow: theme.shadows.convexLarge,
              ),
            ),
            
            // Progress arc
            CustomPaint(
              size: Size(widget.size - 20, widget.size - 20),
              painter: _DialArcPainter(
                progress: (_currentValue - widget.minValue) / 
                    (widget.maxValue - widget.minValue),
                activeColor: _getModeColor(),
                inactiveColor: theme.colors.textTertiary.withValues(alpha: 0.2),
                strokeWidth: 6,
              ),
            ),
            
            // Inner circle (concave)
            Container(
              width: widget.size * 0.65,
              height: widget.size * 0.65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colors.cardSurface,
                boxShadow: theme.shadows.concaveMedium,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mode label
                  if (widget.label != null)
                    Text(
                      widget.label!.toUpperCase(),
                      style: theme.typography.labelSmall.copyWith(
                        letterSpacing: 2,
                        color: theme.colors.textTertiary,
                      ),
                    ),
                  
                  // Temperature value
                  Text(
                    _currentValue.round().toString(),
                    style: theme.typography.displayLarge.copyWith(
                      fontSize: widget.size * 0.2,
                    ),
                  ),
                  
                  // Mode icon
                  Icon(
                    _getModeIcon(),
                    color: _getModeColor(),
                    size: 24,
                  ),
                ],
              ),
            ),
            
            // Min/Max labels
            Positioned(
              left: 8,
              bottom: widget.size * 0.3,
              child: Text(
                '${widget.minValue.round()}°',
                style: theme.typography.labelSmall,
              ),
            ),
            Positioned(
              right: 8,
              bottom: widget.size * 0.3,
              child: Text(
                '${widget.maxValue.round()}°',
                style: theme.typography.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getModeColor() {
    switch (widget.mode) {
      case TemperatureMode.heating:
        return NeumorphicColors.modeHeating;
      case TemperatureMode.cooling:
        return NeumorphicColors.modeCooling;
      case TemperatureMode.auto:
        return NeumorphicColors.modeAuto;
      case TemperatureMode.dry:
        return NeumorphicColors.modeDry;
    }
  }

  IconData _getModeIcon() {
    switch (widget.mode) {
      case TemperatureMode.heating:
        return Icons.whatshot_outlined;
      case TemperatureMode.cooling:
        return Icons.ac_unit;
      case TemperatureMode.auto:
        return Icons.autorenew;
      case TemperatureMode.dry:
        return Icons.water_drop_outlined;
    }
  }
}

enum TemperatureMode {
  heating,
  cooling,
  auto,
  dry,
}

/// Custom painter for the arc progress indicator
class _DialArcPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;

  _DialArcPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    const startAngle = math.pi * 0.75;  // 135° from top
    const sweepAngle = math.pi * 1.5;   // 270° total arc

    // Background arc
    final bgPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Active arc
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_DialArcPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.activeColor != activeColor;
}
