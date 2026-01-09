/// Desktop Header - Header with unit tabs for desktop layout
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez_logo.dart';
import '../../../widgets/breez/breez_card.dart';
import '../../../widgets/breez/unit_tab_button.dart';
import 'add_unit_button.dart';

/// Desktop header with unit tabs
class DesktopHeader extends StatelessWidget {
  final List<UnitState> units;
  final int selectedUnitIndex;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onAddUnit;
  final bool isDark;
  final VoidCallback? onThemeToggle;
  final bool showMenuButton;
  final VoidCallback? onMenuTap;
  final bool showLogo;
  final VoidCallback? onNotificationsTap;
  final int unreadNotificationsCount;

  const DesktopHeader({
    super.key,
    required this.units,
    required this.selectedUnitIndex,
    this.onUnitSelected,
    this.onAddUnit,
    required this.isDark,
    this.onThemeToggle,
    this.showMenuButton = false,
    this.onMenuTap,
    this.showLogo = false,
    this.onNotificationsTap,
    this.unreadNotificationsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Menu button (tablet only)
        if (showMenuButton) ...[
          BreezIconButton(
            icon: Icons.menu,
            onTap: onMenuTap,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        // Unit tabs (with logo inside if requested)
        Expanded(child: _buildUnitTabs(context)),
        const SizedBox(width: AppSpacing.xs),
        // Theme toggle
        BreezIconButton(
          icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          onTap: onThemeToggle,
        ),
        const SizedBox(width: AppSpacing.xs),
        // Notifications
        BreezIconButton(
          icon: Icons.notifications_outlined,
          badge: unreadNotificationsCount > 0 ? '$unreadNotificationsCount' : null,
          onTap: onNotificationsTap,
        ),
      ],
    );
  }

  Widget _buildUnitTabs(BuildContext context) {
    return UnitTabsContainer(
      units: units,
      selectedIndex: selectedUnitIndex,
      onUnitSelected: onUnitSelected,
      leading: showLogo ? const BreezLogo.small() : null,
      trailing: AddUnitButton(onTap: onAddUnit),
    );
  }
}
