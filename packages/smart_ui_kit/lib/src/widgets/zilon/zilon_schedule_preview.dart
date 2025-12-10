import 'package:flutter/material.dart';
import '../../theme/tokens/app_typography.dart';
import '../smart/smart_card.dart';

class ZilonSchedulePreview extends StatelessWidget {
  const ZilonSchedulePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Schedule', style: AppTypography.displayMedium.copyWith(fontSize: 18, color: theme.colorScheme.onSurface)),
              Icon(Icons.calendar_month, color: theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: 24),
          _buildTimelineItem(context, '07:00', 'Wake Up', '22°C', true),
          _buildTimelineItem(context, '09:00', 'Away', '18°C', false),
          _buildTimelineItem(context, '18:00', 'Home', '21°C', false),
          _buildTimelineItem(context, '22:00', 'Sleep', '19°C', false, isLast: true),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String time, String event, String temp, bool isActive, {bool isLast = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive ? colorScheme.primary : colorScheme.outline,
                shape: BoxShape.circle,
                border: isActive ? null : Border.all(color: colorScheme.outline, width: 2),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: colorScheme.outline.withAlpha(128),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Text(time, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event, style: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurface)),
                      Text(temp, style: AppTypography.labelSmall),
                    ],
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Active', style: AppTypography.labelSmall.copyWith(color: colorScheme.primary, fontSize: 10)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
