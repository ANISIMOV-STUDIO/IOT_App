/// Maintenance Card Widget
///
/// Displays maintenance information and filter status
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class OverviewMaintenanceCard extends StatelessWidget {
  const OverviewMaintenanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.build, color: HvacColors.warning, size: 20.0),
              const SizedBox(width: 12.0),
              Text(
                'Обслуживание',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.0,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const _MaintenanceItem(
            label: 'Последнее обслуживание',
            value: '15 дней назад',
          ),
          const SizedBox(height: 8.0),
          const _MaintenanceItem(
            label: 'Фильтр приточный',
            value: '70% ресурса',
          ),
          const SizedBox(height: 8.0),
          const _MaintenanceItem(
            label: 'Фильтр вытяжной',
            value: '85% ресурса',
          ),
          const SizedBox(height: 8.0),
          const _MaintenanceItem(
            label: 'Следующее ТО',
            value: 'через 45 дней',
          ),
        ],
      ),
    );
  }
}

class _MaintenanceItem extends StatelessWidget {
  final String label;
  final String value;

  const _MaintenanceItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: HvacTypography.bodySmall.copyWith(
            fontSize: 13.0,
            color: HvacColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: HvacTypography.bodySmall.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
