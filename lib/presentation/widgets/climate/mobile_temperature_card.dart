import 'package:smart_ui_kit/smart_ui_kit.dart';

/// Compact temperature control card for mobile layout
/// Shows temperature value with quick mode toggles
class MobileTemperatureCard extends StatelessWidget {
  final double temperature;
  final TemperatureMode mode;
  final ValueChanged<double>? onTemperatureChanged;
  final ValueChanged<TemperatureMode>? onModeChanged;
  final double minTemp;
  final double maxTemp;

  const MobileTemperatureCard({
    super.key,
    required this.temperature,
    required this.mode,
    this.onTemperatureChanged,
    this.onModeChanged,
    this.minTemp = 10,
    this.maxTemp = 30,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return NeumorphicCard(
      padding: const EdgeInsets.all(NeumorphicSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Climate Control',
                style: theme.typography.titleMedium,
              ),
              _ModeIndicator(mode: mode),
            ],
          ),
          const SizedBox(height: NeumorphicSpacing.md),

          // Temperature display + controls
          Row(
            children: [
              // Large temperature display
              Expanded(
                flex: 2,
                child: _TemperatureDisplay(
                  temperature: temperature,
                  mode: mode,
                  onDecrease: onTemperatureChanged != null
                      ? () => _adjustTemperature(-0.5)
                      : null,
                  onIncrease: onTemperatureChanged != null
                      ? () => _adjustTemperature(0.5)
                      : null,
                ),
              ),
              const SizedBox(width: NeumorphicSpacing.md),

              // Mode buttons
              Expanded(
                flex: 3,
                child: _ModeSelector(
                  selectedMode: mode,
                  onModeSelected: onModeChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _adjustTemperature(double delta) {
    final newTemp = (temperature + delta).clamp(minTemp, maxTemp);
    onTemperatureChanged?.call(newTemp);
  }
}

class _ModeIndicator extends StatelessWidget {
  final TemperatureMode mode;

  const _ModeIndicator({required this.mode});

  @override
  Widget build(BuildContext context) {
    final color = _getModeColor(mode);
    final label = _getModeLabel(mode);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getModeIcon(mode),
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemperatureDisplay extends StatelessWidget {
  final double temperature;
  final TemperatureMode mode;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  const _TemperatureDisplay({
    required this.temperature,
    required this.mode,
    this.onDecrease,
    this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getModeColor(mode);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrease button
        _TempAdjustButton(
          icon: Icons.remove,
          onTap: onDecrease,
        ),
        const SizedBox(width: 8),
        // Temperature value
        Text(
          '${temperature.round()}°',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: color,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        // Increase button
        _TempAdjustButton(
          icon: Icons.add,
          onTap: onIncrease,
        ),
      ],
    );
  }
}

class _TempAdjustButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _TempAdjustButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colors.cardSurface,
            shape: BoxShape.circle,
            boxShadow: theme.shadows.convexSmall,
          ),
          child: Icon(
            icon,
            size: 18,
            color: onTap != null
                ? theme.colors.textPrimary
                : theme.colors.textTertiary,
          ),
        ),
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  final TemperatureMode selectedMode;
  final ValueChanged<TemperatureMode>? onModeSelected;

  const _ModeSelector({
    required this.selectedMode,
    this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TemperatureMode.values.map((mode) {
        final isSelected = mode == selectedMode;
        return _ModeButton(
          mode: mode,
          isSelected: isSelected,
          onTap: onModeSelected != null ? () => onModeSelected!(mode) : null,
        );
      }).toList(),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final TemperatureMode mode;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ModeButton({
    required this.mode,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final color = _getModeColor(mode);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : theme.colors.cardSurface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected ? null : theme.shadows.convexSmall,
            border: isSelected
                ? Border.all(color: color, width: 1.5)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getModeIcon(mode),
                size: 16,
                color: isSelected ? color : theme.colors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                _getModeLabel(mode),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : theme.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper functions
Color _getModeColor(TemperatureMode mode) => switch (mode) {
  TemperatureMode.heating => NeumorphicColors.modeHeating,
  TemperatureMode.cooling => NeumorphicColors.modeCooling,
  TemperatureMode.auto => NeumorphicColors.modeAuto,
  TemperatureMode.dry => NeumorphicColors.modeDry,
};

String _getModeLabel(TemperatureMode mode) => switch (mode) {
  TemperatureMode.heating => 'Heat',
  TemperatureMode.cooling => 'Cool',
  TemperatureMode.auto => 'Auto',
  TemperatureMode.dry => 'Dry',
};

IconData _getModeIcon(TemperatureMode mode) => switch (mode) {
  TemperatureMode.heating => Icons.whatshot,
  TemperatureMode.cooling => Icons.ac_unit,
  TemperatureMode.auto => Icons.autorenew,
  TemperatureMode.dry => Icons.water_drop_outlined,
};
