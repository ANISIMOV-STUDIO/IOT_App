import 'package:flutter/material.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';
import 'neumorphic_temperature_dial.dart';

/// Mode selector buttons (Heating, Cooling, Dry)
class NeumorphicModeSelector extends StatelessWidget {
  final TemperatureMode selectedMode;
  final ValueChanged<TemperatureMode>? onModeChanged;

  const NeumorphicModeSelector({
    super.key,
    required this.selectedMode,
    this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: TemperatureMode.values.map((mode) {
        final isSelected = mode == selectedMode;
        
        return GestureDetector(
          onTap: () => onModeChanged?.call(mode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
              horizontal: NeumorphicSpacing.lg,
              vertical: NeumorphicSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? theme.colors.cardSurface 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(NeumorphicSpacing.radiusMd),
              boxShadow: isSelected ? theme.shadows.convexSmall : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getModeIcon(mode),
                  color: isSelected 
                      ? _getModeColor(mode) 
                      : theme.colors.textTertiary,
                  size: 28,
                ),
                const SizedBox(height: NeumorphicSpacing.xs),
                Text(
                  _getModeLabel(mode),
                  style: theme.typography.labelMedium.copyWith(
                    color: isSelected 
                        ? theme.colors.textPrimary 
                        : theme.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getModeIcon(TemperatureMode mode) {
    switch (mode) {
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

  String _getModeLabel(TemperatureMode mode) {
    switch (mode) {
      case TemperatureMode.heating:
        return 'Heating';
      case TemperatureMode.cooling:
        return 'Cooling';
      case TemperatureMode.auto:
        return 'Auto';
      case TemperatureMode.dry:
        return 'Dry';
    }
  }

  Color _getModeColor(TemperatureMode mode) {
    switch (mode) {
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
}
