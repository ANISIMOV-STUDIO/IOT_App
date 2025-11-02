/// Tablet Quick Actions Panel
///
/// Quick action buttons for tablet home layout
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/app_theme.dart';

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
                color: AppTheme.success,
              ),
              _buildActionButton(
                icon: Icons.power_off,
                label: 'All Off',
                onTap: onPowerAllOff,
                color: AppTheme.error,
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
              color: color.withValues(alpha: 0.3),
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
}