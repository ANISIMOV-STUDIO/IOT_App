/// Room Card Compact
///
/// Modern, compact, and professional room/device card
/// Addresses user feedback about wasted space and poor alignment
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../core/theme/ui_constants.dart';
import 'room_card/room_card_header.dart';
import 'room_card/room_card_stats.dart';
import 'room_card/room_card_mode_indicator.dart';

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
      child: MicroInteraction(
        onTap: onTap,
        child: SmoothAnimations.fadeIn(
          duration: AnimationDurations.medium,
          child: SmoothAnimations.scaleIn(
            begin: 0.95,
            duration: AnimationDurations.medium,
            child: GlassCard(
              // GLASSMORPHISM: Frosted glass with blur
              padding: const EdgeInsets.all(HvacSpacing.mdR),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Row
                  RoomCardHeader(
                    roomName: roomName,
                    isActive: isActive,
                    onPowerChanged: onPowerChanged,
                  ),

                  const SizedBox(height: HvacSpacing.smV),

                  // Stats Row
                  RoomCardStats(
                    temperature: temperature,
                    humidity: humidity,
                    fanSpeed: fanSpeed,
                  ),

                  // Mode Indicator
                  if (mode != null) ...[
                    const SizedBox(height: HvacSpacing.smV),
                    RoomCardModeIndicator(mode: mode!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
