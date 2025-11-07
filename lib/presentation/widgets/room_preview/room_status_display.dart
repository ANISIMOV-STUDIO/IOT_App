/// Room Status Display
///
/// Displays room name and active/inactive status indicator
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Room status display widget
class RoomStatusDisplay extends StatelessWidget {
  final String roomName;
  final bool isActive;
  final bool isMobile;

  const RoomStatusDisplay({
    super.key,
    required this.roomName,
    required this.isActive,
    this.isMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        HvacTemperatureHero(
          tag: 'roomName_$roomName',
          temperature: roomName,
          style: TextStyle(
            fontSize: isMobile ? 22.0 : 28.0,
            fontWeight: FontWeight.w700,
            color: HvacColors.textPrimary,
            height: isMobile ? 1.1 : 1.2,
            shadows: [
              Shadow(
                color: HvacColors.backgroundDark.withValues(alpha: 0.6),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 4.0 : 6.0),
        HvacStatusHero(
          tag: 'status_$roomName',
          child: Row(
            children: [
              Container(
                width: isMobile ? 6.0 : 8.0,
                height: isMobile ? 6.0 : 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? HvacColors.success : HvacColors.error,
                  boxShadow: [
                    BoxShadow(
                      color: (isActive ? HvacColors.success : HvacColors.error)
                          .withValues(alpha: 0.5),
                      blurRadius: isMobile ? 6 : 8,
                      spreadRadius: isMobile ? 1 : 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: isMobile ? 4.0 : 6.0),
              Text(
                isActive ? 'Активно' : 'Неактивно',
                style: TextStyle(
                  fontSize: isMobile ? 12.0 : 14.0,
                  fontWeight: FontWeight.w500,
                  color: HvacColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
