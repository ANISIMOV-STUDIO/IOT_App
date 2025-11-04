/// Tablet Quick Actions Panel
///
/// Quick action buttons for tablet home layout
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
class TabletQuickActions extends StatelessWidget {
  final VoidCallback onPowerAllOn;
  final VoidCallback onPowerAllOff;
  final VoidCallback onSyncSettings;
  final VoidCallback onApplyScheduleToAll;

  const TabletQuickActions({
    super.key,
    required this.onPowerAllOn,
    required this.onPowerAllOff,
    required this.onSyncSettings,
    required this.onApplyScheduleToAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.lgRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1.w,
        ),
      ),
      padding: const EdgeInsets.all(HvacSpacing.lgR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: HvacSpacing.mdV),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: HvacSpacing.smV,
            crossAxisSpacing: HvacSpacing.smR,
            childAspectRatio: 2.5,
            children: [
              _buildActionButton(
                icon: Icons.power_settings_new,
                label: 'All On',
                onTap: onPowerAllOn,
                color: HvacColors.success,
              ),
              _buildActionButton(
                icon: Icons.power_off,
                label: 'All Off',
                onTap: onPowerAllOff,
                color: HvacColors.error,
              ),
              _buildActionButton(
                icon: Icons.sync,
                label: 'Sync',
                onTap: onSyncSettings,
                color: HvacColors.primaryOrange,
              ),
              _buildActionButton(
                icon: Icons.schedule,
                label: 'Schedule',
                onTap: onApplyScheduleToAll,
                color: HvacColors.primaryBlue,
              ),
            ],
          ),
        ],
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
      color: HvacColors.backgroundCard,
      borderRadius: HvacRadius.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: HvacRadius.mdRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.smR,
            vertical: HvacSpacing.smV,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.w,
            ),
            borderRadius: HvacRadius.mdRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: color,
              ),
              const SizedBox(width: HvacSpacing.xsR),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}