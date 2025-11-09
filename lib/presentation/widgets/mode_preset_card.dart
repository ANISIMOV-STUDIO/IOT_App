/// Mode Preset Card Widget
///
/// Card for displaying and editing ventilation mode presets
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/mode_preset.dart';
import '../../domain/entities/ventilation_mode.dart';

class ModePresetCard extends StatelessWidget {
  final ModePreset preset;
  final VoidCallback? onEdit;
  final bool isEditable;

  const ModePresetCard({
    super.key,
    required this.preset,
    this.onEdit,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HvacSpacing.lgR),
      child: HvacCard(
        size: HvacCardSize.large,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                preset.mode.displayName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (isEditable && onEdit != null)
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                  ),
                  onPressed: onEdit,
                  color: HvacColors.textSecondary,
                  tooltip: 'Редактировать',
                ),
            ],
          ),
          const SizedBox(height: HvacSpacing.xxs),
          Text(
            preset.mode.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: HvacSpacing.md),

          // Parameters
          Row(
            children: [
              Expanded(
                child: _buildParameter(
                  context,
                  'Приточный вент.',
                  '${preset.supplyFanSpeed}%',
                  Icons.air,
                ),
              ),
              const SizedBox(width: HvacSpacing.md),
              Expanded(
                child: _buildParameter(
                  context,
                  'Вытяжной вент.',
                  '${preset.exhaustFanSpeed}%',
                  Icons.air,
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildParameter(
                  context,
                  'T° нагрева',
                  '${preset.heatingTemp.toStringAsFixed(0)}°C',
                  Icons.thermostat,
                ),
              ),
              const SizedBox(width: HvacSpacing.md),
              Expanded(
                child: _buildParameter(
                  context,
                  'T° охлаждения',
                  '${preset.coolingTemp.toStringAsFixed(0)}°C',
                  Icons.ac_unit,
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildParameter(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.mdR),
      decoration: HvacDecorations.cardFlat(
        color: HvacColors.backgroundCard,
        radius: HvacRadius.sm,
        withBorder: false,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: HvacColors.textSecondary,
          ),
          const SizedBox(width: HvacSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: HvacColors.textSecondary,
                  ),
                ),
                const SizedBox(height: HvacSpacing.xxs),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
