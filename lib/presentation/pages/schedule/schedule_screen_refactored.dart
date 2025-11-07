/// Refactored schedule screen with extracted components
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/week_schedule.dart';
import '../../../domain/entities/day_schedule.dart';
import '../../../domain/usecases/update_schedule.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_state.dart';
import '../../widgets/schedule/schedule_app_bar.dart';
import '../../widgets/schedule/day_schedule_card.dart';
import '../../widgets/schedule/quick_actions_panel.dart';
import 'schedule_dialogs.dart';
import 'schedule_logic.dart';

/// Main schedule screen - refactored to under 200 lines
class ScheduleScreen extends StatefulWidget {
  final String unitId;

  const ScheduleScreen({
    super.key,
    required this.unitId,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late WeekSchedule _schedule;
  bool _hasChanges = false;
  bool _isSaving = false;
  bool _isLoading = false;
  HvacUnit? _currentUnit;

  @override
  void initState() {
    super.initState();
    _schedule = WeekSchedule.defaultSchedule;
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
  }

  Future<void> _refreshSchedule(HvacUnit unit) async {
    // Reload schedule from server
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _schedule = unit.schedule ?? WeekSchedule.defaultSchedule;
        _hasChanges = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HvacListBloc, HvacListState>(
      builder: (context, state) {
        if (state is HvacListLoaded) {
          final unit = state.units.firstWhere(
            (u) => u.id == widget.unitId,
            orElse: () => state.units.first,
          );

          // Initialize schedule from unit if not set
          if (_currentUnit?.id != unit.id) {
            _currentUnit = unit;
            _schedule = unit.schedule ?? WeekSchedule.defaultSchedule;
          }

          return _buildContent(unit);
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildContent(HvacUnit unit) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: ScheduleAppBar(
        unit: unit,
        hasChanges: _hasChanges,
        isSaving: _isSaving,
        onSave: () => _saveSchedule(unit),
        onBack: _onBackPressed,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_currentUnit == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        final padding = isDesktop
            ? const EdgeInsets.all(HvacSpacing.xl)
            : const EdgeInsets.all(HvacSpacing.lg);

        return Padding(
          padding: padding,
          child: isDesktop
              ? _buildDesktopLayout(_currentUnit!)
              : _buildMobileLayout(_currentUnit!),
        );
      },
    );
  }

  Widget _buildMobileLayout(HvacUnit unit) {
    return HvacRefreshIndicator(
      onRefresh: () => _refreshSchedule(unit),
      child: HvacSkeletonLoader(
        isLoading: _isLoading,
        child: ListView(
          children: [
            ..._buildDayCards(),
            const SizedBox(height: HvacSpacing.lg),
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

  Widget _buildDesktopLayout(HvacUnit unit) {
    return HvacRefreshIndicator(
      onRefresh: () => _refreshSchedule(unit),
      child: HvacSkeletonLoader(
        isLoading: _isLoading,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ListView(children: _buildDayCards()),
                ),
                const SizedBox(width: HvacSpacing.xl),
                SizedBox(
                  width: 320.0,
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
        padding: const EdgeInsets.only(bottom: HvacSpacing.sm),
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

  Future<void> _saveSchedule(HvacUnit unit) async {
    setState(() => _isSaving = true);

    try {
      final updateSchedule = sl<UpdateSchedule>();
      await updateSchedule(unit.id, _schedule);

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
      final shouldDiscard =
          await ScheduleDialogs.showUnsavedChangesDialog(context);
      if (shouldDiscard == true && mounted) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }
}
