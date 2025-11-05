/// Schedule information display widgets
///
/// Extracted components for displaying schedule details
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'schedule_model.dart';

/// Schedule name and time info widget
class ScheduleInfo extends StatelessWidget {
  final Schedule schedule;
  final bool isTablet;

  const ScheduleInfo({
    super.key,
    required this.schedule,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule.name,
          style: TextStyle(
            fontSize: isTablet ? 18.0 : 16.0,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          '${schedule.time} • ${schedule.days.join(', ')}',
          style: const TextStyle(
            fontSize: 14.0,
            color: HvacColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Temperature and mode info widget
class TemperatureInfo extends StatelessWidget {
  final Schedule schedule;

  const TemperatureInfo({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.thermostat,
          size: 20.0,
          color: HvacColors.primaryOrange,
        ),
        const SizedBox(width: 8.0),
        Text(
          '${schedule.temperature}°C',
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: HvacColors.textPrimary,
          ),
        ),
        const SizedBox(width: 12.0),
        _ModeChip(mode: schedule.mode),
      ],
    );
  }
}

/// Mode display chip
class _ModeChip extends StatelessWidget {
  final String mode;

  const _ModeChip({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: HvacColors.primaryOrange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        mode,
        style: const TextStyle(
          fontSize: 12.0,
          color: HvacColors.primaryOrange,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}