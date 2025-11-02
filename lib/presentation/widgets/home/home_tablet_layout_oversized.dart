/// Home Tablet Layout Widget
///
/// Optimized layout for tablet devices (600-1200px width)
/// Uses 2-column grid for better space utilization
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/automation_rule.dart';
import '../../../domain/entities/mode_preset.dart';
import 'home_room_preview.dart';
import 'home_automation_section.dart';
import 'home_notifications_panel.dart';

/// Tablet layout for home dashboard - 2 column optimized
class HomeTabletLayout extends StatelessWidget {
  final HvacUnit? currentUnit;
  final List<HvacUnit> units;
  final String? selectedUnit;
  final Function(bool) onPowerChanged;
  final VoidCallback? onDetailsPressed;
  final Function(HvacUnit?, BuildContext) buildControlCards;
  final Function(AutomationRule) onRuleToggled;
  final VoidCallback onManageRules;
  final Function(ModePreset) onPresetSelected;
  final VoidCallback onPowerAllOn;
  final VoidCallback onPowerAllOff;
  final VoidCallback onSyncSettings;
  final VoidCallback onApplyScheduleToAll;

  const HomeTabletLayout({
    super.key,
    required this.currentUnit,
    required this.units,
    required this.selectedUnit,
    required this.onPowerChanged,
    required this.onDetailsPressed,
    required this.buildControlCards,
    required this.onRuleToggled,
    required this.onManageRules,
    required this.onPresetSelected,
    required this.onPowerAllOn,
    required this.onPowerAllOff,
    required this.onSyncSettings,
    required this.onApplyScheduleToAll,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallTablet = screenWidth < 900;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Room preview - full width on tablets
          _buildRoomPreviewSection(),

          SizedBox(height: AppSpacing.xlV),

          // 2-column layout for controls and info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - Control cards
              Expanded(
                flex: isSmallTablet ? 1 : 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildControlCards(currentUnit, context),
                    SizedBox(height: AppSpacing.lgV),
                    if (isSmallTablet) ...[
                      _buildQuickActions(),
                      SizedBox(height: AppSpacing.lgV),
                    ],
                  ],
                ),
              ),

              SizedBox(width: AppSpacing.xlR),

              // Right column - Quick actions & notifications
              Expanded(
                flex: isSmallTablet ? 1 : 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isSmallTablet) ...[
                      _buildQuickActions(),
                      SizedBox(height: AppSpacing.lgV),
                    ],
                    _buildPresets(),
                    SizedBox(height: AppSpacing.lgV),
                    if (currentUnit != null)
                      HomeNotificationsPanel(unit: currentUnit!),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.xlV),

          // Automation section - full width
          HomeAutomationSection(
            currentUnit: currentUnit,
            onRuleToggled: onRuleToggled,
            onManageRules: onManageRules,
          ),
        ],
      ),
    );
  }

  Widget _buildRoomPreviewSection() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 320.h,
      ),
      child: HomeRoomPreview(
        currentUnit: currentUnit,
        selectedUnit: selectedUnit,
        onPowerChanged: onPowerChanged,
        onDetailsPressed: onDetailsPressed,
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.all(AppSpacing.lgR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.mdV),

          // 2x2 grid of action buttons
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.smV,
            crossAxisSpacing: AppSpacing.smR,
            childAspectRatio: 2.5,
            children: [
              _buildActionButton(
                icon: Icons.power_settings_new,
                label: 'All On',
                onTap: onPowerAllOn,
                color: AppTheme.successGreen,
              ),
              _buildActionButton(
                icon: Icons.power_off,
                label: 'All Off',
                onTap: onPowerAllOff,
                color: AppTheme.errorRed,
              ),
              _buildActionButton(
                icon: Icons.sync,
                label: 'Sync',
                onTap: onSyncSettings,
                color: AppTheme.primaryOrange,
              ),
              _buildActionButton(
                icon: Icons.schedule,
                label: 'Schedule',
                onTap: onApplyScheduleToAll,
                color: AppTheme.primaryBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresets() {
    final presets = [
      ModePreset.eco(),
      ModePreset.comfort(),
      ModePreset.turbo(),
      ModePreset.night(),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.all(AppSpacing.lgR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Presets',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.mdV),
          ...presets.map((preset) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.smV),
            child: _buildPresetButton(preset),
          )),
        ],
      ),
    );
  }

  Widget _buildPresetButton(ModePreset preset) {
    return Material(
      color: AppTheme.backgroundCard,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () => onPresetSelected(preset),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.mdR,
            vertical: AppSpacing.smV,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.backgroundCardBorder,
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                _getPresetIcon(preset),
                size: 20.sp,
                color: _getPresetColor(preset),
              ),
              SizedBox(width: AppSpacing.smR),
              Expanded(
                child: Text(
                  preset.mode.displayName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20.sp,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: AppTheme.backgroundCard,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.smR,
            vertical: AppSpacing.smV,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: color,
              ),
              SizedBox(width: AppSpacing.xsR),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPresetIcon(ModePreset preset) {
    switch (preset.mode.displayName.toLowerCase()) {
      case 'eco':
        return Icons.eco;
      case 'comfort':
        return Icons.weekend;
      case 'turbo':
        return Icons.flash_on;
      case 'night':
        return Icons.nights_stay;
      default:
        return Icons.settings;
    }
  }

  Color _getPresetColor(ModePreset preset) {
    switch (preset.mode.displayName.toLowerCase()) {
      case 'eco':
        return AppTheme.successGreen;
      case 'comfort':
        return AppTheme.primaryOrange;
      case 'turbo':
        return AppTheme.errorRed;
      case 'night':
        return AppTheme.primaryBlue;
      default:
        return AppTheme.textSecondary;
    }
  }
}