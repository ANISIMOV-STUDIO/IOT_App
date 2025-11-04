/// Quick actions panel for schedule presets with web interactions
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Panel with quick action buttons for schedule presets
class QuickActionsPanel extends StatelessWidget {
  final VoidCallback onWeekdaySchedule;
  final VoidCallback onWeekendSchedule;
  final VoidCallback onDisableAll;

  const QuickActionsPanel({
    super.key,
    required this.onWeekdaySchedule,
    required this.onWeekendSchedule,
    required this.onDisableAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(HvacSpacing.md.w),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(HvacRadius.md.r),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Быстрые действия',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          SizedBox(height: HvacSpacing.sm.h),
          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  title: 'Будни',
                  subtitle: 'Пн-Пт 7:00-20:00',
                  icon: Icons.work_outline,
                  onPressed: onWeekdaySchedule,
                  color: HvacColors.primaryBlue,
                ),
              ),
              SizedBox(width: HvacSpacing.sm.w),
              Expanded(
                child: _QuickActionButton(
                  title: 'Выходные',
                  subtitle: 'Сб-Вс 9:00-22:00',
                  icon: Icons.weekend,
                  onPressed: onWeekendSchedule,
                  color: HvacColors.success,
                ),
              ),
            ],
          ),
          SizedBox(height: HvacSpacing.xs.h),
          SizedBox(
            width: double.infinity,
            child: _QuickActionButton(
              title: 'Отключить всё',
              subtitle: 'Выключить расписание на всю неделю',
              icon: Icons.clear,
              onPressed: onDisableAll,
              color: HvacColors.error,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual quick action button with hover effects
class _QuickActionButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final bool isFullWidth;

  const _QuickActionButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    required this.color,
    this.isFullWidth = false,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? widget.color.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(HvacRadius.sm.r),
                  border: Border.all(
                    color: _isHovered
                        ? widget.color
                        : HvacColors.backgroundCardBorder,
                    width: _isHovered ? 2 : 1,
                  ),
                ),
                padding: EdgeInsets.all(HvacSpacing.sm.w),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(HvacSpacing.xs.w),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? widget.color.withValues(alpha: 0.2)
                            : widget.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(HvacRadius.xs.r),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: HvacSpacing.xs.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: _isHovered
                                  ? widget.color
                                  : HvacColors.textPrimary,
                            ),
                          ),
                          if (!widget.isFullWidth)
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: HvacColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          else
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: HvacColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}