import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../../domain/entities/week_schedule.dart';
import '../../domain/entities/day_schedule.dart';

class ZilonScheduleScreen extends StatefulWidget {
  const ZilonScheduleScreen({super.key});

  @override
  State<ZilonScheduleScreen> createState() => _ZilonScheduleScreenState();
}

class _ZilonScheduleScreenState extends State<ZilonScheduleScreen> {
  String _selectedDay = 'Monday';
  WeekSchedule? _editingSchedule;
  bool _isDirty = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HvacListBloc, HvacListState>(
      builder: (context, state) {
        if (state is HvacListLoaded && state.units.isNotEmpty) {
          final device = state.units.first;
          
          // Initialize local schedule if needed
          if (_editingSchedule == null && device.schedule != null) {
            _editingSchedule = device.schedule;
          }
          final schedule = _editingSchedule ?? WeekSchedule.defaultSchedule;

          final isDesktop = MediaQuery.of(context).size.width > 1000;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.v24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, device.id),
                    const SizedBox(height: 24),
                    isDesktop 
                     ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildWeeklyCalendar(context, schedule)),
                          const SizedBox(width: 24),
                          Expanded(flex: 1, child: _buildDayEditor(context, schedule)),
                        ],
                       )
                     : Column(
                         children: [
                           _buildDayEditor(context, schedule),
                           const SizedBox(height: 24),
                           _buildWeeklyCalendar(context, schedule),
                         ],
                       ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildHeader(BuildContext context, String deviceId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Weekly Schedule', style: AppTypography.displayMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        SmartButton(
          label: _isDirty ? 'Save Changes' : 'Saved',
          icon: Icon(_isDirty ? Icons.save : Icons.check, size: 18, color: Colors.white), 
          onPressed: _isDirty ? () {
             if (_editingSchedule != null) {
               context.read<HvacListBloc>().add(
                 UpdateDeviceScheduleEvent(deviceId: deviceId, schedule: _editingSchedule!)
               );
               setState(() => _isDirty = false);
               
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Schedule saved successfully'))
               );
             }
          } : null,
        ),
      ],
    );
  }

  Widget _buildWeeklyCalendar(BuildContext context, WeekSchedule schedule) {
    return Column(
      children: [
        for (var day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildDayRow(context, day, schedule),
          ),
      ],
    );
  }

  Widget _buildDayRow(BuildContext context, String day, WeekSchedule schedule) {
    final theme = Theme.of(context);
    final isSelected = _selectedDay == day;
    final dayIndex = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].indexOf(day) + 1;
    final daySchedule = schedule.getDaySchedule(dayIndex);
    
    // Convert DaySchedule to TimePeriods
    List<TimePeriod> periods = [];
    if (daySchedule.timerEnabled && daySchedule.turnOnTime != null && daySchedule.turnOffTime != null) {
       periods.add(TimePeriod(
         start: _timeToDouble(daySchedule.turnOnTime!),
         end: _timeToDouble(daySchedule.turnOffTime!),
         isActive: true
       ));
    }

    return InkWell(
      onTap: () => setState(() => _selectedDay = day),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withValues(alpha:0.05) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha:0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(day, style: AppTypography.titleMedium.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface 
              )),
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: CustomPaint(
                  painter: ScheduleTimelinePainter(
                    theme: theme, 
                    periods: periods
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayEditor(BuildContext context, WeekSchedule schedule) {
    final theme = Theme.of(context);
    final dayIndex = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].indexOf(_selectedDay) + 1;
    final daySchedule = schedule.getDaySchedule(dayIndex);

    return SmartCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Edit $_selectedDay', style: AppTypography.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              Switch(
                value: daySchedule.timerEnabled, 
                onChanged: (v) => _updateDaySchedule(dayIndex, daySchedule.copyWith(timerEnabled: v))
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (daySchedule.timerEnabled) ...[
            _buildTimeInput(context, 'Turn On', daySchedule.turnOnTime, (t) => _updateDaySchedule(dayIndex, daySchedule.copyWith(turnOnTime: t))),
            const SizedBox(height: 16),
            _buildTimeInput(context, 'Turn Off', daySchedule.turnOffTime, (t) => _updateDaySchedule(dayIndex, daySchedule.copyWith(turnOffTime: t))),
          ] else 
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text('Timer is disabled for this day'),
            ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Text('Apply Preset', style: AppTypography.titleSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetTag(context, 'Workday (09-18)', () => _applyPreset(dayIndex, 9, 18)),
              _buildPresetTag(context, 'Full Day (07-23)', () => _applyPreset(dayIndex, 7, 23)),
              _buildPresetTag(context, 'Off', () => _updateDaySchedule(dayIndex, const DaySchedule(timerEnabled: false))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput(BuildContext context, String label, TimeOfDay? time, Function(TimeOfDay) onChanged) {
    final timeStr = time != null ? '${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}' : '--:--';
    
    return InkWell(
      onTap: () async {
         final picked = await showTimePicker(
           context: context, 
           initialTime: time ?? const TimeOfDay(hour: 9, minute: 0),
           builder: (context, child) {
             return Theme(data: Theme.of(context).copyWith(
               colorScheme: Theme.of(context).colorScheme, // Ensure dialog matches theme
             ), child: child!);
           }
         );
         if (picked != null) onChanged(picked);
      },
      child: Row(
        children: [
          Icon(Icons.access_time, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.labelSmall),
              Text(timeStr, style: AppTypography.titleMedium),
            ],
          ),
          const Spacer(),
          const Icon(Icons.edit_outlined, size: 20),
        ],
      ),
    );
  }
  
  Widget _buildPresetTag(BuildContext context, String label, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.secondary.withValues(alpha:  0.5)),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.onSecondaryContainer),
        ),
      ),
    );
  }

  void _updateDaySchedule(int dayIndex, DaySchedule newDaySchedule) {
      if (_editingSchedule == null) return;
      
      setState(() {
        _editingSchedule = _editingSchedule!.updateDay(dayIndex, newDaySchedule);
        _isDirty = true;
      });
  }

  void _applyPreset(int dayIndex, int startHour, int endHour) {
      _updateDaySchedule(dayIndex, DaySchedule(
        timerEnabled: true,
        turnOnTime: TimeOfDay(hour: startHour, minute: 0),
        turnOffTime: TimeOfDay(hour: endHour, minute: 0),
      ));
  }

  double _timeToDouble(TimeOfDay t) => t.hour + t.minute / 60.0;
}

