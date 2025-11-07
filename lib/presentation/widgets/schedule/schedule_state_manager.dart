/// Schedule state management helper
///
/// Encapsulates schedule CRUD operations and state updates
library;

import 'package:flutter/material.dart';
import '../common/app_snackbar.dart';
import 'schedule_model.dart';
import 'schedule_dialogs.dart';

class ScheduleStateManager {
  /// Load schedules from API or mock data
  static Future<List<Schedule>> loadSchedules() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      final schedules = [
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

      return schedules;
    } catch (e) {
      throw Exception(
          'Failed to load schedules. Please check your connection.');
    }
  }

  /// Delete a schedule with confirmation
  static Future<bool> deleteSchedule(
    BuildContext context,
    Schedule schedule,
  ) async {
    final confirmed = await ScheduleConfirmDialog.showDeleteConfirmation(
      context,
      scheduleName: schedule.name,
    );

    if (!confirmed || !context.mounted) return false;

    final loadingController = AppSnackBar.showLoading(
      context,
      message: 'Deleting schedule...',
    );

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      loadingController.close();

      if (!context.mounted) return false;

      AppSnackBar.showSuccess(
        context,
        message: 'Schedule deleted successfully',
      );

      return true;
    } catch (e) {
      loadingController.close();

      if (!context.mounted) return false;

      AppSnackBar.showError(
        context,
        message: 'Failed to delete schedule',
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => deleteSchedule(context, schedule),
        ),
      );
      return false;
    }
  }

  /// Toggle schedule active state
  static void toggleSchedule(
    BuildContext context,
    Schedule schedule,
    bool value,
  ) {
    schedule.isActive = value;

    final message = value
        ? 'Schedule "${schedule.name}" activated'
        : 'Schedule "${schedule.name}" deactivated';

    AppToast.show(
      context,
      message: message,
      icon: value ? Icons.check_circle : Icons.cancel,
      position: ToastPosition.bottom,
    );
  }
}
