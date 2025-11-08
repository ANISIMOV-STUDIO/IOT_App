/// HVAC Drawer - Material Design 3 navigation drawer
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Material Design 3 navigation drawer
///
/// Features:
/// - Custom header
/// - Grouped items
/// - Selected state
/// - Material 3 styling
///
/// Usage:
/// ```dart
/// HvacDrawer(
///   header: DrawerHeader(child: Text('App Name')),
///   children: [
///     HvacDrawerItem(
///       icon: Icons.home,
///       label: 'Home',
///       onTap: () => navigate('/home'),
///     ),
///   ],
/// )
/// ```
class HvacDrawer extends StatelessWidget {
  /// Drawer header widget
  final Widget? header;

  /// Drawer items
  final List<Widget> children;

  /// Background color
  final Color? backgroundColor;

  /// Width
  final double? width;

  /// Elevation
  final double elevation;

  const HvacDrawer({
    super.key,
    this.header,
    required this.children,
    this.backgroundColor,
    this.width,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor ?? HvacColors.backgroundDark,
      width: width ?? 304,
      elevation: elevation,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (header != null) header!,
          ...children,
        ],
      ),
    );
  }
}

/// Navigation drawer item
///
/// Usage:
/// ```dart
/// HvacDrawerItem(
///   icon: Icons.settings,
///   label: 'Settings',
///   selected: true,
///   onTap: () => navigate('/settings'),
/// )
/// ```
class HvacDrawerItem extends StatelessWidget {
  /// Leading icon
  final IconData icon;

  /// Label text
  final String label;

  /// Tap callback
  final VoidCallback? onTap;

  /// Whether item is selected
  final bool selected;

  /// Badge count (optional)
  final int? badgeCount;

  /// Custom icon color
  final Color? iconColor;

  /// Custom text color
  final Color? textColor;

  const HvacDrawerItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.selected = false,
    this.badgeCount,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HvacSpacing.sm,
        vertical: HvacSpacing.xxs,
      ),
      child: ListTile(
        leading: Badge(
          isLabelVisible: badgeCount != null && badgeCount! > 0,
          label: badgeCount != null ? Text(badgeCount.toString()) : null,
          child: Icon(
            icon,
            color: selected
                ? (iconColor ?? HvacColors.primary)
                : (iconColor ?? HvacColors.textSecondary),
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? (textColor ?? HvacColors.primary)
                : (textColor ?? HvacColors.textPrimary),
          ),
        ),
        selected: selected,
        selectedTileColor: HvacColors.primary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: HvacRadius.lgRadius,
        ),
        onTap: onTap,
      ),
    );
  }
}

/// Drawer section header
///
/// Usage:
/// ```dart
/// HvacDrawerHeader(
///   title: 'MAIN MENU',
/// )
/// ```
class HvacDrawerHeader extends StatelessWidget {
  final String title;

  const HvacDrawerHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HvacSpacing.lg,
        HvacSpacing.lg,
        HvacSpacing.lg,
        HvacSpacing.sm,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: HvacColors.textTertiary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// Drawer divider
///
/// Usage:
/// ```dart
/// HvacDrawerDivider()
/// ```
class HvacDrawerDivider extends StatelessWidget {
  const HvacDrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: HvacSpacing.md,
        vertical: HvacSpacing.sm,
      ),
      child: Divider(
        color: HvacColors.backgroundCardBorder,
        thickness: 1,
      ),
    );
  }
}

/// User profile drawer header
///
/// Usage:
/// ```dart
/// HvacUserDrawerHeader(
///   name: 'John Doe',
///   email: 'john@example.com',
///   avatarUrl: 'https://...',
/// )
/// ```
class HvacUserDrawerHeader extends StatelessWidget {
  final String name;
  final String? email;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const HvacUserDrawerHeader({
    super.key,
    required this.name,
    this.email,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HvacColors.primary,
            HvacColors.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: HvacColors.primary,
                ),
              )
            : null,
      ),
      accountName: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      accountEmail: email != null
          ? Text(
              email!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            )
          : null,
      onDetailsPressed: onTap,
    );
  }
}

/// Compact drawer (for tablets)
///
/// Usage:
/// ```dart
/// HvacCompactDrawer(
///   children: [
///     HvacDrawerItem(icon: Icons.home, label: 'Home'),
///   ],
/// )
/// ```
class HvacCompactDrawer extends StatelessWidget {
  final List<Widget> children;

  const HvacCompactDrawer({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return HvacDrawer(
      width: 72,
      children: children,
    );
  }
}
