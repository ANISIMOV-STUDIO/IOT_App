import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as np;
import 'neumorphic_theme_wrapper.dart';
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
  final VoidCallback? onToggleSidebar;

  const NeumorphicSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    this.userName,
    this.userAvatarUrl,
    this.bottomItems,
    this.isCollapsed = false,
    this.onToggleSidebar,
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
        // Neumorphic shadow on right edge
        boxShadow: [
          BoxShadow(
            color: theme.shadows.shadowDark.withValues(alpha: 0.1),
            offset: const Offset(4, 0),
            blurRadius: 8,
          ),
          BoxShadow(
            color: theme.shadows.shadowLight.withValues(alpha: 0.7),
            offset: const Offset(-2, 0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo and user profile
          _buildHeader(context, theme),

          SizedBox(height: NeumorphicSpacing.xl),

          // Navigation items
          Expanded(
            child: ListView(
              children: [
                ...items.asMap().entries.map((entry) =>
                  _buildNavItem(context, theme, entry.key, entry.value),
                ),
              ],
            ),
          ),

          // Bottom items (Settings, etc.)
          if (bottomItems != null) ...[
            _buildNeumorphicDivider(theme),
            const SizedBox(height: 16),
            ...bottomItems!.asMap().entries.map((entry) =>
              _buildNavItem(context, theme, items.length + entry.key, entry.value),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NeumorphicThemeData theme) {
    if (isCollapsed) {
      return _buildLogo(theme, compact: true);
    }

    return Column(
      children: [
        _buildLogo(theme, compact: false),
        const SizedBox(height: NeumorphicSpacing.md),
        _buildUserProfile(theme),
      ],
    );
  }

  /// Neumorphic BREEZ logo
  Widget _buildLogo(NeumorphicThemeData theme, {required bool compact}) {
    return np.Neumorphic(
      style: np.NeumorphicStyle(
        depth: 3,
        intensity: 0.6,
        boxShape: np.NeumorphicBoxShape.roundRect(
          BorderRadius.circular(compact ? 12 : 16),
        ),
      ),
      padding: EdgeInsets.all(compact ? 10 : 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Snowflake/wind icon for HVAC
          Container(
            padding: EdgeInsets.all(compact ? 6 : 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  NeumorphicColors.accentPrimary,
                  NeumorphicColors.modeCooling,
                ],
              ),
              borderRadius: BorderRadius.circular(compact ? 8 : 10),
            ),
            child: Icon(
              Icons.ac_unit_rounded,
              color: Colors.white,
              size: compact ? 18 : 22,
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 12),
            Text(
              'BREEZ',
              style: theme.typography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: theme.colors.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserProfile(NeumorphicThemeData theme) {
    return np.Neumorphic(
      style: np.NeumorphicStyle(
        depth: -2, // Concave effect
        intensity: 0.4,
        boxShape: np.NeumorphicBoxShape.roundRect(
          BorderRadius.circular(14),
        ),
      ),
      padding: const EdgeInsets.all(NeumorphicSpacing.sm),
      child: Row(
        children: [
          // Avatar
          np.Neumorphic(
            style: np.NeumorphicStyle(
              depth: 3,
              intensity: 0.5,
              boxShape: const np.NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: theme.colors.cardSurface,
              backgroundImage: userAvatarUrl != null
                  ? NetworkImage(userAvatarUrl!)
                  : null,
              child: userAvatarUrl == null
                  ? Icon(Icons.person, color: theme.colors.textSecondary, size: 20)
                  : null,
            ),
          ),

          const SizedBox(width: NeumorphicSpacing.sm),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'С возвращением',
                  style: theme.typography.labelSmall.copyWith(
                    color: theme.colors.textTertiary,
                  ),
                ),
                Text(
                  userName ?? 'Пользователь',
                  style: theme.typography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Neumorphic divider - soft shadow line
  Widget _buildNeumorphicDivider(NeumorphicThemeData theme) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        gradient: LinearGradient(
          colors: [
            theme.shadows.shadowDark.withValues(alpha: 0.15),
            theme.shadows.shadowLight.withValues(alpha: 0.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NeumorphicThemeData theme, int index, NeumorphicNavItem item) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: NeumorphicSpacing.xs),
      child: _NeumorphicNavButton(
        item: item,
        isSelected: isSelected,
        isCollapsed: isCollapsed,
        theme: theme,
        onTap: () => onItemSelected(index),
      ),
    );
  }
}

/// Neumorphic navigation button with press animation
class _NeumorphicNavButton extends StatefulWidget {
  final NeumorphicNavItem item;
  final bool isSelected;
  final bool isCollapsed;
  final NeumorphicThemeData theme;
  final VoidCallback onTap;

  const _NeumorphicNavButton({
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_NeumorphicNavButton> createState() => _NeumorphicNavButtonState();
}

class _NeumorphicNavButtonState extends State<_NeumorphicNavButton> {
  bool _isPressed = false;

  double get _depth {
    if (_isPressed) return -2; // Pressed - concave
    if (widget.isSelected) return 3; // Selected - convex
    return 0; // Default - flat
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final iconColor = widget.isSelected
        ? NeumorphicColors.accentPrimary
        : theme.colors.textSecondary;
    final textColor = widget.isSelected
        ? theme.colors.textPrimary
        : theme.colors.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: np.Neumorphic(
          duration: Duration.zero,
          style: np.NeumorphicStyle(
            depth: _depth,
            intensity: widget.isSelected ? 0.5 : 0.3,
            boxShape: np.NeumorphicBoxShape.roundRect(
              BorderRadius.circular(NeumorphicSpacing.radiusSm),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed ? NeumorphicSpacing.sm : NeumorphicSpacing.md,
            vertical: NeumorphicSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: widget.isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
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
                      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.item.badge != null)
                  _buildBadge(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(NeumorphicThemeData theme) {
    return np.Neumorphic(
      style: np.NeumorphicStyle(
        depth: 2,
        intensity: 0.6,
        color: NeumorphicColors.accentPrimary,
        boxShape: np.NeumorphicBoxShape.roundRect(
          BorderRadius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
