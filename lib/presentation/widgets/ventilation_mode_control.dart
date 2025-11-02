/// Ventilation Mode Control Widget
///
/// Compact card for mode selection and fan speed control
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/ventilation_mode.dart';

class VentilationModeControl extends StatelessWidget {
  final HvacUnit unit;
  final ValueChanged<VentilationMode>? onModeChanged;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;

  const VentilationModeControl({
    super.key,
    required this.unit,
    this.onModeChanged,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Режим работы',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Управление и настройки',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Mode selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.backgroundCardBorder,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<VentilationMode>(
                value: unit.ventMode,
                isExpanded: true,
                dropdownColor: AppTheme.backgroundCard,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.primaryOrange,
                ),
                onChanged: onModeChanged != null
                    ? (VentilationMode? value) {
                        if (value != null) {
                          onModeChanged!(value);
                        }
                      }
                    : null,
                items: VentilationMode.values.map((mode) {
                  return DropdownMenuItem<VentilationMode>(
                    value: mode,
                    child: Text(mode.displayName),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Fan speeds
          _buildFanSpeed(
            'Приточный',
            unit.supplyFanSpeed ?? 0,
            Icons.air,
            onSupplyFanChanged,
          ),

          const SizedBox(height: 12),

          _buildFanSpeed(
            'Вытяжной',
            unit.exhaustFanSpeed ?? 0,
            Icons.air,
            onExhaustFanChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildFanSpeed(
    String label,
    int speed,
    IconData icon,
    ValueChanged<int>? onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              '$speed%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 12,
            ),
            activeTrackColor: AppTheme.primaryOrange,
            inactiveTrackColor: AppTheme.backgroundCardBorder,
            thumbColor: Colors.white,
            overlayColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: speed.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: onChanged != null ? (val) => onChanged(val.round()) : null,
          ),
        ),
      ],
    );
  }
}
