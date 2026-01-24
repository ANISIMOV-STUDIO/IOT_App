/// Breez Time Picker - кастомный выбор времени в стиле приложения
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _TimePickerConstants {
  static const double dialogWidth = 280;
  static const double wheelHeight = 150;
  static const double itemExtent = 50;
  static const double selectedFontSize = 32;
  static const double unselectedFontSize = 20;
  static const double colonFontSize = 32;
  static const double separatorPadding = 2; // Микро-отступ для разделителей
}

// =============================================================================
// PUBLIC API
// =============================================================================

/// Показать кастомный time picker в стиле Breez
Future<TimeOfDay?> showBreezTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) => showDialog<TimeOfDay>(
    context: context,
    builder: (context) => _BreezTimePickerDialog(initialTime: initialTime),
  );

/// Показать кастомный date-time picker в стиле Breez
Future<DateTime?> showBreezDateTimePicker({
  required BuildContext context,
  required DateTime initialDateTime,
}) => showDialog<DateTime>(
    context: context,
    builder: (context) => _BreezDateTimePickerDialog(initialDateTime: initialDateTime),
  );

// =============================================================================
// DIALOG
// =============================================================================

class _BreezTimePickerDialog extends StatefulWidget {

  const _BreezTimePickerDialog({required this.initialTime});
  final TimeOfDay initialTime;

  @override
  State<_BreezTimePickerDialog> createState() => _BreezTimePickerDialogState();
}

