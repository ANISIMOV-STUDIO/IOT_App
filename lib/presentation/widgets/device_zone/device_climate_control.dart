/// Climate control widget for device
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/climate.dart';

/// Full climate control panel for the right sidebar
class DeviceClimateControl extends StatelessWidget {
  final double targetTemperature;
  final ClimateMode mode;
  final String? modeLabel;
  final double supplyAirflow;
  final double exhaustAirflow;
  final String preset;
  final ValueChanged<double>? onTemperatureChanged;
  final ValueChanged<ClimateMode>? onModeChanged;
  final ValueChanged<double>? onSupplyAirflowChanged;
  final ValueChanged<double>? onExhaustAirflowChanged;
  final ValueChanged<String>? onPresetChanged;

  // Localized labels
  final String targetTempLabel;
  final String heatingLabel;
  final String coolingLabel;
  final String autoLabel;
  final String ventilationLabel;
  final String airflowControlLabel;
  final String supplyLabel;
  final String exhaustLabel;
  final String nightLabel;
  final String turboLabel;
  final String ecoLabel;
  final String awayLabel;

  const DeviceClimateControl({
    super.key,
    required this.targetTemperature,
    required this.mode,
    this.modeLabel,
    required this.supplyAirflow,
    required this.exhaustAirflow,
    required this.preset,
    this.onTemperatureChanged,
    this.onModeChanged,
    this.onSupplyAirflowChanged,
    this.onExhaustAirflowChanged,
    this.onPresetChanged,
    this.targetTempLabel = 'Целевая температура',
    this.heatingLabel = 'Обогрев',
    this.coolingLabel = 'Охлаждение',
    this.autoLabel = 'Авто',
    this.ventilationLabel = 'Вентиляция',
    this.airflowControlLabel = 'Управление воздухопотоком',
    this.supplyLabel = 'Приток',
    this.exhaustLabel = 'Вытяжка',
    this.nightLabel = 'Ночь',
    this.turboLabel = 'Турбо',
    this.ecoLabel = 'Эко',
    this.awayLabel = 'Уход',
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            targetTempLabel,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 12),

          // Temperature display
          Center(
            child: _TemperatureDisplay(
              value: targetTemperature,
              mode: mode,
              label: modeLabel ?? _getModeLabel(mode),
              onChanged: onTemperatureChanged,
            ),
          ),
          const SizedBox(height: 12),

          // Mode selector
          _ModeSelector(
            mode: mode,
            onModeChanged: onModeChanged,
            heatingLabel: heatingLabel,
            coolingLabel: coolingLabel,
            autoLabel: autoLabel,
            ventilationLabel: ventilationLabel,
          ),
          const SizedBox(height: 16),

          // Divider
          Divider(color: theme.colorScheme.border),
          const SizedBox(height: 16),

          // Airflow control
          Text(
            airflowControlLabel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 12),

          _AirflowSlider(
            label: supplyLabel,
            value: supplyAirflow,
            color: AppColors.primary,
            onChanged: onSupplyAirflowChanged,
          ),
          const SizedBox(height: 8),

          _AirflowSlider(
            label: exhaustLabel,
            value: exhaustAirflow,
            color: AppColors.cooling,
            onChanged: onExhaustAirflowChanged,
          ),

          const Spacer(),

          // Presets
          _PresetGrid(
            selectedPreset: preset,
            onPresetChanged: onPresetChanged,
            autoLabel: autoLabel,
            nightLabel: nightLabel,
            turboLabel: turboLabel,
            ecoLabel: ecoLabel,
            awayLabel: awayLabel,
          ),
        ],
      ),
    );
  }

  String _getModeLabel(ClimateMode mode) => switch (mode) {
        ClimateMode.heating => heatingLabel,
        ClimateMode.cooling => coolingLabel,
        ClimateMode.auto => autoLabel,
        ClimateMode.dry => 'Сушка',
        ClimateMode.ventilation => ventilationLabel,
        ClimateMode.off => 'Выкл',
      };
}

class _TemperatureDisplay extends StatelessWidget {
  final double value;
  final ClimateMode mode;
  final String label;
  final ValueChanged<double>? onChanged;

  const _TemperatureDisplay({
    required this.value,
    required this.mode,
    required this.label,
    this.onChanged,
  });

