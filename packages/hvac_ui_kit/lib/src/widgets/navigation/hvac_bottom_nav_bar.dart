/// HVAC Bottom Navigation Bar - Material Design 3 navigation
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Material Design 3 bottom navigation bar
///
/// Features:
/// - Material 3 NavigationBar styling
/// - Icon-only or icon+label mode
/// - Custom colors
/// - Badge support
/// - Smooth transitions
///
/// Usage:
/// ```dart
/// HvacBottomNavBar(
///   currentIndex: 0,
///   onTap: (index) => setState(() => _selectedIndex = index),
///   destinations: [
///     HvacNavDestination(
///       icon: Icons.home,
///       label: 'Home',
///     ),
///     HvacNavDestination(
///       icon: Icons.devices,
///       label: 'Devices',
///     ),
///   ],
/// )
/// ```
class HvacBottomNavBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when destination is tapped
  final ValueChanged<int> onTap;

  /// Navigation destinations
  final List<HvacNavDestination> destinations;

  /// Background color
  final Color? backgroundColor;

  /// Selected item color
  final Color? selectedItemColor;

  /// Unselected item color
  final Color? unselectedItemColor;

  /// Elevation
  final double elevation;

  /// Label behavior
  final NavigationDestinationLabelBehavior labelBehavior;

  /// Height
  final double? height;

  const HvacBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 0,
    this.labelBehavior = NavigationDestinationLabelBehavior.alwaysShow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: backgroundColor ?? HvacColors.backgroundCard,
      elevation: elevation,
      height: height ?? 80,
      labelBehavior: labelBehavior,
      destinations: destinations
          .map(
            (dest) => NavigationDestination(
              icon: Badge(
                isLabelVisible: dest.badgeCount != null && dest.badgeCount! > 0,
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
              label: dest.label,
            ),
          )
          .toList(),
      indicatorColor: selectedItemColor ?? HvacColors.primary.withValues(alpha: 0.2),
    );
  }
}

/// Navigation destination model
class HvacNavDestination {
  /// Icon data
  final IconData icon;

  /// Selected icon (optional, defaults to icon)
  final IconData? selectedIcon;

  /// Label text
  final String label;

  /// Badge count (optional)
  final int? badgeCount;

  const HvacNavDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badgeCount,
  });
}

/// Compact bottom nav bar (icons only)
///
/// Usage:
/// ```dart
/// HvacCompactBottomNavBar(
///   currentIndex: 0,
///   onTap: (index) => handleNavigation(index),
///   destinations: [
///     HvacNavDestination(icon: Icons.home, label: 'Home'),
///     HvacNavDestination(icon: Icons.settings, label: 'Settings'),
///   ],
/// )
/// ```
class HvacCompactBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<HvacNavDestination> destinations;

  const HvacCompactBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return HvacBottomNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      destinations: destinations,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      height: 64,
    );
  }
}

/// Classic bottom nav bar (BottomNavigationBar style)
///
/// Usage:
/// ```dart
/// HvacClassicBottomNavBar(
///   currentIndex: 0,
///   onTap: (index) => handleNavigation(index),
///   items: [
///     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
///     BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Devices'),
///   ],
/// )
/// ```
class HvacClassicBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const HvacClassicBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      backgroundColor: backgroundColor ?? HvacColors.backgroundCard,
      selectedItemColor: selectedItemColor ?? HvacColors.primary,
      unselectedItemColor: unselectedItemColor ?? HvacColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
    );
  }
}
