/// HVAC Navigation Rail - Material Design 3 navigation for tablet/desktop
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

/// Material Design 3 navigation rail for tablet/desktop
///
/// Features:
/// - Vertical navigation
/// - Extended mode with labels
/// - Leading/trailing widgets
/// - Material 3 styling
///
/// Usage:
/// ```dart
/// HvacNavigationRail(
///   selectedIndex: 0,
///   onDestinationSelected: (index) => navigate(index),
///   destinations: [
///     HvacRailDestination(icon: Icons.home, label: 'Home'),
///     HvacRailDestination(icon: Icons.devices, label: 'Devices'),
///   ],
/// )
/// ```
class HvacNavigationRail extends StatelessWidget {
  /// Current selected index
  final int selectedIndex;

  /// Selection callback
  final ValueChanged<int> onDestinationSelected;

  /// Destinations
  final List<HvacRailDestination> destinations;

  /// Extended mode (show labels always)
  final bool extended;

  /// Leading widget (typically logo or profile)
  final Widget? leading;

  /// Trailing widget (typically settings)
  final Widget? trailing;

  /// Background color
  final Color? backgroundColor;

  /// Selected item color
  final Color? selectedItemColor;

  /// Unselected item color
  final Color? unselectedItemColor;

  /// Label type
  final NavigationRailLabelType? labelType;

  const HvacNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.extended = false,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.labelType,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      leading: leading,
      trailing: trailing,
      backgroundColor: backgroundColor ?? HvacColors.backgroundCard,
      selectedIconTheme: IconThemeData(
        color: selectedItemColor ?? HvacColors.primary,
      ),
      unselectedIconTheme: IconThemeData(
        color: unselectedItemColor ?? HvacColors.textSecondary,
      ),
      selectedLabelTextStyle: TextStyle(
        color: selectedItemColor ?? HvacColors.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: unselectedItemColor ?? HvacColors.textSecondary,
      ),
      labelType: labelType ??
          (extended
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.all),
      destinations: destinations
          .map(
            (dest) => NavigationRailDestination(
              icon: Badge(
                isLabelVisible:
                    dest.badgeCount != null && dest.badgeCount! > 0,
                label: dest.badgeCount != null
                    ? Text(dest.badgeCount.toString())
                    : null,
                child: Icon(dest.icon),
              ),
              selectedIcon: dest.selectedIcon != null
                  ? Badge(
                      isLabelVisible:
                          dest.badgeCount != null && dest.badgeCount! > 0,
                      label: dest.badgeCount != null
                          ? Text(dest.badgeCount.toString())
                          : null,
                      child: Icon(dest.selectedIcon),
                    )
                  : null,
              label: Text(dest.label),
              padding: const EdgeInsets.symmetric(vertical: HvacSpacing.xs),
            ),
          )
          .toList(),
    );
  }
}

/// Navigation rail destination model
class HvacRailDestination {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final int? badgeCount;

  const HvacRailDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badgeCount,
  });
}

/// Compact navigation rail (icons only)
///
/// Usage:
/// ```dart
/// HvacCompactNavigationRail(
///   selectedIndex: 0,
///   onDestinationSelected: (index) => navigate(index),
///   destinations: [
///     HvacRailDestination(icon: Icons.home, label: 'Home'),
///   ],
/// )
/// ```
class HvacCompactNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<HvacRailDestination> destinations;
  final Widget? leading;
  final Widget? trailing;

  const HvacCompactNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return HvacNavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
      leading: leading,
      trailing: trailing,
      labelType: NavigationRailLabelType.none,
    );
  }
}
