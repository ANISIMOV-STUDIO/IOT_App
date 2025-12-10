import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_colors.dart';

/// Temperature mode enum
enum TemperatureMode { heating, cooling, auto, dry }

/// Neumorphic Temperature Dial using sleek_circular_slider for smooth performance
class NeumorphicTemperatureDial extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;
  final String? label;
  final TemperatureMode mode;
  final double size;

  const NeumorphicTemperatureDial({
    super.key,
    required this.value,
    this.minValue = 10,
    this.maxValue = 30,
    this.onChanged,
    this.onChangeEnd,
    this.label,
    this.mode = TemperatureMode.heating,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final modeColor = _getModeColor();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer neumorphic container
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colors.cardSurface,
              boxShadow: theme.shadows.convexLarge,
            ),
          ),
          
          // Sleek circular slider
          SleekCircularSlider(
            min: minValue,
            max: maxValue,
            initialValue: value.clamp(minValue, maxValue),
            appearance: CircularSliderAppearance(
              size: size - 16,
              startAngle: 135,
              angleRange: 270,
              animationEnabled: true,
              customWidths: CustomSliderWidths(
                trackWidth: 6,
                progressBarWidth: 6,
                shadowWidth: 0,
                handlerSize: 8,
              ),
              customColors: CustomSliderColors(
                trackColor: theme.colors.textTertiary.withValues(alpha: 0.15),
                progressBarColor: modeColor,
                dotColor: modeColor,
                shadowColor: Colors.transparent,
                shadowMaxOpacity: 0,
              ),
              infoProperties: InfoProperties(
                modifier: (v) => '', // Hide default text
              ),
            ),
            onChange: onChanged,
            onChangeEnd: onChangeEnd,
            innerWidget: (percentage) => _buildInnerContent(theme, modeColor),
          ),
          
          // Min/Max labels
          Positioned(
            left: 12,
            bottom: size * 0.28,
            child: Text(
              '${minValue.round()}°',
              style: theme.typography.labelSmall.copyWith(
                color: theme.colors.textTertiary,
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: size * 0.28,
            child: Text(
              '${maxValue.round()}°',
              style: theme.typography.labelSmall.copyWith(
                color: theme.colors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerContent(NeumorphicThemeData theme, Color modeColor) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colors.cardSurface,
        boxShadow: theme.shadows.concaveMedium,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mode label
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                label!.toUpperCase(),
                style: theme.typography.labelSmall.copyWith(
                  letterSpacing: 1.5,
                  color: theme.colors.textTertiary,
                  fontSize: 9,
                ),
              ),
            ),
          
          // Temperature value
          Text(
            value.round().toString(),
            style: theme.typography.displayLarge.copyWith(
              fontSize: size * 0.18,
              fontWeight: FontWeight.w300,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Mode icon
          Icon(
            _getModeIcon(),
            color: modeColor,
            size: 20,
          ),
        ],
      ),
    );
  }

  Color _getModeColor() => switch (mode) {
    TemperatureMode.heating => NeumorphicColors.modeHeating,
    TemperatureMode.cooling => NeumorphicColors.modeCooling,
    TemperatureMode.auto => NeumorphicColors.modeAuto,
    TemperatureMode.dry => NeumorphicColors.modeDry,
  };

  IconData _getModeIcon() => switch (mode) {
    TemperatureMode.heating => Icons.whatshot_outlined,
    TemperatureMode.cooling => Icons.ac_unit,
    TemperatureMode.auto => Icons.autorenew,
    TemperatureMode.dry => Icons.water_drop_outlined,
  };
}
