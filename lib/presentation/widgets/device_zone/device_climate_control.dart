/// Climate control widget for device
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';
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
    final t = NeumorphicTheme.of(context);

    return NeumorphicCard(
      variant: NeumorphicCardVariant.concave,
      padding: const EdgeInsets.all(NeumorphicSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(targetTempLabel, style: t.typography.titleLarge),
          const SizedBox(height: NeumorphicSpacing.sm),

          // Temperature dial
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: NeumorphicTemperatureDial(
                value: targetTemperature,
                minValue: 10,
                maxValue: 30,
                mode: _mapToTempMode(mode),
                label: modeLabel ?? _getModeLabel(mode),
                onChangeEnd: onTemperatureChanged,
              ),
            ),
          ),
          const SizedBox(height: NeumorphicSpacing.sm),

          // Mode selector
          NeumorphicSegmentedControl<ClimateMode>(
            segments: [
              SegmentItem(
                value: ClimateMode.heating,
                label: heatingLabel,
                icon: Icons.whatshot_outlined,
                activeColor: NeumorphicColors.modeHeating,
              ),
              SegmentItem(
                value: ClimateMode.cooling,
                label: coolingLabel,
                icon: Icons.ac_unit,
                activeColor: NeumorphicColors.modeCooling,
              ),
              SegmentItem(
                value: ClimateMode.auto,
                label: autoLabel,
                icon: Icons.autorenew,
                activeColor: NeumorphicColors.modeAuto,
              ),
              SegmentItem(
                value: ClimateMode.ventilation,
                label: ventilationLabel,
                icon: Icons.air,
                activeColor: NeumorphicColors.accentPrimary,
              ),
            ],
            selectedValue: mode,
            onSelected: onModeChanged,
          ),
          const SizedBox(height: NeumorphicSpacing.md),

          // Divider
          Divider(color: t.colors.textTertiary.withValues(alpha: 0.2)),
          const SizedBox(height: NeumorphicSpacing.md),

          // Airflow control
          Text(airflowControlLabel, style: t.typography.titleMedium),
          const SizedBox(height: NeumorphicSpacing.sm),

          NeumorphicSlider(
            label: supplyLabel,
            value: supplyAirflow,
            suffix: '%',
            activeColor: NeumorphicColors.accentPrimary,
            onChangeEnd: onSupplyAirflowChanged,
          ),
          const SizedBox(height: NeumorphicSpacing.xs),

          NeumorphicSlider(
            label: exhaustLabel,
            value: exhaustAirflow,
            suffix: '%',
            activeColor: NeumorphicColors.modeCooling,
            onChangeEnd: onExhaustAirflowChanged,
          ),

          const Spacer(),

          // Presets
          NeumorphicPresetGrid(
            presets: [
              PresetItem(
                id: 'auto',
                label: autoLabel,
                icon: Icons.hdr_auto,
                activeColor: NeumorphicColors.modeAuto,
              ),
              PresetItem(
                id: 'night',
                label: nightLabel,
                icon: Icons.nights_stay,
                activeColor: NeumorphicColors.modeCooling,
              ),
              PresetItem(
                id: 'turbo',
                label: turboLabel,
                icon: Icons.rocket_launch,
                activeColor: NeumorphicColors.modeHeating,
              ),
              PresetItem(
                id: 'eco',
                label: ecoLabel,
                icon: Icons.eco,
                activeColor: NeumorphicColors.accentSuccess,
              ),
              PresetItem(
                id: 'away',
                label: awayLabel,
                icon: Icons.sensor_door,
                activeColor: NeumorphicColors.accentPrimary,
              ),
            ],
            selectedId: preset,
            onSelected: onPresetChanged,
          ),
        ],
      ),
    );
  }

  TemperatureMode _mapToTempMode(ClimateMode mode) => switch (mode) {
        ClimateMode.heating => TemperatureMode.heating,
        ClimateMode.cooling => TemperatureMode.cooling,
        ClimateMode.auto => TemperatureMode.auto,
        ClimateMode.dry => TemperatureMode.dry,
        _ => TemperatureMode.auto,
      };

  String _getModeLabel(ClimateMode mode) => switch (mode) {
        ClimateMode.heating => heatingLabel,
        ClimateMode.cooling => coolingLabel,
        ClimateMode.auto => autoLabel,
        ClimateMode.dry => 'Сушка',
        ClimateMode.ventilation => ventilationLabel,
        ClimateMode.off => 'Выкл',
      };
}
