/// Group Control Panel Widget
///
/// Controls for managing multiple units at once
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/hvac_unit.dart';

class GroupControlPanel extends StatelessWidget {
  final List<HvacUnit> units;
  final VoidCallback? onPowerAllOn;
  final VoidCallback? onPowerAllOff;
  final VoidCallback? onSyncSettings;
  final VoidCallback? onApplyScheduleToAll;

  const GroupControlPanel({
    super.key,
    required this.units,
    this.onPowerAllOn,
    this.onPowerAllOff,
    this.onSyncSettings,
    this.onApplyScheduleToAll,
  });

  @override
  Widget build(BuildContext context) {
    final activeUnits = units.where((u) => u.power).length;
    final totalUnits = units.length;

    return GlassCard(
      // GLASSMORPHISM: Frosted glass with blur
      padding: const EdgeInsets.all(HvacSpacing.lgR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(HvacSpacing.smR),
                decoration: BoxDecoration(
                  color: HvacColors.accent.withValues(alpha: 0.2),
                  borderRadius: HvacRadius.smRadius,
                ),
                child: const Icon(
                  Icons.group_work,
                  color: HvacColors.accent, // Gold accent for header icon
                  size: 20,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Групповое управление',
                      style: HvacTypography.titleLarge.copyWith(
                        color: HvacColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Активно: $activeUnits из $totalUnits',
                      style: HvacTypography.labelLarge.copyWith(
                        color: HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Power controls
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Включить все',
                  Icons.power_settings_new,
                  HvacColors.success,
                  onPowerAllOn,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildActionButton(
                  'Выключить все',
                  Icons.power_off,
                  HvacColors.error,
                  onPowerAllOff,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Sync controls - WHITE with shimmer instead of blue
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Синхр. настройки',
                  Icons.sync,
                  HvacColors.glassWhite, // White shimmer instead of blue
                  onSyncSettings,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildActionButton(
                  'Общее расписание',
                  Icons.schedule,
                  HvacColors.warning,
                  onApplyScheduleToAll,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Units list with checkboxes
          Text(
            'Управляемые установки',
            style: HvacTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: HvacColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8.0),

          ...units.map((unit) => _buildUnitItem(unit)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback? onPressed,
  ) {
    // MONOCHROMATIC: Only icons are colored, buttons and text stay neutral
    return MouseRegion(
      cursor: onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: HvacSpacing.sm, horizontal: HvacSpacing.sm),
          decoration: BoxDecoration(
            // Background: always dark gray, never colored
            color: HvacColors.backgroundDark,
            borderRadius: HvacRadius.smRadius,
            border: Border.all(
              // Border: always neutral gray, never colored
              color: HvacColors.backgroundCardBorder,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ONLY icon is colored
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6.0),
              Flexible(
                child: Text(
                  label,
                  style: HvacTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary, // Text always white
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitItem(HvacUnit unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HvacSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: unit.power ? HvacColors.success : HvacColors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              unit.name,
              style: HvacTypography.labelLarge.copyWith(
                color: HvacColors.textPrimary,
              ),
            ),
          ),
          Text(
            unit.power ? 'Вкл' : 'Выкл',
            style: HvacTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: unit.power ? HvacColors.success : HvacColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