class _BreezTimePickerDialogState extends State<_BreezTimePickerDialog> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop(TimeOfDay(hour: _selectedHour, minute: _selectedMinute));
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: colors.border),
      ),
      child: Container(
        width: _TimePickerConstants.dialogWidth,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              l10n.selectTime,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: FontWeight.w500,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Time wheels
            SizedBox(
              height: _TimePickerConstants.wheelHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hours wheel
                  SizedBox(
                    width: 80,
                    child: _TimeWheel(
                      controller: _hourController,
                      itemCount: 24,
                      onChanged: (value) {
                        setState(() => _selectedHour = value);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),

                  // Colon separator
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: _TimePickerConstants.colonFontSize,
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                  ),

                  // Minutes wheel
                  SizedBox(
                    width: 80,
                    child: _TimeWheel(
                      controller: _minuteController,
                      itemCount: 60,
                      onChanged: (value) {
                        setState(() => _selectedMinute = value);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: l10n.cancel,
                    onTap: _onCancel,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _DialogButton(
                    label: l10n.confirm,
                    isPrimary: true,
                    onTap: _onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TIME WHEEL
// =============================================================================

class _TimeWheel extends StatelessWidget {

  const _TimeWheel({
    required this.controller,
    required this.itemCount,
    required this.onChanged,
  });
  final FixedExtentScrollController controller;
  final int itemCount;
  final ValueChanged<int> onChanged;

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final delta = event.scrollDelta.dy > 0 ? 1 : -1;
      final newIndex = controller.selectedItem + delta;
      controller.animateToItem(
        newIndex,
        duration: AppDurations.instant,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    // Создаём список элементов для looping
    final children = List.generate(
      itemCount,
      (index) => _LoopingWheelItem(
        value: index,
        itemCount: itemCount,
        controller: controller,
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Listener(
        onPointerSignal: _handlePointerSignal,
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: _TimePickerConstants.itemExtent,
                perspective: 0.005,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) => onChanged(index % itemCount),
                childDelegate: ListWheelChildLoopingListDelegate(children: children),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.card,
                        colors.card.withValues(alpha: 0),
                        colors.card.withValues(alpha: 0),
                        colors.card,
                      ],
                      stops: const [0.0, 0.25, 0.75, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoopingWheelItem extends StatelessWidget {

  const _LoopingWheelItem({
    required this.value,
    required this.itemCount,
    required this.controller,
  });
  final int value;
  final int itemCount;
  final FixedExtentScrollController controller;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Проверяем выбранный элемент с защитой от null minScrollExtent
        bool selected;
        try {
          selected = controller.hasClients &&
              (controller.selectedItem % itemCount) == value;
        } catch (_) {
          selected = value == controller.initialItem;
        }

        return Container(
          alignment: Alignment.center,
          decoration: selected
              ? BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3),
                  ),
                )
              : null,
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: selected
                  ? _TimePickerConstants.selectedFontSize
                  : _TimePickerConstants.unselectedFontSize,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? AppColors.accent : colors.textMuted,
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// DATE-TIME PICKER DIALOG
// =============================================================================

class _BreezDateTimePickerDialog extends StatefulWidget {

  const _BreezDateTimePickerDialog({required this.initialDateTime});
  final DateTime initialDateTime;

  @override
  State<_BreezDateTimePickerDialog> createState() => _BreezDateTimePickerDialogState();
}

class _BreezDateTimePickerDialogState extends State<_BreezDateTimePickerDialog> {
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;
  late int _selectedHour;
  late int _selectedMinute;

  static const int _startYear = 2020;
  static const int _endYear = 2035;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDateTime.day;
    _selectedMonth = widget.initialDateTime.month;
    _selectedYear = widget.initialDateTime.year;
    _selectedHour = widget.initialDateTime.hour;
    _selectedMinute = widget.initialDateTime.minute;

    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
    _monthController = FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _yearController = FixedExtentScrollController(initialItem: _selectedYear - _startYear);
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  /// Автокоррекция дня если он превышает максимум для месяца
  void _validateAndCorrectDay() {
    final maxDay = _daysInMonth(_selectedYear, _selectedMonth);
    if (_selectedDay > maxDay) {
      _selectedDay = maxDay;
      // Анимируем колесо дней к корректному значению после завершения текущего кадра
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _dayController.animateToItem(
            _selectedDay - 1,
            duration: AppDurations.normal,
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _onConfirm() {
    HapticFeedback.lightImpact();
    // Корректируем день если он больше максимального для месяца
    final maxDay = _daysInMonth(_selectedYear, _selectedMonth);
    final day = _selectedDay > maxDay ? maxDay : _selectedDay;
    Navigator.of(context).pop(DateTime(
      _selectedYear,
      _selectedMonth,
      day,
      _selectedHour,
      _selectedMinute,
    ));
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: colors.border),
      ),
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              l10n.setDateTime,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: FontWeight.w500,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),

            // Date wheels (Day / Month / Year)
            SizedBox(
              height: _TimePickerConstants.wheelHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Day
                  SizedBox(
                    width: 55,
                    child: _DateWheel(
                      controller: _dayController,
                      itemCount: 31,
                      startValue: 1,
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value + 1;
                          _validateAndCorrectDay();
                        });
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _TimePickerConstants.separatorPadding),
                    child: Text('.', style: TextStyle(
                      fontSize: _TimePickerConstants.colonFontSize,
                      fontWeight: FontWeight.w700,
                      color: colors.text,
                    )),
                  ),
                  // Month
                  SizedBox(
                    width: 55,
                    child: _DateWheel(
                      controller: _monthController,
                      itemCount: 12,
                      startValue: 1,
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value + 1;
                          _validateAndCorrectDay();
                        });
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _TimePickerConstants.separatorPadding),
                    child: Text('.', style: TextStyle(
                      fontSize: _TimePickerConstants.colonFontSize,
                      fontWeight: FontWeight.w700,
                      color: colors.text,
                    )),
                  ),
                  // Year
                  SizedBox(
                    width: 70,
                    child: _DateWheel(
                      controller: _yearController,
                      itemCount: _endYear - _startYear + 1,
                      startValue: _startYear,
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = _startYear + value;
                          _validateAndCorrectDay();
                        });
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxs),

            // Time wheels (Hour : Minute)
            SizedBox(
              height: _TimePickerConstants.wheelHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: _TimeWheel(
                      controller: _hourController,
                      itemCount: 24,
                      onChanged: (value) {
                        setState(() => _selectedHour = value);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: Text(':', style: TextStyle(
                      fontSize: _TimePickerConstants.colonFontSize,
                      fontWeight: FontWeight.w700,
                      color: colors.text,
                    )),
                  ),
                  SizedBox(
                    width: 80,
                    child: _TimeWheel(
                      controller: _minuteController,
                      itemCount: 60,
                      onChanged: (value) {
                        setState(() => _selectedMinute = value);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: l10n.cancel,
                    onTap: _onCancel,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _DialogButton(
                    label: l10n.confirm,
                    isPrimary: true,
                    onTap: _onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DATE WHEEL
// =============================================================================

class _DateWheel extends StatelessWidget {

  const _DateWheel({
    required this.controller,
    required this.itemCount,
    required this.startValue,
    required this.onChanged,
  });
  final FixedExtentScrollController controller;
  final int itemCount;
  final int startValue;
  final ValueChanged<int> onChanged;

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final delta = event.scrollDelta.dy > 0 ? 1 : -1;
      final newIndex = controller.selectedItem + delta;
      controller.animateToItem(
        newIndex,
        duration: AppDurations.instant,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    // Создаём список элементов для looping
    final children = List.generate(
      itemCount,
      (index) => _LoopingDateWheelItem(
        displayValue: startValue + index,
        index: index,
        itemCount: itemCount,
        controller: controller,
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Listener(
        onPointerSignal: _handlePointerSignal,
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: _TimePickerConstants.itemExtent,
                perspective: 0.005,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) => onChanged(index % itemCount),
                childDelegate: ListWheelChildLoopingListDelegate(children: children),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.card,
                        colors.card.withValues(alpha: 0),
                        colors.card.withValues(alpha: 0),
                        colors.card,
                      ],
                      stops: const [0.0, 0.25, 0.75, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoopingDateWheelItem extends StatelessWidget {

  const _LoopingDateWheelItem({
    required this.displayValue,
    required this.index,
    required this.itemCount,
    required this.controller,
  });
  final int displayValue;
  final int index;
  final int itemCount;
  final FixedExtentScrollController controller;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Проверяем выбранный элемент с защитой от null minScrollExtent
        bool selected;
        try {
          selected = controller.hasClients &&
              (controller.selectedItem % itemCount) == index;
        } catch (_) {
          selected = index == controller.initialItem;
        }

        return Container(
          alignment: Alignment.center,
          decoration: selected
              ? BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3),
                  ),
                )
              : null,
          child: Text(
            displayValue.toString().padLeft(displayValue >= 100 ? 4 : 2, '0'),
            style: TextStyle(
              fontSize: selected
                  ? _TimePickerConstants.selectedFontSize - 6
                  : _TimePickerConstants.unselectedFontSize - 4,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? AppColors.accent : colors.textMuted,
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// DIALOG BUTTON
// =============================================================================

class _DialogButton extends StatelessWidget {

  const _DialogButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.accent : colors.buttonBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: FontWeight.w600,
                color: isPrimary ? AppColors.black : colors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
