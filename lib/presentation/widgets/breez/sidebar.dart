/// Sidebar Navigation Component
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';

/// Navigation item data
class SidebarItem {
  final IconData icon;
  final String label;
  final String? badge;

  const SidebarItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}

/// Sidebar navigation panel
class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const Sidebar({
    super.key,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  static const List<SidebarItem> items = [
    SidebarItem(icon: Icons.play_arrow_rounded, label: 'Главная'),
    SidebarItem(icon: Icons.grid_view_rounded, label: 'Виджеты'),
    SidebarItem(icon: Icons.location_on_outlined, label: 'Локации'),
    SidebarItem(icon: Icons.calendar_today_outlined, label: 'Расписание'),
    SidebarItem(icon: Icons.shield_outlined, label: 'Защита'),
    SidebarItem(icon: Icons.star_outline_rounded, label: 'Избранное'),
    SidebarItem(icon: Icons.settings_outlined, label: 'Настройки'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Container(
      width: 80,
      margin: const EdgeInsets.only(
        left: AppSpacing.sm,
        top: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Logo
          _LogoButton(),

          const SizedBox(height: 32),

          // Navigation items (no scroll)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == selectedIndex;

                  return _SidebarButton(
                    icon: item.icon,
                    isSelected: isSelected,
                    badge: item.badge,
                    onTap: () => onItemSelected?.call(index),
                  );
                }).toList(),
              ),
            ),
          ),

          // Bottom action - logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SidebarButton(
              icon: Icons.logout_rounded,
              onTap: onLogoutTap,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Logo button at top of sidebar
class _LogoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.buttonBg,
        borderRadius: BorderRadius.circular(AppColors.buttonRadius),
      ),
      child: SvgPicture.asset(
        'assets/images/breez-logo.svg',
        colorFilter: ColorFilter.mode(
          colors.text,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

/// Sidebar navigation button
class _SidebarButton extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final String? badge;
  final VoidCallback? onTap;

  const _SidebarButton({
    required this.icon,
    this.isSelected = false,
    this.badge,
    this.onTap,
  });

  @override
  State<_SidebarButton> createState() => _SidebarButtonState();
}

class _SidebarButtonState extends State<_SidebarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.accent
                : _isHovered
                    ? colors.buttonBg
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(AppColors.buttonRadius),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.accent
                  : _isHovered
                      ? colors.border
                      : Colors.transparent,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  widget.icon,
                  size: 22,
                  color: widget.isSelected
                      ? Colors.white
                      : _isHovered
                          ? colors.text
                          : colors.textMuted,
                ),
              ),
              if (widget.badge != null)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.accentRed,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.badge!,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
