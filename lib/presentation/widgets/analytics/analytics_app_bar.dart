/// Analytics App Bar Widget
///
/// Custom app bar for analytics screen with period selector
/// Extracted from analytics_screen.dart to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class AnalyticsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String unitName;
  final String selectedPeriod;
  final ValueChanged<String?> onPeriodChanged;
  final VoidCallback onBack;

  const AnalyticsAppBar({
    super.key,
    required this.unitName,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return HvacAppBar(
      backgroundColor: HvacColors.backgroundCard,
      centerTitle: false,
      leading: HvacIconButton(
        icon: Icons.arrow_back,
        onPressed: onBack,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Аналитика',
            style: HvacTypography.titleMedium,
          ),
          Text(
            unitName,
            style: HvacTypography.bodySmall,
          ),
        ],
      ),
      actions: [_buildPeriodDropdown()],
    );
  }

  Widget _buildPeriodDropdown() {
    return Padding(
      padding: const EdgeInsets.only(right: HvacSpacing.mdR),
      child: DropdownButton<String>(
        value: selectedPeriod,
        dropdownColor: HvacColors.backgroundCard,
        underline: const SizedBox(),
        style: HvacTypography.labelMedium.copyWith(
          color: HvacColors.primaryOrange,
        ),
        items: ['День', 'Неделя', 'Месяц'].map((period) {
          return DropdownMenuItem(
            value: period,
            child: Text(period),
          );
        }).toList(),
        onChanged: onPeriodChanged,
      ),
    );
  }
}
