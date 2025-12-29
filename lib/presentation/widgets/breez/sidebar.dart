/// Sidebar Navigation Component
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import 'breez_card.dart';
import 'breez_logo.dart';

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
    SidebarItem(icon: Icons.home_outlined, label: 'Главная'),
    SidebarItem(icon: Icons.bar_chart, label: 'Аналитика'),
    SidebarItem(icon: Icons.devices, label: 'Устройства'),
    SidebarItem(icon: Icons.person_outline, label: 'Профиль'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивная ширина на основе доступного пространства
        // Если места мало - компактный режим (только иконки)
        // Если места много - расширенный режим (иконки + текст)
        final availableWidth = MediaQuery.sizeOf(context).width;
        final isExpanded = availableWidth > 1200; // breakpoint для расширенного режима
        final sidebarWidth = isExpanded ? 133.0 : 53.0;

        return Container(
          width: sidebarWidth,
          margin: const EdgeInsets.only(
            left: AppSpacing.sm,
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: colors.border),
          ),
          child: Column(
        children: [
          const SizedBox(height: 20),

          // Logo
          _LogoButton(isExpanded: isExpanded),

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
                    label: item.label,
                    isSelected: isSelected,
                    isExpanded: isExpanded,
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
              label: 'Выход',
              isExpanded: isExpanded,
              onTap: onLogoutTap,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
        );
      },
    );
  }
}

/// Logo button at top of sidebar
class _LogoButton extends StatelessWidget {
  final bool isExpanded;

  const _LogoButton({this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    // Expanded mode: logo + text
    if (isExpanded) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: BreezLogo.medium(),
      );
    }

    // Compact mode: icon only
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.buttonBg,
        borderRadius: BorderRadius.circular(AppRadius.button),
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
class _SidebarButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool isSelected;
  final bool isExpanded;
  final String? badge;
  final VoidCallback? onTap;

  const _SidebarButton({
    required this.icon,
    this.label,
    this.isSelected = false,
    this.isExpanded = false,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezButton(
      onTap: onTap,
      height: 48,
      padding: isExpanded
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          : EdgeInsets.zero,
      backgroundColor: isSelected ? AppColors.accent : Colors.transparent,
      hoverColor: isSelected ? AppColors.accent : colors.buttonBg,
      border: Border.all(
        color: isSelected ? AppColors.accent : Colors.transparent,
      ),
      child: isExpanded && label != null
          ? Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected ? Colors.white : colors.textMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : colors.text,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.accentRed,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            )
          : Stack(
              children: [
                Center(
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected ? Colors.white : colors.textMuted,
                  ),
                ),
                if (badge != null)
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
                        badge!,
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
    );
  }
}
