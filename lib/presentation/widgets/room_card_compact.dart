/// Room Card Compact
///
/// Modern, compact, and professional room/device card
/// Addresses user feedback about wasted space and poor alignment
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/ui_constants.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/animation/smooth_animations.dart';
import '../../core/utils/performance_utils.dart';

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

    // Wrap entire card with RepaintBoundary for performance
    return PerformanceUtils.isolateRepaint(
      MicroInteraction(
        onTap: onTap,
        child: SmoothAnimations.fadeIn(
          duration: AnimationDurations.medium,
          child: SmoothAnimations.scaleIn(
            begin: 0.95,
            duration: AnimationDurations.medium,
            child: Container(
              constraints: BoxConstraints(
                minHeight: isMobile ? 140.h : 160.h,
                maxHeight: isMobile ? 160.h : 180.h,
              ),
              padding: EdgeInsets.all(AppSpacing.mdR),
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
                borderRadius: BorderRadius.circular(AppRadius.lgR),
                border: Border.all(
                  color: isActive
                      ? AppTheme.primaryOrange.withValues(alpha: 0.3)
                      : AppTheme.backgroundCardBorder,
                  width: UIConstants.dividerThin,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: UIConstants.blurMedium,
                    offset: const Offset(0, UIConstants.elevation1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Row
                  _buildHeader(context),

                  SizedBox(height: AppSpacing.smV),

                  // Stats Row
                  _buildStats(context),

                  // Mode Indicator
                  if (mode != null) ...[
                    SizedBox(height: AppSpacing.smV),
                    _buildModeIndicator(context),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      debugLabel: 'RoomCard-$roomName',
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
                style: AppTypography.h5.copyWith(
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSpacing.xxsV),
              Row(
                children: [
                  AnimatedContainer(
                    duration: UIConstants.durationMedium,
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: isActive ? AppTheme.success : AppTheme.textTertiary,
                      shape: BoxShape.circle,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppTheme.success.withValues(alpha: 0.4),
                                blurRadius: UIConstants.blurMedium,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xxsR),
                  Text(
                    isActive ? 'Активно' : 'Выключено',
                    style: AppTypography.captionSmall.copyWith(
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
        borderRadius: BorderRadius.circular(AppRadius.mdR),
        child: Container(
          width: UIConstants.minTouchTargetR,
          height: UIConstants.minTouchTargetR,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                : AppTheme.backgroundCardBorder.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.mdR),
            border: Border.all(
              color: isActive
                  ? AppTheme.primaryOrange.withValues(alpha: 0.3)
                  : AppTheme.backgroundCardBorder,
              width: UIConstants.dividerThin,
            ),
          ),
          child: Icon(
            Icons.power_settings_new,
            color: isActive ? AppTheme.primaryOrange : AppTheme.textTertiary,
            size: UIConstants.iconSmR,
          ),
      ),
    ));
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (temperature != null)
          Flexible(
            child: _StatItem(
              icon: Icons.thermostat,
              value: '${temperature!.toStringAsFixed(1)}°',
              label: 'Темп',
              color: AppTheme.info,
              isCompact: true,
            ),
          ),
        if (humidity != null)
          Flexible(
            child: _StatItem(
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
          ),
        if (fanSpeed != null)
          Flexible(
            child: _StatItem(
              icon: Icons.air,
              value: '$fanSpeed%',
              label: 'Вент',
              color: AppTheme.warning,
              isCompact: true,
            ),
          ),
      ],
    );
  }

  Widget _buildModeIndicator(BuildContext context) {
    final modeColor = _getModeColor(mode!);

    return SmoothAnimations.fadeIn(
      delay: AnimationDurations.fast,
      duration: AnimationDurations.normal,
      child: SmoothAnimations.slideIn(
        begin: const Offset(-0.05, 0),
        delay: AnimationDurations.fast,
        duration: AnimationDurations.normal,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.smR,
            vertical: AppSpacing.xxsV,
          ),
          decoration: BoxDecoration(
            color: modeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.smR),
            border: Border.all(
              color: modeColor.withValues(alpha: 0.3),
              width: UIConstants.dividerThin,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getModeIcon(mode!),
                size: UIConstants.iconXsR,
                color: modeColor,
              ),
              SizedBox(width: AppSpacing.xxsR),
              Flexible(
                child: Text(
                  mode!,
                  style: AppTypography.overline.copyWith(
                    color: modeColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              borderRadius: BorderRadius.circular(AppRadius.smR),
            ),
            child: Icon(
              icon,
              size: UIConstants.iconXsR,
              color: color,
            ),
          ),
          SizedBox(width: AppSpacing.xsR),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                label,
                style: AppTypography.overline.copyWith(
                  fontSize: 10.sp,
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
              size: UIConstants.iconXsR,
              color: color,
            ),
            SizedBox(width: AppSpacing.xxsR),
            Text(
              label,
              style: AppTypography.overline,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xxsV),
        Text(
          value,
          style: AppTypography.h5.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}