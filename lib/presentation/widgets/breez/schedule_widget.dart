/// Schedule Widget - Weekly schedule display
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// Schedule entry data
class ScheduleEntry {
  final String day;
  final String mode;
  final String timeRange;
  final int tempDay;
  final int tempNight;
  final bool isActive;

  const ScheduleEntry({
    required this.day,
    required this.mode,
    required this.timeRange,
    required this.tempDay,
    required this.tempNight,
    this.isActive = false,
  });
}

/// Weekly schedule widget
class ScheduleWidget extends StatelessWidget {
  final List<ScheduleEntry> entries;
  final VoidCallback? onSeeAll;
  final ValueChanged<int>? onEntryTap;

  const ScheduleWidget({
    super.key,
    required this.entries,
    this.onSeeAll,
    this.onEntryTap,
  });

  @override
  Widget build(BuildContext context) {
    return BreezCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Расписание',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onSeeAll,
                  child: Text(
                    'Все',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Schedule entries
          Expanded(
            child: ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _ScheduleRow(
                  entry: entry,
                  onTap: () => onEntryTap?.call(index),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Active schedule highlight
          if (entries.any((e) => e.isActive))
            _ActiveScheduleCard(
              entry: entries.firstWhere((e) => e.isActive),
            ),
        ],
      ),
    );
  }
}

/// Individual schedule row
class _ScheduleRow extends StatefulWidget {
  final ScheduleEntry entry;
  final VoidCallback? onTap;

  const _ScheduleRow({
    required this.entry,
    this.onTap,
  });

  @override
  State<_ScheduleRow> createState() => _ScheduleRowState();
}

class _ScheduleRowState extends State<_ScheduleRow> {
  bool _isHovered = false;

  IconData _getModeIcon() {
    switch (widget.entry.mode.toLowerCase()) {
      case 'охлаждение':
      case 'cooling':
        return Icons.ac_unit;
      case 'нагрев':
      case 'heating':
        return Icons.whatshot;
      case 'вентиляция':
      case 'ventilation':
        return Icons.air;
      case 'авто':
      case 'auto':
        return Icons.autorenew;
      case 'эко':
      case 'eco':
        return Icons.eco;
      default:
        return Icons.thermostat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Day
              SizedBox(
                width: 80,
                child: Text(
                  widget.entry.day,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: widget.entry.isActive
                        ? Colors.white
                        : AppColors.darkTextMuted,
                  ),
                ),
              ),

              // Mode icon
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getModeIcon(),
                  size: 14,
                  color: AppColors.accent,
                ),
              ),

              const SizedBox(width: 10),

              // Mode name
              Expanded(
                child: Text(
                  widget.entry.mode,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextMuted,
                  ),
                ),
              ),

              // Temperature range
              Text(
                '${widget.entry.tempDay}° / ${widget.entry.tempNight}°',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Active schedule card (highlighted)
class _ActiveScheduleCard extends StatelessWidget {
  final ScheduleEntry entry;

  const _ActiveScheduleCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent,
            AppColors.accentLight,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Сейчас',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.wb_cloudy_outlined,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.mode,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            '${entry.tempDay}° / ${entry.tempNight}°',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
