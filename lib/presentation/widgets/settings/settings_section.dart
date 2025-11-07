/// Reusable Settings Section Components
///
/// Common widgets for settings sections
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Reusable Settings Section Container
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return HvacGradientBorder(
      borderWidth: 2.w,
      gradientColors: [
        HvacColors.primaryOrange.withValues(alpha: 0.3),
        HvacColors.primaryBlue.withValues(alpha: 0.3),
      ],
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: HvacColors.primaryOrange, size: 24.w),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: HvacTypography.headlineSmall.copyWith(
                    fontSize: 18.sp,
                    color: HvacColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Reusable Switch Tile with Accessibility
class SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title: $subtitle',
      toggled: value,
      hint: 'Tap to toggle',
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: HvacTypography.titleMedium.copyWith(
                        fontSize: 14.sp,
                        color: HvacColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: HvacTypography.labelLarge.copyWith(
                        fontSize: 12.sp,
                        color: HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Ensure minimum tap target of 48x48
              SizedBox(
                width: 48.w,
                height: 48.h,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return HvacColors.primaryOrange;
                    }
                    return null;
                  }),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (!states.contains(WidgetState.selected)) {
                      return HvacColors.textSecondary.withValues(alpha: 0.3);
                    }
                    return null;
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable Info Row for About Section
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: HvacTypography.bodyMedium.copyWith(
            fontSize: 14.sp,
            color: HvacColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: HvacTypography.titleMedium.copyWith(
            fontSize: 14.sp,
            color: HvacColors.textPrimary,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: content,
        ),
      );
    }

    return content;
  }
}