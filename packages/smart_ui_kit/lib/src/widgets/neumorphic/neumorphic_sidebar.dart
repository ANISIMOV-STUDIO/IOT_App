import 'package:flutter/material.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Neumorphic Sidebar - Navigation panel for Smart Home Dashboard
class NeumorphicSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final String? userName;
  final String? userAvatarUrl;
  final List<NeumorphicNavItem> items;
  final List<NeumorphicNavItem>? bottomItems;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const NeumorphicSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    this.userName,
    this.userAvatarUrl,
    this.bottomItems,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final width = isCollapsed 
        ? NeumorphicSpacing.sidebarCollapsed 
        : NeumorphicSpacing.sidebarExpanded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: NeumorphicSpacing.lg,
        horizontal: isCollapsed ? NeumorphicSpacing.sm : NeumorphicSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colors.surface,
      ),
      child: Column(
        children: [
          // User profile section
          _buildUserProfile(theme),
          
          SizedBox(height: NeumorphicSpacing.xl),
          
          // Navigation items
          Expanded(
            child: ListView(
              children: [
                ...items.asMap().entries.map((entry) => 
                  _buildNavItem(theme, entry.key, entry.value),
                ),
              ],
            ),
          ),
          
          // Bottom items (Settings, etc.)
          if (bottomItems != null) ...[
            const Divider(height: 32),
            ...bottomItems!.asMap().entries.map((entry) => 
              _buildNavItem(theme, items.length + entry.key, entry.value),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserProfile(NeumorphicThemeData theme) {
    if (isCollapsed) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colors.cardSurface,
          boxShadow: theme.shadows.convexSmall,
        ),
        child: userAvatarUrl != null
            ? ClipOval(
                child: Image.network(userAvatarUrl!, fit: BoxFit.cover),
              )
            : Icon(
                Icons.person,
                color: theme.colors.textSecondary,
              ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(NeumorphicSpacing.sm),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colors.cardSurface,
              boxShadow: theme.shadows.convexSmall,
            ),
            child: userAvatarUrl != null
                ? ClipOval(
                    child: Image.network(userAvatarUrl!, fit: BoxFit.cover),
                  )
                : Icon(
                    Icons.person,
                    color: theme.colors.textSecondary,
                  ),
          ),
          
          const SizedBox(width: NeumorphicSpacing.sm),
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to back',
                  style: theme.typography.labelSmall,
                ),
                Text(
                  userName ?? 'User',
                  style: theme.typography.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(NeumorphicThemeData theme, int index, NeumorphicNavItem item) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: NeumorphicSpacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.circular(NeumorphicSpacing.radiusSm),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? NeumorphicSpacing.sm : NeumorphicSpacing.md,
              vertical: NeumorphicSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? theme.colors.cardSurface 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(NeumorphicSpacing.radiusSm),
              boxShadow: isSelected ? theme.shadows.convexSmall : null,
            ),
            child: Row(
              mainAxisAlignment: isCollapsed 
                  ? MainAxisAlignment.center 
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  item.icon,
                  color: isSelected 
                      ? NeumorphicColors.accentPrimary 
                      : theme.colors.textSecondary,
                  size: NeumorphicSpacing.navIconSize,
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: NeumorphicSpacing.sm),
                  Text(
                    item.label,
                    style: theme.typography.bodyMedium.copyWith(
                      color: isSelected 
                          ? theme.colors.textPrimary 
                          : theme.colors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
                if (!isCollapsed && item.badge != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: NeumorphicColors.accentPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badge!,
                      style: theme.typography.labelSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Navigation item data
class NeumorphicNavItem {
  final IconData icon;
  final String label;
  final String? badge;

  const NeumorphicNavItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}
