/// Group Control Panel Widget
///
/// Controls for managing multiple units at once
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.group_work,
                  color: AppTheme.accent, // Gold accent for header icon
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Групповое управление',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Активно: $activeUnits из $totalUnits',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Power controls
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Включить все',
                  Icons.power_settings_new,
                  AppTheme.success,
                  onPowerAllOn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Выключить все',
                  Icons.power_off,
                  AppTheme.error,
                  onPowerAllOff,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Sync controls
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Синхр. настройки',
                  Icons.sync,
                  AppTheme.info,
                  onSyncSettings,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Общее расписание',
                  Icons.schedule,
                  AppTheme.warning,
                  onApplyScheduleToAll,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Units list with checkboxes
          const Text(
            'Управляемые установки',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

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
      cursor: onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            // Background: always dark gray, never colored
            color: AppTheme.backgroundDark,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              // Border: always neutral gray, never colored
              color: AppTheme.backgroundCardBorder,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ONLY icon is colored
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary, // Text always white
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: unit.power ? AppTheme.success : AppTheme.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              unit.name,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Text(
            unit.power ? 'Вкл' : 'Выкл',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: unit.power ? AppTheme.success : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
