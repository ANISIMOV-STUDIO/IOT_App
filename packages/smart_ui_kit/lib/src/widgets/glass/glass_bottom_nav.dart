import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glass_sidebar.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Glass Bottom Navigation Bar for mobile/tablet layouts
class GlassBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final List<GlassNavItem> items;
  final bool showLabels;
  final double? height;

  const GlassBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    this.showLabels = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final navHeight = height ??
        (showLabels
            ? NeumorphicSpacing.bottomNavHeight
            : NeumorphicSpacing.bottomNavHeightCompact);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.isDark
                  ? [
                      const Color(0x4D1E293B),
                      const Color(0x801E293B),
                    ]
                  : [
                      const Color(0xE6FFFFFF),
                      const Color(0xFFFFFFFF),
                    ],
            ),
            border: Border(
              top: BorderSide(
                color: theme.isDark
                    ? const Color(0x33FFFFFF)
                    : const Color(0x1A000000),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: navHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == selectedIndex;

                  return _GlassBottomNavItem(
                    item: item,
                    isSelected: isSelected,
                    showLabel: showLabels,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onItemSelected(index);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicBottomNav = GlassBottomNav;

class _GlassBottomNavItem extends StatefulWidget {
  final GlassNavItem item;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  const _GlassBottomNavItem({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  @override
  State<_GlassBottomNavItem> createState() => _GlassBottomNavItemState();
}

class _GlassBottomNavItemState extends State<_GlassBottomNavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final iconColor = widget.isSelected
        ? GlassColors.accentPrimary
        : theme.colors.textSecondary;
    final labelColor = widget.isSelected
        ? theme.colors.textPrimary
        : theme.colors.textTertiary;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with glass background when selected
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? GlassColors.accentPrimary.withValues(alpha: 0.15)
                          : _isPressed
                              ? theme.colors.glassSurface.withValues(alpha: 0.3)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: widget.isSelected
                          ? Border.all(
                              color: GlassColors.accentPrimary
                                  .withValues(alpha: 0.3),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Icon(
                      widget.item.icon,
                      size: NeumorphicSpacing.bottomNavIconSize,
                      color: iconColor,
                    ),
                  ),
                  // Badge
                  if (widget.item.badge != null)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: GlassColors.accentError,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  GlassColors.accentError.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.item.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Label
              if (widget.showLabel) ...[
                const SizedBox(height: 4),
                Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: labelColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
