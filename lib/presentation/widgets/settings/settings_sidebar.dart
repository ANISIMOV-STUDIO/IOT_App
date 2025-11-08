/// Settings Sidebar Navigation
///
/// Desktop sidebar menu for settings navigation
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Settings sidebar navigation for desktop layout
class SettingsSidebar extends StatelessWidget {
  final int selectedSection;
  final ValueChanged<int> onSectionSelected;

  const SettingsSidebar({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final menuItems = [
      (Icons.palette_outlined, l10n.appearance, 0),
      (Icons.straighten_outlined, l10n.units, 1),
      (Icons.notifications_outlined, l10n.notifications, 2),
      (Icons.language_outlined, l10n.language, 3),
      (Icons.info_outline, l10n.about, 4),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _SettingsSidebarItem(
          icon: item.$1,
          label: item.$2,
          index: item.$3,
          isSelected: selectedSection == item.$3,
          onTap: () => onSectionSelected(item.$3),
        );
      },
    );
  }
}

/// Individual sidebar menu item
class _SettingsSidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _SettingsSidebarItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? HvacColors.primaryOrange.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? HvacColors.primaryOrange
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? HvacColors.primaryOrange
                  : HvacColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: HvacTypography.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? HvacColors.primaryOrange
                      : HvacColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
