/// Refactored schedule screen with extracted components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/week_schedule.dart';
import '../../../domain/entities/day_schedule.dart';
import '../../../domain/usecases/update_schedule.dart';
import '../../widgets/schedule/schedule_app_bar.dart';
import '../../widgets/schedule/day_schedule_card.dart';
import '../../widgets/schedule/quick_actions_panel.dart';
import 'schedule_dialogs.dart';
import 'schedule_logic.dart';

/// Main schedule screen - refactored to under 200 lines
class ScheduleScreen extends StatefulWidget {
  final HvacUnit unit;

  const ScheduleScreen({
    super.key,
    required this.unit,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late WeekSchedule _schedule;
  bool _hasChanges = false;
  bool _isSaving = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _schedule = widget.unit.schedule ?? WeekSchedule.defaultSchedule;
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
  }

  Future<void> _refreshSchedule() async {
    // Reload schedule from server
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _schedule = widget.unit.schedule ?? WeekSchedule.defaultSchedule;
        _hasChanges = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: ScheduleAppBar(
        unit: widget.unit,
        hasChanges: _hasChanges,
        isSaving: _isSaving,
        onSave: _saveSchedule,
        onBack: _onBackPressed,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        final padding = isDesktop
            ? EdgeInsets.all(HvacSpacing.xl.w)
            : EdgeInsets.all(HvacSpacing.lg.w);

        return Padding(
          padding: padding,
          child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return HvacRefreshIndicator(
      onRefresh: _refreshSchedule,
      child: HvacSkeletonLoader(
        isLoading: _isLoading,
        child: ListView(
          children: [
            ..._buildDayCards(),
            SizedBox(height: HvacSpacing.lg.h),
            QuickActionsPanel(
              onWeekdaySchedule: _applyWeekdaySchedule,
              onWeekendSchedule: _applyWeekendSchedule,
              onDisableAll: _disableAllSchedules,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return HvacRefreshIndicator(
      onRefresh: _refreshSchedule,
      child: HvacSkeletonLoader(
        isLoading: _isLoading,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1200.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ListView(children: _buildDayCards()),
                ),
                SizedBox(width: HvacSpacing.xl.w),
                SizedBox(
                  width: 320.w,
                  child: QuickActionsPanel(
                    onWeekdaySchedule: _applyWeekdaySchedule,
                    onWeekendSchedule: _applyWeekendSchedule,
                    onDisableAll: _disableAllSchedules,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDayCards() {
    final days = ScheduleLogic.getDayList(_schedule);
    return days.map((day) {
      return Padding(
        padding: EdgeInsets.only(bottom: HvacSpacing.sm.h),
        child: DayScheduleCard(
          dayName: day.$1,
          dayOfWeek: day.$2,
          schedule: day.$3,
          onScheduleChanged: (schedule) => _updateDay(day.$2, schedule),
        ),
      );
    }).toList();
  }

  void _updateDay(int dayOfWeek, DaySchedule schedule) {
    setState(() {
      _hasChanges = true;
      _schedule = _schedule.updateDay(dayOfWeek, schedule);
    });
  }

  void _applyWeekdaySchedule() {
    setState(() {
      _hasChanges = true;
      _schedule = ScheduleLogic.applyWeekdaySchedule(_schedule);
    });
  }

  void _applyWeekendSchedule() {
    setState(() {
      _hasChanges = true;
      _schedule = ScheduleLogic.applyWeekendSchedule(_schedule);
    });
  }

  void _disableAllSchedules() {
    setState(() {
      _hasChanges = true;
      _schedule = ScheduleLogic.disableAllSchedules();
    });
  }

  Future<void> _saveSchedule() async {
    setState(() => _isSaving = true);

    try {
      final updateSchedule = sl<UpdateSchedule>();
      await updateSchedule(widget.unit.id, _schedule);

      setState(() {
        _hasChanges = false;
        _isSaving = false;
      });

      if (mounted) {
        ScheduleDialogs.showSuccessSnackBar(context);
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScheduleDialogs.showErrorSnackBar(context, e.toString());
      }
    }
  }

  Future<void> _onBackPressed() async {
    if (_hasChanges) {
      final shouldDiscard = await ScheduleDialogs.showUnsavedChangesDialog(context);
      if (shouldDiscard == true && mounted) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }
}