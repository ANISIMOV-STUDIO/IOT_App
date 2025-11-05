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
    return AppBar(
      backgroundColor: HvacColors.backgroundCard,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: HvacColors.textPrimary,
          size: 24.0,
        ),
        onPressed: onBack,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Аналитика',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          Text(
            unitName,
            style: const TextStyle(
              fontSize: 12.0,
              color: HvacColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
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
        style: const TextStyle(
          color: HvacColors.primaryOrange,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
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