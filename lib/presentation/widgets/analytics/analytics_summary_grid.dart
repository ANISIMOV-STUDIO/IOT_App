/// Analytics Summary Grid Widget
///
/// Grid layout for analytics summary cards
/// Extracted from analytics_screen.dart to respect 300-line limit
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import 'analytics_summary_card.dart';

class AnalyticsSummaryGrid extends StatelessWidget {
  const AnalyticsSummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: AnalyticsSummaryCard(
                index: 0,
                label: 'Средняя температура',
                value: '21.5°C',
                icon: Icons.thermostat,
                color: AppTheme.primaryOrange,
                change: '+0.5°C',
              ),
            ),
            SizedBox(width: AppSpacing.mdR),
            const Expanded(
              child: AnalyticsSummaryCard(
                index: 1,
                label: 'Средняя влажность',
                value: '48%',
                icon: Icons.water_drop,
                color: AppTheme.info,
                change: '-2%',
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.mdR),
        Row(
          children: [
            const Expanded(
              child: AnalyticsSummaryCard(
                index: 2,
                label: 'Время работы',
                value: '18ч 45м',
                icon: Icons.access_time,
                color: AppTheme.success,
                change: '+2ч',
              ),
            ),
            SizedBox(width: AppSpacing.mdR),
            const Expanded(
              child: AnalyticsSummaryCard(
                index: 3,
                label: 'Энергопотребление',
                value: '6.3 кВт⋅ч',
                icon: Icons.bolt,
                color: AppTheme.warning,
                change: '+0.8 кВт⋅ч',
              ),
            ),
          ],
        ),
      ],
    );
  }
}