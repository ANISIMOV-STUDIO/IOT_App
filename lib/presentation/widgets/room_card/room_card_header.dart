/// Room Card Header
///
/// Header section for room card with name, status, and power button
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/ui_constants.dart';

class RoomCardHeader extends StatelessWidget {
  final String roomName;
  final bool isActive;
  final ValueChanged<bool>? onPowerChanged;

  const RoomCardHeader({
    super.key,
    required this.roomName,
    required this.isActive,
    this.onPowerChanged,
  });

  @override
  Widget build(BuildContext context) {
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
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: isActive
                          ? HvacColors.success
                          : HvacColors.textTertiary,
                      shape: BoxShape.circle,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color:
                                    HvacColors.success.withValues(alpha: 0.4),
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
        _PowerButton(
          isActive: isActive,
          onPowerChanged: onPowerChanged,
        ),
      ],
    );
  }
}

class _PowerButton extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool>? onPowerChanged;

  const _PowerButton({
    required this.isActive,
    this.onPowerChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            color:
                isActive ? HvacColors.primaryOrange : HvacColors.textTertiary,
            size: UIConstants.iconSmR,
          ),
        ),
      ),
    );
  }
}
