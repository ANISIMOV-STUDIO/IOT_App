import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Navigation item data
class GlassNavItem {
  final IconData icon;
  final String label;
  final String? badge;

  const GlassNavItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}

// Backwards compatibility alias
typedef NeumorphicNavItem = GlassNavItem;

/// Glass Sidebar - Navigation panel with glassmorphism
class GlassSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final String? userName;
  final String? userAvatarUrl;
  final List<GlassNavItem> items;
  final List<GlassNavItem>? bottomItems;
  final bool isCollapsed;
  final VoidCallback? onToggleSidebar;
  final Widget? logoWidget;
  final Widget? logoWidgetCompact;
  final String appName;

  const GlassSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    this.userName,
    this.userAvatarUrl,
    this.bottomItems,
    this.isCollapsed = false,
    this.onToggleSidebar,
    this.logoWidget,
    this.logoWidgetCompact,
    this.appName = 'BREEZ',
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final width = isCollapsed
        ? NeumorphicSpacing.sidebarCollapsed
        : NeumorphicSpacing.sidebarExpanded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: double.infinity,
      margin: const EdgeInsets.only(right: NeumorphicSpacing.md),
      child: Column(
        children: [
          // Logo outside the glass container
          _buildLogo(theme, compact: isCollapsed),

          const SizedBox(height: NeumorphicSpacing.sm),

          // Glass container with navigation
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: theme.isDark
                          ? [
                              const Color(0x1AFFFFFF),
                              const Color(0x0DFFFFFF),
                            ]
                          : [
                              const Color(0xB3FFFFFF),
                              const Color(0x80FFFFFF),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.isDark
                          ? const Color(0x33FFFFFF)
                          : const Color(0x66FFFFFF),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: NeumorphicSpacing.md,
                    horizontal: isCollapsed
                        ? NeumorphicSpacing.sm
                        : NeumorphicSpacing.md,
                  ),
                  child: Column(
                    children: [
                      // User profile
                      if (!isCollapsed) ...[
                        _buildUserProfile(theme),
                        const SizedBox(height: NeumorphicSpacing.md),
                      ],

                      // Navigation items
                      Expanded(
                        child: ListView(
                          children: [
                            ...items.asMap().entries.map((entry) =>
                                _buildNavItem(
                                    context, theme, entry.key, entry.value)),
                          ],
                        ),
                      ),

                      // Bottom items
                      if (bottomItems != null) ...[
                        _buildDivider(theme),
                        const SizedBox(height: 12),
                        ...bottomItems!.asMap().entries.map((entry) =>
                            _buildNavItem(context, theme,
                                items.length + entry.key, entry.value)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(GlassThemeData theme, {required bool compact}) {
    final logo = compact ? (logoWidgetCompact ?? logoWidget) : logoWidget;

    return SizedBox(
      height: 56,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logo != null)
              SizedBox(
                width: compact ? 32 : 40,
                height: compact ? 32 : 40,
                child: logo,
              )
            else
              Icon(
                Icons.ac_unit_rounded,
                color: GlassColors.accentPrimary,
                size: compact ? 28 : 36,
              ),
            if (!compact) ...[
              const SizedBox(width: 12),
              Text(
                appName,
                style: theme.typography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: theme.colors.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(GlassThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NeumorphicSpacing.xs,
        vertical: NeumorphicSpacing.sm,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colors.glassSurface,
            backgroundImage:
                userAvatarUrl != null ? NetworkImage(userAvatarUrl!) : null,
            child: userAvatarUrl == null
                ? Icon(Icons.person,
                    color: theme.colors.textSecondary, size: 18)
                : null,
          ),
          const SizedBox(width: NeumorphicSpacing.sm),
          Expanded(
            child: Text(
              userName ?? 'Пользователь',
              style: theme.typography.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(GlassThemeData theme) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: theme.colors.glassBorder,
    );
  }

  Widget _buildNavItem(
      BuildContext context, GlassThemeData theme, int index, GlassNavItem item) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: NeumorphicSpacing.xs),
      child: _GlassNavButton(
        item: item,
        isSelected: isSelected,
        isCollapsed: isCollapsed,
        theme: theme,
        onTap: () => onItemSelected(index),
      ),
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicSidebar = GlassSidebar;

class _GlassNavButton extends StatefulWidget {
  final GlassNavItem item;
  final bool isSelected;
  final bool isCollapsed;
  final GlassThemeData theme;
  final VoidCallback onTap;

  const _GlassNavButton({
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_GlassNavButton> createState() => _GlassNavButtonState();
}

class _GlassNavButtonState extends State<_GlassNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final iconColor = widget.isSelected
        ? GlassColors.accentPrimary
        : theme.colors.textSecondary;
    final textColor =
        widget.isSelected ? theme.colors.textPrimary : theme.colors.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed
                ? NeumorphicSpacing.sm
                : NeumorphicSpacing.md,
            vertical: NeumorphicSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? GlassColors.accentPrimary.withValues(alpha: 0.15)
                : _isHovered
                    ? theme.colors.glassSurface.withValues(alpha: 0.5)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: widget.isSelected
                ? Border.all(
                    color: GlassColors.accentPrimary.withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment:
                widget.isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                widget.item.icon,
                color: iconColor,
                size: NeumorphicSpacing.navIconSize,
              ),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: NeumorphicSpacing.sm),
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: theme.typography.bodyMedium.copyWith(
                      color: textColor,
                      fontWeight:
                          widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.item.badge != null) _buildBadge(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(GlassThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: GlassColors.accentPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        widget.item.badge!,
        style: theme.typography.labelSmall.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
