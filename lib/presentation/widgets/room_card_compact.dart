/// Room Card Compact
///
/// Modern, compact, and professional room/device card
/// Addresses user feedback about wasted space and poor alignment
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_utils.dart';

class RoomCardCompact extends StatelessWidget {
  final String roomName;
  final bool isActive;
  final double? temperature;
  final int? humidity;
  final int? fanSpeed;
  final String? mode;
  final ValueChanged<bool>? onPowerChanged;
  final VoidCallback? onTap;

  const RoomCardCompact({
    super.key,
    required this.roomName,
    this.isActive = false,
    this.temperature,
    this.humidity,
    this.fanSpeed,
    this.mode,
    this.onPowerChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isMobile ? 140.h : 160.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [
                    AppTheme.primaryOrange.withValues(alpha: 0.05),
                    AppTheme.backgroundCard,
                  ]
                : [
                    AppTheme.backgroundCard,
                    AppTheme.backgroundCard,
                  ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isActive
                ? AppTheme.primaryOrange.withValues(alpha: 0.3)
                : AppTheme.backgroundCardBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Row
            _buildHeader(context),

            // Stats Row
            _buildStats(context),

            // Mode Indicator
            if (mode != null) _buildModeIndicator(context),
          ],
        ),
      ).animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Room Name and Status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roomName,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: isActive ? AppTheme.success : AppTheme.textTertiary,
                      shape: BoxShape.circle,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppTheme.success.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    isActive ? 'Активно' : 'Выключено',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Power Button
        _buildPowerButton(context),
      ],
    );
  }

  Widget _buildPowerButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPowerChanged?.call(!isActive),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                : AppTheme.backgroundCardBorder.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isActive
                  ? AppTheme.primaryOrange.withValues(alpha: 0.3)
                  : AppTheme.backgroundCardBorder,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.power_settings_new,
            color: isActive ? AppTheme.primaryOrange : AppTheme.textTertiary,
            size: 20.w,
          ),
        ).animate(target: isActive ? 1 : 0)
          .rotate(end: 0.5, duration: 300.ms)
          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (temperature != null)
          _StatItem(
            icon: Icons.thermostat,
            value: '${temperature!.toStringAsFixed(1)}°',
            label: 'Темп',
            color: AppTheme.info,
            isCompact: true,
          ),
        if (humidity != null)
          _StatItem(
            icon: Icons.water_drop,
            value: '$humidity%',
            label: 'Влаж',
            color: AppTheme.info.withValues(
              red: AppTheme.info.r * 0.7,
              green: AppTheme.info.g * 1.2,
              blue: AppTheme.info.b * 1.1,
            ),
            isCompact: true,
          ),
        if (fanSpeed != null)
          _StatItem(
            icon: Icons.air,
            value: '$fanSpeed%',
            label: 'Вент',
            color: AppTheme.warning,
            isCompact: true,
          ),
      ],
    );
  }

  Widget _buildModeIndicator(BuildContext context) {
    final modeColor = _getModeColor(mode!);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: modeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: modeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getModeIcon(mode!),
            size: 14.w,
            color: modeColor,
          ),
          SizedBox(width: 6.w),
          Text(
            mode!,
            style: TextStyle(
              fontSize: 11.sp,
              color: modeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: 200.ms)
      .slideX(begin: -0.1, end: 0);
  }

  Color _getModeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'авто':
      case 'auto':
        return AppTheme.info;
      case 'приток':
      case 'supply':
        return AppTheme.success;
      case 'вытяжка':
      case 'exhaust':
        return AppTheme.warning;
      case 'рециркуляция':
      case 'recirculation':
        return AppTheme.primaryOrange;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getModeIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'авто':
      case 'auto':
        return Icons.auto_mode;
      case 'приток':
      case 'supply':
        return Icons.login;
      case 'вытяжка':
      case 'exhaust':
        return Icons.logout;
      case 'рециркуляция':
      case 'recirculation':
        return Icons.loop;
      default:
        return Icons.settings_suggest;
    }
  }
}

/// Reusable stat item widget
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isCompact;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 16.w,
              color: color,
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.w,
              color: color,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}