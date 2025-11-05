/// Day schedule card with HVAC UI Kit components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/day_schedule.dart';
import '../common/time_picker_field.dart';

/// Card widget for displaying and editing a single day's schedule
class DayScheduleCard extends StatefulWidget {
  final String dayName;
  final int dayOfWeek;
  final DaySchedule schedule;
  final ValueChanged<DaySchedule> onScheduleChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DayScheduleCard({
    super.key,
    required this.dayName,
    required this.dayOfWeek,
    required this.schedule,
    required this.onScheduleChanged,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<DayScheduleCard> createState() => _DayScheduleCardState();
}

class _DayScheduleCardState extends State<DayScheduleCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.schedule.timerEnabled;

    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animation
    Future.delayed(Duration(milliseconds: 50 * widget.dayOfWeek), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(DayScheduleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.schedule.timerEnabled != oldWidget.schedule.timerEnabled) {
      setState(() {
        _isExpanded = widget.schedule.timerEnabled;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildSwipeableCard(),
      ),
    );
  }

  Widget _buildSwipeableCard() {
    // Wrap with swipeable if edit/delete callbacks are provided
    if (widget.onEdit != null || widget.onDelete != null) {
      return HvacSwipeableCard(
        key: ValueKey('schedule_${widget.dayOfWeek}'),
        onSwipeRight: widget.onEdit,
        onSwipeLeft: widget.onDelete,
        rightActionLabel: 'Edit',
        rightActionIcon: Icons.edit,
        leftActionLabel: 'Reset',
        leftActionIcon: Icons.refresh,
        rightActionColor: HvacColors.primaryBlue,
        leftActionColor: HvacColors.warning,
        child: _buildCardContent(),
      );
    }

    return _buildCardContent();
  }

  Widget _buildCardContent() {
    final cardChild = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: const SizedBox(height: 0),
            secondChild: _buildTimeSelectors(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );

    // Add gradient border for active schedules
    if (widget.schedule.timerEnabled) {
      return HvacGradientBorder(
        gradientColors: const [
          HvacColors.primaryOrange,
          HvacColors.primaryBlue,
        ],
        borderWidth: 2.0,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: HvacColors.backgroundCard,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: cardChild,
        ),
      );
    }

    // Regular card for disabled schedules
    return HvacInteractiveScale(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: cardChild,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.dayName,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
        HvacInteractiveScale(
          scaleDown: 0.9,
          child: Switch(
            value: widget.schedule.timerEnabled,
            onChanged: (value) {
              widget.onScheduleChanged(
                widget.schedule.copyWith(timerEnabled: value),
              );
            },
            activeThumbColor: HvacColors.primaryOrange,
            activeTrackColor: HvacColors.primaryOrange.withValues(alpha: 0.5),
            inactiveThumbColor: HvacColors.textSecondary,
            inactiveTrackColor: HvacColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelectors() {
    return Column(
      children: [
        const SizedBox(height: 12.0),
        Row(
          children: [
            Expanded(
              child: HvacInteractiveRipple(
                onTap: () {},
                borderRadius: BorderRadius.circular(8.0),
                rippleColor: HvacColors.success.withValues(alpha: 0.3),
                child: TimePickerField(
                  label: 'Включение',
                  currentTime: widget.schedule.turnOnTime,
                  icon: Icons.power_settings_new,
                  onTimeChanged: (time) {
                    widget.onScheduleChanged(
                      widget.schedule.copyWith(turnOnTime: time),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: HvacInteractiveRipple(
                onTap: () {},
                borderRadius: BorderRadius.circular(8.0),
                rippleColor: HvacColors.error.withValues(alpha: 0.3),
                child: TimePickerField(
                  label: 'Отключение',
                  currentTime: widget.schedule.turnOffTime,
                  icon: Icons.power_off,
                  onTimeChanged: (time) {
                    widget.onScheduleChanged(
                      widget.schedule.copyWith(turnOffTime: time),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}