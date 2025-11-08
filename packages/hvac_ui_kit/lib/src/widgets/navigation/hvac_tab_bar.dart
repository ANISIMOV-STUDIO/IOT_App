/// HVAC Tab Bar - Material Design 3 tabs
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

/// Material Design 3 tab bar
///
/// Features:
/// - Material 3 styling
/// - Custom indicator
/// - Icon support
/// - Badge support
/// - Scrollable tabs
///
/// Usage:
/// ```dart
/// HvacTabBar(
///   controller: _tabController,
///   tabs: ['Overview', 'Details', 'Settings'],
/// )
/// ```
class HvacTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Tab labels (String or Widget)
  final List<dynamic> tabs;

  /// Tab controller
  final TabController? controller;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Indicator color
  final Color? indicatorColor;

  /// Label color
  final Color? labelColor;

  /// Unselected label color
  final Color? unselectedLabelColor;

  /// Label style
  final TextStyle? labelStyle;

  /// Unselected label style
  final TextStyle? unselectedLabelStyle;

  /// Indicator weight
  final double indicatorWeight;

  /// Indicator padding
  final EdgeInsets? indicatorPadding;

  /// Tab padding
  final EdgeInsets? labelPadding;

  /// On tap callback
  final ValueChanged<int>? onTap;

  const HvacTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.indicatorWeight = 3.0,
    this.indicatorPadding,
    this.labelPadding,
    this.onTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabWidgets = tabs.map((tab) {
      if (tab is String) {
        return Tab(text: tab);
      } else if (tab is Widget) {
        return Tab(child: tab);
      } else {
        throw ArgumentError('Tab must be String or Widget');
      }
    }).toList();

    return TabBar(
      controller: controller,
      tabs: tabWidgets,
      isScrollable: isScrollable,
      indicatorColor: indicatorColor ?? HvacColors.primary,
      labelColor: labelColor ?? HvacColors.primary,
      unselectedLabelColor:
          unselectedLabelColor ?? HvacColors.textSecondary,
      labelStyle: labelStyle ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
      unselectedLabelStyle: unselectedLabelStyle ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      indicatorWeight: indicatorWeight,
      indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
      labelPadding: labelPadding ??
          const EdgeInsets.symmetric(horizontal: HvacSpacing.md),
      onTap: onTap,
    );
  }
}

/// Tab bar with icons
///
/// Usage:
/// ```dart
/// HvacIconTabBar(
///   controller: _tabController,
///   tabs: [
///     HvacIconTab(icon: Icons.home, label: 'Home'),
///     HvacIconTab(icon: Icons.settings, label: 'Settings'),
///   ],
/// )
/// ```
class HvacIconTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<HvacIconTab> tabs;
  final TabController? controller;
  final bool isScrollable;

  const HvacIconTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return HvacTabBar(
      controller: controller,
      isScrollable: isScrollable,
      tabs: tabs
          .map(
            (tab) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tab.icon, size: 24),
                const SizedBox(height: HvacSpacing.xxs),
                Text(tab.label),
              ],
            ),
          )
          .toList(),
    );
  }
}

/// Icon tab model
class HvacIconTab {
  final IconData icon;
  final String label;

  const HvacIconTab({
    required this.icon,
    required this.label,
  });
}

/// Compact tab bar (icons only)
///
/// Usage:
/// ```dart
/// HvacCompactTabBar(
///   controller: _tabController,
///   icons: [Icons.home, Icons.devices, Icons.settings],
/// )
/// ```
class HvacCompactTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<IconData> icons;
  final TabController? controller;

  const HvacCompactTabBar({
    super.key,
    required this.icons,
    this.controller,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: icons.map((icon) => Tab(icon: Icon(icon, size: 24))).toList(),
      indicatorColor: HvacColors.primary,
      labelColor: HvacColors.primary,
      unselectedLabelColor: HvacColors.textSecondary,
    );
  }
}

/// Segmented tab bar (pill style)
///
/// Usage:
/// ```dart
/// HvacSegmentedTabBar(
///   controller: _tabController,
///   tabs: ['Day', 'Week', 'Month'],
/// )
/// ```
class HvacSegmentedTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController? controller;
  final Color? backgroundColor;
  final Color? selectedColor;

  const HvacSegmentedTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.backgroundColor,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xxs),
      decoration: BoxDecoration(
        color: backgroundColor ?? HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        indicator: BoxDecoration(
          color: selectedColor ?? HvacColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: HvacColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        dividerColor: Colors.transparent,
      ),
    );
  }
}