class TimePeriod {
  final double start;
  final double end;
  final bool isActive;
  TimePeriod({required this.start, required this.end, required this.isActive});
}

class ScheduleTimelinePainter extends CustomPainter {
  final ThemeData theme;
  final List<TimePeriod> periods;

  ScheduleTimelinePainter({required this.theme, required this.periods});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.colorScheme.surfaceContainerHighest
      ..style = PaintingStyle.fill;
    
    const double trackHeight = 16.0;
    final double trackTop = (size.height - trackHeight) / 2;
      
    // Background track rounded
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, trackTop, size.width, trackHeight), 
      const Radius.circular(8)
    );
    canvas.drawRRect(rrect, paint);

    // Active periods
    paint.color = theme.colorScheme.primary;
    for (var period in periods) {
      final startX = (period.start / 24) * size.width;
      final endX = (period.end / 24) * size.width; // Fix: use end time
      final width = endX - startX;
      
      if (width > 0) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(startX, trackTop, width, trackHeight), 
          const Radius.circular(8)
        );
        canvas.drawRRect(rect, paint);
      }
    }
    
    // Hour Ticks
    final tickPaint = Paint()
      ..color = theme.colorScheme.onSurface.withValues(alpha:0.3)
      ..strokeWidth = 1.0;
      
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 24; i += 6) {
      final x = (i / 24) * size.width;
      // Draw tick line
      canvas.drawLine(
        Offset(x, trackTop + trackHeight), 
        Offset(x, trackTop + trackHeight + 6), 
        tickPaint
      );
      
      // Draw label
      textPainter.text = TextSpan(
        text: '$i',
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha:0.5),
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, trackTop + trackHeight + 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true; // Needs repaint on periods change
}
