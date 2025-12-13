import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as np;
import 'neumorphic_theme_wrapper.dart';
import 'neumorphic_sidebar.dart';
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Neumorphic Bottom Navigation Bar for mobile/tablet layouts
class NeumorphicBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final List<NeumorphicNavItem> items;
  final bool showLabels;
  final double? height;

  const NeumorphicBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    this.showLabels = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final navHeight = height ??
        (showLabels ? NeumorphicSpacing.bottomNavHeight : NeumorphicSpacing.bottomNavHeightCompact);

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.surface,
        boxShadow: [
          // Top shadow for elevation effect
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
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

              return _BottomNavItem(
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
    );
  }
}

class _BottomNavItem extends StatefulWidget {
  final NeumorphicNavItem item;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  @override
  State<_BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<_BottomNavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final iconColor = widget.isSelected
        ? NeumorphicColors.accentPrimary
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
              // Icon with neumorphic background when selected
              Stack(
                clipBehavior: Clip.none,
                children: [
                  np.Neumorphic(
                    duration: Duration.zero,
                    style: np.NeumorphicStyle(
                      depth: widget.isSelected ? 3 : (_isPressed ? -1 : 0),
                      intensity: widget.isSelected ? 0.5 : 0.3,
                      boxShape: np.NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(NeumorphicSpacing.radiusSm),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
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
                          color: NeumorphicColors.accentError,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: NeumorphicColors.accentError.withValues(alpha: 0.3),
                              blurRadius: 4,
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
                    fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
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
