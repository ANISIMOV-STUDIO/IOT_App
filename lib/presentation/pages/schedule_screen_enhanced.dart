/// Enhanced Schedule Screen with Web-First Focus
///
/// Main screen for schedule management optimized for web platform
/// Delegates UI components to specialized widgets for maintainability
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../core/utils/accessibility_utils.dart';
import '../../generated/l10n/app_localizations.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart' as app_error;
import '../widgets/common/empty_state_widget.dart';
import '../widgets/schedule/schedule_model.dart';
import '../widgets/schedule/schedule_list.dart';
import '../widgets/schedule/schedule_fab.dart';
import '../widgets/schedule/schedule_state_manager.dart';

class EnhancedScheduleScreen extends StatefulWidget {
  const EnhancedScheduleScreen({super.key});

  @override
  State<EnhancedScheduleScreen> createState() =>
      _EnhancedScheduleScreenState();
}

class _EnhancedScheduleScreenState extends State<EnhancedScheduleScreen> {
  bool _isLoading = false;
  String? _error;
  List<Schedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final schedules = await ScheduleStateManager.loadSchedules();
      setState(() {
        _schedules = schedules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSchedule(Schedule schedule) async {
    final success = await ScheduleStateManager.deleteSchedule(
      context,
      schedule,
    );

    if (success) {
      setState(() {
        _schedules.removeWhere((s) => s.id == schedule.id);
      });
    }
  }

  void _toggleSchedule(Schedule schedule, bool value) {
    setState(() {
      ScheduleStateManager.toggleSchedule(context, schedule, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: HvacColors.backgroundCard,
        elevation: 0,
        title: Text(
          'Schedules',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
        actions: [
          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Center(
                child: SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      HvacColors.primaryOrange,
                    ),
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, color: HvacColors.textPrimary),
              onPressed: _loadSchedules,
              tooltip: 'Обновить',
            ),
          IconButton(
            icon: const Icon(Icons.settings, color: HvacColors.textPrimary),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Настройки',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadSchedules,
        color: HvacColors.primaryOrange,
        child: _buildBody(context, l10n),
      ),
      floatingActionButton: ScheduleFAB(
        onPressed: _navigateToCreateSchedule,
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading && _schedules.isEmpty) {
      return const LoadingWidget(
        type: LoadingType.shimmer,
        message: 'Loading schedules...',
      );
    }

    if (_error != null && _schedules.isEmpty) {
      return app_error.AppErrorWidget.network(
        onRetry: _loadSchedules,
        customMessage: _error,
      );
    }

    if (_schedules.isEmpty) {
      return EmptyStateWidget.noSchedules(
        onCreateSchedule: _navigateToCreateSchedule,
      );
    }

    return ScheduleList(
      schedules: _schedules,
      onEdit: _navigateToEditSchedule,
      onDelete: _deleteSchedule,
      onToggle: _toggleSchedule,
      onRefresh: _loadSchedules,
    );
  }

  void _navigateToCreateSchedule() {
    AccessibilityUtils.announce('Opening schedule creation screen');
    Navigator.pushNamed(context, '/create-schedule');
  }

  void _navigateToEditSchedule(Schedule schedule) {
    AccessibilityUtils.announce('Opening schedule editor for ${schedule.name}');
    Navigator.pushNamed(context, '/edit-schedule', arguments: schedule);
  }
}