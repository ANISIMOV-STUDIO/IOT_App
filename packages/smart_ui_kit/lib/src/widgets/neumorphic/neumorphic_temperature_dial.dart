import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../theme/tokens/neumorphic_colors.dart';

/// Temperature mode enum
enum TemperatureMode { heating, cooling, auto, dry }

/// Premium Temperature Dial using Syncfusion Radial Gauge
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

  // Gradient colors based on mode
  List<Color> get _gradientColors => switch (widget.mode) {
    TemperatureMode.heating => [
      const Color(0xFFFF6B6B),
      const Color(0xFFFF8E53),
    ],
    TemperatureMode.cooling => [
      const Color(0xFF4FACFE),
      const Color(0xFF00F2FE),
    ],
    TemperatureMode.auto => [
      NeumorphicColors.accentPrimary,
      const Color(0xFF667EEA),
    ],
    TemperatureMode.dry => [
      const Color(0xFFFECE00),
      const Color(0xFFFF9500),
    ],
  };

  Color get _primaryColor => _gradientColors[0];

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 800,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: widget.minValue,
          maximum: widget.maxValue,
          startAngle: 135,
          endAngle: 45,
          showLabels: true,
          showTicks: true,
          showAxisLine: true,
          radiusFactor: 0.95,
          
          // Axis line (background track)
          axisLineStyle: AxisLineStyle(
            cornerStyle: CornerStyle.bothCurve,
            color: Colors.grey.shade200,
            thickness: 20,
          ),
          
          // Labels
          labelOffset: 25,
          axisLabelStyle: GaugeTextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
          
          // Ticks
          majorTickStyle: MajorTickStyle(
            length: 8,
            thickness: 2,
            color: Colors.grey.shade300,
          ),
          minorTickStyle: MinorTickStyle(
            length: 4,
            thickness: 1,
            color: Colors.grey.shade200,
          ),
          minorTicksPerInterval: 1,
          interval: 5,
          
          pointers: <GaugePointer>[
            // Range pointer (progress track)
            RangePointer(
              value: _currentValue,
              cornerStyle: CornerStyle.bothCurve,
              width: 20,
              sizeUnit: GaugeSizeUnit.logicalPixel,
              gradient: SweepGradient(
                colors: _gradientColors,
                stops: const [0.25, 0.75],
              ),
            ),
            
            // Marker pointer (draggable thumb)
            MarkerPointer(
              value: _currentValue,
              enableDragging: true,
              onValueChanged: (v) {
                setState(() => _currentValue = v);
                widget.onChanged?.call(v);
              },
              onValueChangeEnd: (v) {
                widget.onChangeEnd?.call(v);
              },
              markerHeight: 28,
              markerWidth: 28,
              markerType: MarkerType.circle,
              color: Colors.white,
              borderWidth: 3,
              borderColor: _primaryColor,
              elevation: 4,
            ),
          ],
          
          annotations: <GaugeAnnotation>[
            // Temperature value
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.0,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_currentValue.round()}°',
                    style: TextStyle(
                      fontSize: 42,
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
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
