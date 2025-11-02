/// Enhanced Schedule Screen with Accessibility
///
/// Comprehensive schedule management with full accessibility support
/// Includes loading/error/empty states and responsive design
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/accessibility_utils.dart';
import '../../core/utils/responsive_builder.dart';
import '../../generated/l10n/app_localizations.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart' as app_error;
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/accessible_button.dart';
import '../widgets/common/app_snackbar.dart';

class EnhancedScheduleScreen extends StatefulWidget {
  const EnhancedScheduleScreen({super.key});

  @override
  State<EnhancedScheduleScreen> createState() => _EnhancedScheduleScreenState();
}

class _EnhancedScheduleScreenState extends State<EnhancedScheduleScreen> {
  bool _isLoading = false;
  String? _error;
  List<Schedule> _schedules = [];
  Schedule? _selectedSchedule;

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

    // Announce loading state to screen reader
    AccessibilityUtils.announce('Loading schedules');

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock data - replace with actual API call
      setState(() {
        _schedules = [
          Schedule(
            id: '1',
            name: 'Weekday Morning',
            time: '06:00',
            days: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
            temperature: 22,
            mode: 'Heat',
            isActive: true,
          ),
          Schedule(
            id: '2',
            name: 'Weekend',
            time: '08:00',
            days: ['Sat', 'Sun'],
            temperature: 20,
            mode: 'Auto',
            isActive: false,
          ),
        ];
        _isLoading = false;
      });

