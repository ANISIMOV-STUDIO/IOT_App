/// Home Room Preview Widget
///
/// Large preview card with room controls and status
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/ventilation_mode.dart';
import '../room_preview_card.dart';

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
    return SmoothAnimations.slideIn(
      duration: AnimationDurations.medium,
      begin: const Offset(0, 0.1),
      child: SmoothAnimations.fadeIn(
        duration: AnimationDurations.medium,
        child: RoomPreviewCard(
          roomName: currentUnit?.location ?? selectedUnit ?? 'Unit',
          isLive: currentUnit?.power ?? false,
          onPowerChanged: onPowerChanged,
          onDetailsPressed: onDetailsPressed,
          badges: _buildStatusBadges(),
        ),
      ),
    );
  }

  List<StatusBadge> _buildStatusBadges() {
    if (currentUnit == null) return [];

    if (currentUnit!.isVentilation) {
      return [
        StatusBadge(
          icon: Icons.air,
          value: currentUnit!.ventMode?.displayName ?? 'Авто',
        ),
        StatusBadge(
          icon: Icons.thermostat,
          value: '${currentUnit!.supplyAirTemp?.toInt() ?? 0}°C',
        ),
        StatusBadge(
          icon: Icons.water_drop,
          value: '${currentUnit!.humidity.toInt()}%',
        ),
        StatusBadge(
          icon: Icons.speed,
          value: '${currentUnit!.supplyFanSpeed ?? 0}%',
        ),
      ];
    } else {
      return [
        StatusBadge(
          icon: Icons.thermostat,
          value: currentUnit!.fanSpeed,
        ),
        StatusBadge(
          icon: Icons.water_drop,
          value: '${currentUnit!.humidity.toInt()}%',
        ),
        StatusBadge(
          icon: Icons.thermostat,
          value: '${currentUnit!.currentTemp.toInt()}°C',
        ),
        const StatusBadge(
          icon: Icons.bolt,
          value: '350W',
        ),
      ];
    }
  }
}
