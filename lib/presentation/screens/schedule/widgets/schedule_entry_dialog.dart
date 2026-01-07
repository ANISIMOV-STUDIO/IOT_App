/// Schedule Entry Dialog - Add/Edit schedule entry
library;

import 'dart:math' show min;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../widgets/breez/schedule_widget.dart';
import 'schedule_form_widgets.dart';

/// Диалог добавления/редактирования записи расписания
class ScheduleEntryDialog extends StatefulWidget {
  final String deviceId;
  final ScheduleEntry? entry;
  final ValueChanged<ScheduleEntry> onSave;

  const ScheduleEntryDialog({
    super.key,
    required this.deviceId,
    this.entry,
    required this.onSave,
  });

  @override
  State<ScheduleEntryDialog> createState() => _ScheduleEntryDialogState();
}

class _ScheduleEntryDialogState extends State<ScheduleEntryDialog> {
  late String _selectedDay;
  late String _selectedMode;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late int _tempDay;
  late int _tempNight;
  late bool _isActive;

  bool _initialized = false;

  List<String> _getDays(AppLocalizations l10n) => [
    l10n.monday,
    l10n.tuesday,
    l10n.wednesday,
    l10n.thursday,
    l10n.friday,
    l10n.saturday,
    l10n.sunday,
  ];

  List<String> _getModes(AppLocalizations l10n) => [
    l10n.modeAuto,
    l10n.modeCooling,
    l10n.modeHeating,
    l10n.modeVentilation,
    l10n.modeEco,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      // _selectedDay и _selectedMode инициализируются в didChangeDependencies
      // когда доступна локализация
      _parseTimeRange(widget.entry!.timeRange);
      _tempDay = widget.entry!.tempDay;
      _tempNight = widget.entry!.tempNight;
      _isActive = widget.entry!.isActive;
    } else {
      _startTime = const TimeOfDay(hour: 8, minute: 0);
      _endTime = const TimeOfDay(hour: 22, minute: 0);
      _tempDay = 22;
      _tempNight = 18;
      _isActive = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final l10n = AppLocalizations.of(context)!;
      if (widget.entry != null) {
        // Конвертируем английские названия с бэкенда в локализованные
        _selectedDay = ScheduleWidget.translateDayName(widget.entry!.day, l10n);
        _selectedMode = widget.entry!.mode;
      } else {
        _selectedDay = _getDays(l10n)[0];
        _selectedMode = _getModes(l10n)[0];
      }
      _initialized = true;
    }
  }

  void _parseTimeRange(String timeRange) {
    try {
      final parts = timeRange.split(' - ');
      if (parts.length == 2) {
        _startTime = _parseTime(parts[0]);
        _endTime = _parseTime(parts[1]);
      } else {
        _setDefaultTimes();
      }
    } catch (e) {
      _setDefaultTimes();
    }
  }

  void _setDefaultTimes() {
    _startTime = const TimeOfDay(hour: 8, minute: 0);
    _endTime = const TimeOfDay(hour: 22, minute: 0);
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeRange() => '${_formatTime(_startTime)} - ${_formatTime(_endTime)}';

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    final entry = ScheduleEntry(
      id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      deviceId: widget.deviceId,
      // Конвертируем локализованное название дня обратно в английское для API
      day: ScheduleWidget.dayNameToEnglish(_selectedDay, l10n),
      mode: _selectedMode,
      timeRange: _getTimeRange(),
      tempDay: _tempDay,
      tempNight: _tempNight,
      isActive: _isActive,
    );
    widget.onSave(entry);
  }

  Future<void> _pickTime(bool isStart) async {
    final initialTime = isStart ? _startTime : _endTime;
    final picked = await showScheduleTimePicker(context, initialTime);

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = BreezColors.of(context);
    final isEditing = widget.entry != null;
    final days = _getDays(l10n);
    final modes = _getModes(l10n);
    final maxWidth = min(MediaQuery.of(context).size.width - 48, 400.0);

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Container(
        width: maxWidth,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScheduleDialogHeader(
              icon: isEditing ? Icons.edit : Icons.add,
              title: isEditing ? l10n.scheduleEditEntry : l10n.scheduleNewEntry,
            ),
            const SizedBox(height: AppSpacing.lg),

            ScheduleDropdown(
              label: l10n.scheduleDayLabel,
              value: _selectedDay,
              items: days,
              onChanged: (value) => setState(() => _selectedDay = value!),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: ScheduleTimeButton(
                    label: l10n.scheduleStartLabel,
                    time: _startTime,
                    onTap: () => _pickTime(true),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ScheduleTimeButton(
                    label: l10n.scheduleEndLabel,
                    time: _endTime,
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            ScheduleDropdown(
              label: l10n.scheduleModeLabel,
              value: _selectedMode,
              items: modes,
              onChanged: (value) => setState(() => _selectedMode = value!),
            ),
            const SizedBox(height: AppSpacing.md),

            ScheduleTemperatureSlider(
              label: l10n.scheduleDayTemp,
              value: _tempDay,
              onChanged: (value) => setState(() => _tempDay = value.round()),
            ),
            const SizedBox(height: AppSpacing.sm),
            ScheduleTemperatureSlider(
              label: l10n.scheduleNightTemp,
              value: _tempNight,
              onChanged: (value) => setState(() => _tempNight = value.round()),
            ),
            const SizedBox(height: AppSpacing.md),

            ScheduleActiveToggle(
              label: l10n.scheduleActive,
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: AppSpacing.lg),

            ScheduleDialogActions(
              cancelLabel: l10n.cancel,
              saveLabel: isEditing ? l10n.save : l10n.scheduleAdd,
              onCancel: () => Navigator.of(context).pop(),
              onSave: _save,
            ),
          ],
        ),
      ),
    );
  }
}
