/// Mode Preset Card Widget
///
/// Card for displaying and editing ventilation mode presets
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.deviceCard(),
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
                  color: AppTheme.textSecondary,
                  tooltip: 'Редактировать',
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            preset.mode.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),

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
              const SizedBox(width: 16),
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
          const SizedBox(height: 12),
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
              const SizedBox(width: 16),
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
    );
  }

  Widget _buildParameter(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
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