  Color get _modeColor => switch (mode) {
        ClimateMode.heating => AppColors.heating,
        ClimateMode.cooling => AppColors.cooling,
        ClimateMode.auto => AppColors.modeAuto,
        _ => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _modeColor.withValues(alpha: 0.3),
          width: 4,
        ),
        gradient: RadialGradient(
          colors: [
            _modeColor.withValues(alpha: 0.1),
            _modeColor.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.foreground,
                ),
              ),
              Text(
                '°C',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: _modeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  final ClimateMode mode;
  final ValueChanged<ClimateMode>? onModeChanged;
  final String heatingLabel;
  final String coolingLabel;
  final String autoLabel;
  final String ventilationLabel;

  const _ModeSelector({
    required this.mode,
    this.onModeChanged,
    required this.heatingLabel,
    required this.coolingLabel,
    required this.autoLabel,
    required this.ventilationLabel,
  });

  @override
  Widget build(BuildContext context) {
    ShadTheme.of(context);

    return Row(
      children: [
        _ModeButton(
          icon: Icons.whatshot_outlined,
          label: heatingLabel,
          color: AppColors.heating,
          isSelected: mode == ClimateMode.heating,
          onTap: () => onModeChanged?.call(ClimateMode.heating),
        ),
        const SizedBox(width: 8),
        _ModeButton(
          icon: Icons.ac_unit,
          label: coolingLabel,
          color: AppColors.cooling,
          isSelected: mode == ClimateMode.cooling,
          onTap: () => onModeChanged?.call(ClimateMode.cooling),
        ),
        const SizedBox(width: 8),
        _ModeButton(
          icon: Icons.autorenew,
          label: autoLabel,
          color: AppColors.modeAuto,
          isSelected: mode == ClimateMode.auto,
          onTap: () => onModeChanged?.call(ClimateMode.auto),
        ),
        const SizedBox(width: 8),
        _ModeButton(
          icon: Icons.air,
          label: ventilationLabel,
          color: AppColors.primary,
          isSelected: mode == ClimateMode.ventilation,
          onTap: () => onModeChanged?.call(ClimateMode.ventilation),
        ),
      ],
    );
  }
}

/// Mode button - icon only (mode name shown in temperature display)
class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label; // Kept for tooltip/accessibility
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Expanded(
      child: Tooltip(
        message: label,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : theme.colorScheme.muted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isSelected ? color : theme.colorScheme.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}

class _AirflowSlider extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double>? onChanged;

  const _AirflowSlider({
    required this.label,
    required this.value,
    required this.color,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            Text(
              '${value.round()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ShadSlider(
          initialValue: value,
          min: 0,
          max: 100,
          onChangeEnd: onChanged,
        ),
      ],
    );
  }
}

class _PresetGrid extends StatelessWidget {
  final String selectedPreset;
  final ValueChanged<String>? onPresetChanged;
  final String autoLabel;
  final String nightLabel;
  final String turboLabel;
  final String ecoLabel;
  final String awayLabel;

  const _PresetGrid({
    required this.selectedPreset,
    this.onPresetChanged,
    required this.autoLabel,
    required this.nightLabel,
    required this.turboLabel,
    required this.ecoLabel,
    required this.awayLabel,
  });

  @override
  Widget build(BuildContext context) {
    final presets = [
      _PresetData('auto', autoLabel, Icons.hdr_auto, AppColors.modeAuto),
      _PresetData('night', nightLabel, Icons.nights_stay, AppColors.cooling),
      _PresetData('turbo', turboLabel, Icons.rocket_launch, AppColors.heating),
      _PresetData('eco', ecoLabel, Icons.eco, AppColors.success),
      _PresetData('away', awayLabel, Icons.sensor_door, AppColors.primary),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((preset) {
        final isSelected = selectedPreset == preset.id;
        return _PresetButton(
          preset: preset,
          isSelected: isSelected,
          onTap: () => onPresetChanged?.call(preset.id),
        );
      }).toList(),
    );
  }
}

class _PresetData {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const _PresetData(this.id, this.label, this.icon, this.color);
}

class _PresetButton extends StatelessWidget {
  final _PresetData preset;
  final bool isSelected;
  final VoidCallback? onTap;

  const _PresetButton({
    required this.preset,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? preset.color.withValues(alpha: 0.15)
              : theme.colorScheme.muted.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? preset.color : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              preset.icon,
              size: 16,
              color: isSelected ? preset.color : theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 6),
            Text(
              preset.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? preset.color : theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
