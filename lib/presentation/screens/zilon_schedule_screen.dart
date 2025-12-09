import 'package:flutter/material.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';
import '../../domain/entities/week_schedule.dart'; // Mock/Real entity import
import '../../domain/entities/day_schedule.dart';

class ZilonScheduleScreen extends StatefulWidget {
  const ZilonScheduleScreen({super.key});

  @override
  State<ZilonScheduleScreen> createState() => _ZilonScheduleScreenState();
}

class _ZilonScheduleScreenState extends State<ZilonScheduleScreen> {
  // Mock Schedule Data for now (or load from BLoC later)
  final WeekSchedule _schedule = WeekSchedule.defaultSchedule;
  String _selectedDay = 'Monday';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDesktop = MediaQuery.of(context).size.width > 1000;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.v24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              isDesktop 
               ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildWeeklyCalendar(context)),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildDayEditor(context)),
                  ],
                 )
               : Column(
                   children: [
                     _buildDayEditor(context), // Editor first on mobile
                     const SizedBox(height: 24),
                     _buildWeeklyCalendar(context),
                   ],
                 ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Weekly Schedule', style: AppTypography.displayMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        SmartButton(
          label: 'Save Changes',
          icon: const Icon(Icons.save, size: 18, color: Colors.white), 
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWeeklyCalendar(BuildContext context) {
    return Column(
      children: [
        for (var day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildDayRow(context, day),
          ),
      ],
    );
  }

  Widget _buildDayRow(BuildContext context, String day) {
    final theme = Theme.of(context);
    final isSelected = _selectedDay == day;
    
    return InkWell(
      onTap: () => setState(() => _selectedDay = day),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.05) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 120, // Increased from 100 to fix wrapping
              child: Text(day, style: AppTypography.titleMedium.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface 
              )),
            ),
            Expanded(
              child: SizedBox(
                height: 50, // Increased height for ticks
                child: CustomPaint(
                  painter: ScheduleTimelinePainter(
                    theme: theme, 
                    periods: [
                      // Mock periods for demo
                      TimePeriod(start: 7, end: 9, isActive: true),
                      TimePeriod(start: 18, end: 22, isActive: true),
                    ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayEditor(BuildContext context) {
    final theme = Theme.of(context);
    return SmartCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Edit $_selectedDay', style: AppTypography.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              Switch(value: true, onChanged: (v){}),
            ],
          ),
          const SizedBox(height: 24),
          _buildTimeInput(context, 'Wake Up', '07:00'),
          const SizedBox(height: 16),
          _buildTimeInput(context, 'Leave', '09:00'),
          const SizedBox(height: 16),
          _buildTimeInput(context, 'Return', '18:00'),
          const SizedBox(height: 16),
          _buildTimeInput(context, 'Sleep', '22:00'),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Text('Presets', style: AppTypography.titleSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetTag(context, 'Workday'),
              _buildPresetTag(context, 'Weekend'),
              _buildPresetTag(context, 'Holiday'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput(BuildContext context, String label, String time) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.labelSmall),
            Text(time, style: AppTypography.titleMedium),
          ],
        ),
        const Spacer(),
        IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: (){}),
      ],
    );
  }

  Widget _buildPresetTag(BuildContext context, String label) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.5)),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.onSecondaryContainer),
        ),
      ),
    );
  }
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
      final endX = (period.end / 24) * size.width;
      final width = endX - startX;
      
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(startX, trackTop, width, trackHeight), 
        const Radius.circular(8)
      );
      canvas.drawRRect(rect, paint);
    }
    
    // Hour Ticks
    final tickPaint = Paint()
      ..color = theme.colorScheme.onSurface.withOpacity(0.3)
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
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, trackTop + trackHeight + 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
