/// Home Room Preview Widget
///
/// Compact, modern preview card with room controls and status
/// Redesigned for better space utilization and alignment
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/ventilation_mode.dart';
import '../room_card_compact.dart';

class HomeRoomPreview extends StatelessWidget {
  final HvacUnit? currentUnit;
  final String? selectedUnit;
  final ValueChanged<bool>? onPowerChanged;
  final VoidCallback? onDetailsPressed;

  const HomeRoomPreview({
    super.key,
    this.currentUnit,
    this.selectedUnit,
    this.onPowerChanged,
    this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final roomName = currentUnit?.location ?? selectedUnit ?? 'Гостиная';
    final isActive = currentUnit?.power ?? false;

    return SmoothAnimations.slideIn(
      duration: AnimationDurations.medium,
      begin: const Offset(0, 0.05),
      child: SmoothAnimations.fadeIn(
        duration: AnimationDurations.medium,
        child: RoomCardCompact(
          roomName: roomName,
          isActive: isActive,
          temperature: currentUnit?.isVentilation == true
              ? currentUnit?.supplyAirTemp
              : currentUnit?.currentTemp,
          humidity: currentUnit?.humidity.toInt(),
          fanSpeed: currentUnit?.isVentilation == true
              ? currentUnit?.supplyFanSpeed
              : _convertFanSpeedToPercent(currentUnit?.fanSpeed),
          mode: currentUnit?.isVentilation == true
              ? currentUnit?.ventMode?.displayName ?? 'Авто'
              : currentUnit?.mode ?? 'Базовый',
          onPowerChanged: onPowerChanged,
          onTap: onDetailsPressed,
        ),
      ),
    );
  }

  int? _convertFanSpeedToPercent(String? fanSpeed) {
    if (fanSpeed == null) return null;
    switch (fanSpeed.toLowerCase()) {
      case 'high':
        return 100;
      case 'medium':
        return 60;
      case 'low':
        return 30;
      default:
        return 0;
    }
  }
}