      // Announce success
      AccessibilityUtils.announce('Schedules loaded successfully');
    } catch (e) {
      setState(() {
        _error = 'Failed to load schedules. Please check your connection.';
        _isLoading = false;
      });

      // Announce error
      AccessibilityUtils.announce('Error loading schedules');
    }
  }

  Future<void> _deleteSchedule(Schedule schedule) async {
    // Show confirmation dialog
    final confirmed = await _showDeleteConfirmation(schedule);
    if (!confirmed) return;

    // Check if mounted before using context
    if (!mounted) return;

    // Show loading feedback
    final loadingController = AppSnackBar.showLoading(
      context,
      message: 'Deleting schedule...',
    );

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _schedules.removeWhere((s) => s.id == schedule.id);
      });

      // Dismiss loading
      loadingController.close();

      // Check if mounted before showing snackbar
      if (!mounted) return;

      // Show success feedback
      AppSnackBar.showSuccess(
        context,
        message: 'Schedule deleted successfully',
      );

      // Announce to screen reader
      AccessibilityUtils.announce('Schedule ${schedule.name} deleted');
    } catch (e) {
      // Dismiss loading
      loadingController.close();

      // Check if mounted before showing error
      if (!mounted) return;

      // Show error feedback
      AppSnackBar.showError(
        context,
        message: 'Failed to delete schedule',
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => _deleteSchedule(schedule),
        ),
      );
    }
  }

  Future<bool> _showDeleteConfirmation(Schedule schedule) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => _AccessibleConfirmDialog(
        title: 'Delete Schedule?',
        message: 'Are you sure you want to delete "${schedule.name}"?',
        confirmLabel: 'Delete',
        cancelLabel: 'Cancel',
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: _buildAppBar(context, l10n),
      body: ResponsiveBuilder(
        builder: (context, info) {
          return RefreshIndicator(
            onRefresh: _loadSchedules,
            color: AppTheme.primaryOrange,
            child: _buildBody(context, l10n, info),
          );
        },
      ),
      floatingActionButton: _buildFAB(context, l10n),
    );
  }

  AppBar _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      backgroundColor: AppTheme.backgroundDark,
      elevation: 0,
      leading: AccessibleIconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icons.arrow_back,
        semanticLabel: SemanticLabels.back,
        tooltip: l10n.back,
      ),
      title: Semantics(
        header: true,
        child: Text(
          'Schedules',  // TODO: Add to localization
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      actions: [
        AccessibleIconButton(
          onPressed: _isLoading ? null : _loadSchedules,
          icon: Icons.refresh,
          semanticLabel: SemanticLabels.refresh,
          tooltip: l10n.refresh,
          loading: _isLoading,
        ),
        AccessibleIconButton(
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: Icons.settings,
          semanticLabel: SemanticLabels.settings,
          tooltip: l10n.settings,
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    ResponsiveInfo info,
  ) {
    // Handle loading state
    if (_isLoading && _schedules.isEmpty) {
      return const LoadingWidget(
        type: LoadingType.shimmer,
        message: 'Loading schedules...',
      );
    }

    // Handle error state
    if (_error != null && _schedules.isEmpty) {
      return app_error.AppErrorWidget.network(
        onRetry: _loadSchedules,
        customMessage: _error,
      );
    }

    // Handle empty state
    if (_schedules.isEmpty) {
      return EmptyStateWidget.noSchedules(
        onCreateSchedule: () => _navigateToCreateSchedule(),
      );
    }

    // Show schedules list
    return ResponsivePadding.symmetric(
      mobileHorizontal: AppSpacing.md.w,
      mobileVertical: AppSpacing.md.h,
      tabletHorizontal: AppSpacing.xl.w,
      desktopHorizontal: AppSpacing.xxl.w,
      child: _buildSchedulesList(context, l10n, info),
    );
  }

  Widget _buildSchedulesList(
    BuildContext context,
    AppLocalizations l10n,
    ResponsiveInfo info,
  ) {
    return ListView.separated(
      itemCount: _schedules.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md.h),
      itemBuilder: (context, index) {
        final schedule = _schedules[index];
        return _ScheduleCard(
          schedule: schedule,
          isSelected: _selectedSchedule?.id == schedule.id,
          onTap: () => setState(() => _selectedSchedule = schedule),
          onEdit: () => _navigateToEditSchedule(schedule),
          onDelete: () => _deleteSchedule(schedule),
          onToggle: (value) => _toggleSchedule(schedule, value),
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context, AppLocalizations l10n) {
    return AccessibleFAB(
      onPressed: _navigateToCreateSchedule,
      semanticLabel: 'Create new schedule',
      tooltip: 'Add Schedule',
      child: Icon(Icons.add, size: 24.sp),
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

  Future<void> _toggleSchedule(Schedule schedule, bool value) async {
    setState(() {
      schedule.isActive = value;
    });

    final message = value
        ? 'Schedule "${schedule.name}" activated'
        : 'Schedule "${schedule.name}" deactivated';

    AppToast.show(
      context,
      message: message,
      icon: value ? Icons.check_circle : Icons.cancel,
      position: ToastPosition.bottom,
    );

    AccessibilityUtils.announce(message);
  }
}

/// Schedule card widget with accessibility
class _ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const _ScheduleCard({
    required this.schedule,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _buildSemanticLabel(),
      hint: 'Double tap to select, triple tap for options',
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AccessibilityUtils.hapticFeedback(HapticType.selection);
            onTap();
          },
          borderRadius: BorderRadius.circular(AppSpacing.md.r),
          child: Container(
            padding: EdgeInsets.all(AppSpacing.md.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                  : AppTheme.cardDark,
              borderRadius: BorderRadius.circular(AppSpacing.md.r),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : AppTheme.cardDark,
                width: 2,
              ),
            ),
            child: ResponsiveBuilder(
              builder: (context, info) {
                if (info.isMobile) {
                  return _buildMobileLayout(context);
                } else {
                  return _buildTabletLayout(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    '${schedule.time} • ${schedule.days.join(', ')}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _buildToggleSwitch(context),
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTemperatureInfo(context),
            _buildActionButtons(context),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                '${schedule.time} • ${schedule.days.join(', ')}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildTemperatureInfo(context),
        ),
        _buildActionButtons(context),
        SizedBox(width: AppSpacing.md.w),
        _buildToggleSwitch(context),
      ],
    );
  }

  Widget _buildTemperatureInfo(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.thermostat,
          size: 20.sp,
          color: AppTheme.primaryOrange,
        ),
        SizedBox(width: AppSpacing.xs.w),
        Text(
          '${schedule.temperature}°C',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(width: AppSpacing.sm.w),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xs.w,
            vertical: AppSpacing.xxs.h,
          ),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSpacing.xs.r),
          ),
          child: Text(
            schedule.mode,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.primaryOrange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AccessibleIconButton(
          onPressed: onEdit,
          icon: Icons.edit,
          semanticLabel: 'Edit ${schedule.name}',
          tooltip: 'Edit',
          size: 20.sp,
          minTouchTarget: 44,
        ),
        AccessibleIconButton(
          onPressed: onDelete,
          icon: Icons.delete,
          semanticLabel: 'Delete ${schedule.name}',
          tooltip: 'Delete',
          size: 20.sp,
          color: AppTheme.error,
          minTouchTarget: 44,
        ),
      ],
    );
  }

  Widget _buildToggleSwitch(BuildContext context) {
    return Semantics(
      label: schedule.isActive ? 'Schedule active' : 'Schedule inactive',
      hint: 'Double tap to toggle',
      toggled: schedule.isActive,
      child: Switch(
        value: schedule.isActive,
        onChanged: onToggle,
        activeThumbColor: AppTheme.primaryOrange,
        inactiveThumbColor: AppTheme.textSecondary,
        inactiveTrackColor: AppTheme.cardDark,
      ),
    );
  }

  String _buildSemanticLabel() {
    final status = schedule.isActive ? 'active' : 'inactive';
    return 'Schedule ${schedule.name}, ${schedule.time}, '
        '${schedule.days.join(', ')}, ${schedule.temperature} degrees Celsius, '
        '${schedule.mode} mode, currently $status';
  }
}

/// Accessible confirmation dialog
class _AccessibleConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  const _AccessibleConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cardDark,
      title: Semantics(
        header: true,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppTheme.textSecondary,
        ),
      ),
      actions: [
        AccessibleButton.text(
          onPressed: () => Navigator.pop(context, false),
          text: cancelLabel,
          textStyle: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        AccessibleButton(
          onPressed: () => Navigator.pop(context, true),
          type: ButtonType.text,
          semanticLabel: confirmLabel,
          child: Text(
            confirmLabel,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Schedule model
class Schedule {
  final String id;
  final String name;
  final String time;
  final List<String> days;
  final double temperature;
  final String mode;
  bool isActive;

  Schedule({
    required this.id,
    required this.name,
    required this.time,
    required this.days,
    required this.temperature,
    required this.mode,
    required this.isActive,
  });
}