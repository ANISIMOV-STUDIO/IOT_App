/// Schedule state management helper
///
/// Encapsulates schedule CRUD operations and state updates
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/services/api_service.dart';
import '../../../core/di/injection_container.dart';
import '../common/app_snackbar.dart';
import 'schedule_model.dart';
import 'schedule_dialogs.dart';

class ScheduleStateManager {
  /// Load schedules from API
  static Future<List<Schedule>> loadSchedules() async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get('/schedules');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => Schedule(
                  id: json['id'] as String,
                  name: json['name'] as String,
                  time: json['time'] as String,
                  days: List<String>.from(json['days'] as List),
                  temperature: (json['temperature'] as num).toDouble(),
                  mode: json['mode'] as String,
                  isActive: json['isActive'] as bool,
                ))
            .toList();
      } else {
        throw Exception('Failed to load schedules: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data if API fails (for development)
      return [
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
      final apiService = sl<ApiService>();
      await apiService.delete('/schedules/${schedule.id}');

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
