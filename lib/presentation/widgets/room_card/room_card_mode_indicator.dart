/// Room Card Mode Indicator
///
/// Mode indicator badge for room card
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/ui_constants.dart';

class RoomCardModeIndicator extends StatelessWidget {
  final String mode;

  const RoomCardModeIndicator({
    super.key,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final modeColor = _getModeColor(mode);

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
                _getModeIcon(mode),
                size: UIConstants.iconXsR,
                color: modeColor,
              ),
              const SizedBox(width: HvacSpacing.xxsR),
              Flexible(
                child: Text(
                  mode,
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
