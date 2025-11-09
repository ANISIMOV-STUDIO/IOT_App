/// HVAC Date Picker - Material Design 3 date pickers
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Date picker dialog
///
/// Usage:
/// ```dart
/// HvacDatePicker.show(
///   context: context,
///   selectedDate: DateTime.now(),
///   onDateSelected: (date) => setState(() => _selectedDate = date),
/// )
/// ```
class HvacDatePicker {
  /// Show date picker dialog
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? selectedDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    final DateTime initialDate = selectedDate ?? DateTime.now();
    final DateTime first = firstDate ?? DateTime(2000);
    final DateTime last = lastDate ?? DateTime(2100);

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: first,
      lastDate: last,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: HvacColors.primary,
              onPrimary: Colors.white,
              surface: HvacColors.backgroundCard,
              onSurface: HvacColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: HvacRadius.lgRadius,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

/// Date picker field with icon
///
/// Usage:
/// ```dart
/// HvacDatePickerField(
///   label: 'Select Date',
///   selectedDate: DateTime.now(),
///   onDateSelected: (date) => print(date),
/// )
/// ```
class HvacDatePickerField extends StatelessWidget {
  /// Label text
  final String label;

  /// Selected date
  final DateTime? selectedDate;

  /// Date selected callback
  final ValueChanged<DateTime>? onDateSelected;

  /// First selectable date
  final DateTime? firstDate;

  /// Last selectable date
  final DateTime? lastDate;

  /// Icon
  final IconData icon;

  /// Date format callback
  final String Function(DateTime)? dateFormat;

  const HvacDatePickerField({
    super.key,
    required this.label,
    this.selectedDate,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.icon = Icons.calendar_today,
    this.dateFormat,
  });

  String _formatDate(DateTime date) {
    if (dateFormat != null) {
      return dateFormat!(date);
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await HvacDatePicker.show(
      context: context,
      selectedDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && onDateSelected != null) {
      onDateSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: HvacRadius.lgRadius,
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.md),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: HvacRadius.lgRadius,
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: HvacColors.textSecondary),
            const SizedBox(width: HvacSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: HvacColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: HvacSpacing.xxs),
                  Text(
                    selectedDate != null
                        ? _formatDate(selectedDate!)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate != null
                          ? HvacColors.textPrimary
                          : HvacColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: HvacColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Date range picker
///
/// Usage:
/// ```dart
/// HvacDateRangePicker.show(
///   context: context,
///   initialRange: DateTimeRange(
///     start: DateTime.now(),
///     end: DateTime.now().add(Duration(days: 7)),
///   ),
///   onRangeSelected: (range) => print(range),
/// )
/// ```
class HvacDateRangePicker {
  /// Show date range picker dialog
  static Future<DateTimeRange?> show({
    required BuildContext context,
    DateTimeRange? initialRange,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    final DateTime first = firstDate ?? DateTime(2000);
    final DateTime last = lastDate ?? DateTime(2100);

    return await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: first,
      lastDate: last,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: HvacColors.primary,
              onPrimary: Colors.white,
              surface: HvacColors.backgroundCard,
              onSurface: HvacColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: HvacRadius.lgRadius,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

/// Date range picker field
///
/// Usage:
/// ```dart
/// HvacDateRangePickerField(
///   label: 'Select Date Range',
///   selectedRange: DateTimeRange(start: ..., end: ...),
///   onRangeSelected: (range) => print(range),
/// )
/// ```
class HvacDateRangePickerField extends StatelessWidget {
  final String label;
  final DateTimeRange? selectedRange;
  final ValueChanged<DateTimeRange>? onRangeSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String Function(DateTime)? dateFormat;

  const HvacDateRangePickerField({
    super.key,
    required this.label,
    this.selectedRange,
    this.onRangeSelected,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
  });

  String _formatDate(DateTime date) {
    if (dateFormat != null) {
      return dateFormat!(date);
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectRange(BuildContext context) async {
    final DateTimeRange? picked = await HvacDateRangePicker.show(
      context: context,
      initialRange: selectedRange,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && onRangeSelected != null) {
      onRangeSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectRange(context),
      borderRadius: HvacRadius.lgRadius,
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.md),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: HvacRadius.lgRadius,
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.date_range,
              color: HvacColors.textSecondary,
            ),
            const SizedBox(width: HvacSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: HvacColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: HvacSpacing.xxs),
                  Text(
                    selectedRange != null
                        ? '${_formatDate(selectedRange!.start)} - ${_formatDate(selectedRange!.end)}'
                        : 'Select date range',
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedRange != null
                          ? HvacColors.textPrimary
                          : HvacColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: HvacColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
