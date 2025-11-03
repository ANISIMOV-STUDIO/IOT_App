/// Room Card Compact
///
/// Modern, compact, and professional room/device card
/// Addresses user feedback about wasted space and poor alignment
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../core/theme/ui_constants.dart';

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
    ResponsiveUtils.isMobile(context);

    // Wrap entire card with RepaintBoundary for performance
    return PerformanceUtils.isolateRepaint(
      MicroInteraction(
        onTap: onTap,
        child: SmoothAnimations.fadeIn(
          duration: AnimationDurations.medium,
          child: SmoothAnimations.scaleIn(
            begin: 0.95,
            duration: AnimationDurations.medium,
            child: GlassCard(
              // GLASSMORPHISM: Frosted glass with blur
              padding: const EdgeInsets.all(HvacSpacing.mdR),
              enableBlur: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Row
                  _buildHeader(context),

                  const SizedBox(height: HvacSpacing.smV),

                  // Stats Row
                  _buildStats(context),

                  // Mode Indicator
                  if (mode != null) ...[
                    const SizedBox(height: HvacSpacing.smV),
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
                style: HvacTypography.h5.copyWith(
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: HvacSpacing.xxsV),
              Row(
                children: [
                  AnimatedContainer(
                    duration: UIConstants.durationMedium,
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: isActive ? HvacColors.success : HvacColors.textTertiary,
                      shape: BoxShape.circle,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: HvacColors.success.withValues(alpha: 0.4),
                                blurRadius: UIConstants.blurMedium,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(width: HvacSpacing.xxsR),
                  Text(
                    isActive ? 'Активно' : 'Выключено',
                    style: HvacTypography.captionSmall.copyWith(
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
        borderRadius: BorderRadius.circular(HvacRadius.mdR),
        child: Container(
          width: UIConstants.minTouchTargetR,
          height: UIConstants.minTouchTargetR,
          decoration: BoxDecoration(
            color: isActive
                ? HvacColors.primaryOrange.withValues(alpha: 0.1)
                : HvacColors.backgroundCardBorder.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(HvacRadius.mdR),
            border: Border.all(
              color: isActive
                  ? HvacColors.primaryOrange.withValues(alpha: 0.3)
                  : HvacColors.backgroundCardBorder,
              width: UIConstants.dividerThin,
            ),
          ),
          child: Icon(
            Icons.power_settings_new,
            color: isActive ? HvacColors.primaryOrange : HvacColors.textTertiary,
            size: UIConstants.iconSmR,
          ),
      ),
    ));
  }

  Widget _buildStats(BuildContext context) {
    // MONOCHROMATIC: Use neutral shades for stats, not colorful icons
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (temperature != null)
          Flexible(
            child: _StatItem(
              icon: Icons.thermostat,
              value: '${temperature!.toStringAsFixed(1)}°',
              label: 'Темп',
              color: HvacColors.neutral100, // Light gray
              isCompact: true,
            ),
          ),
        if (humidity != null)
          Flexible(
            child: _StatItem(
              icon: Icons.water_drop,
              value: '$humidity%',
              label: 'Влаж',
              color: HvacColors.neutral200, // Medium gray
              isCompact: true,
            ),
          ),
        if (fanSpeed != null)
          Flexible(
            child: _StatItem(
              icon: Icons.air,
              value: '$fanSpeed%',
              label: 'Вент',
              color: HvacColors.neutral300, // Dark gray
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
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.smR,
            vertical: HvacSpacing.xxsV,
          ),
          decoration: BoxDecoration(
            color: modeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(HvacRadius.smR),
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
              const SizedBox(width: HvacSpacing.xxsR),
              Flexible(
                child: Text(
                  mode!,
                  style: HvacTypography.overline.copyWith(
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
    // MONOCHROMATIC: All modes use neutral shades, only auto gets gold accent
    switch (mode.toLowerCase()) {
      case 'авто':
      case 'auto':
        return HvacColors.accent; // Gold for auto mode only
      case 'приток':
      case 'supply':
        return HvacColors.neutral100; // Light gray
      case 'вытяжка':
      case 'exhaust':
        return HvacColors.neutral200; // Medium gray
      case 'рециркуляция':
      case 'recirculation':
        return HvacColors.neutral300; // Dark gray
      default:
        return HvacColors.textSecondary;
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
              borderRadius: BorderRadius.circular(HvacRadius.smR),
            ),
            child: Icon(
              icon,
              size: UIConstants.iconXsR,
              color: color,
            ),
          ),
          const SizedBox(width: HvacSpacing.xsR),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: HvacTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                label,
                style: HvacTypography.overline.copyWith(
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
            const SizedBox(width: HvacSpacing.xxsR),
            Text(
              label,
              style: HvacTypography.overline,
            ),
          ],
        ),
        const SizedBox(height: HvacSpacing.xxsV),
        Text(
          value,
          style: HvacTypography.h5.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}