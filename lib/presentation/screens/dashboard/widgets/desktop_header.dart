/// Desktop Header - Header with unit tabs for desktop layout
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez_logo.dart';
import 'header_icon_button.dart';
import 'add_unit_button.dart';

/// Desktop header with unit tabs and user info
class DesktopHeader extends StatelessWidget {
  final List<UnitState> units;
  final int selectedUnitIndex;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onAddUnit;
  final bool isDark;
  final VoidCallback? onThemeToggle;
  final String userName;
  final String userRole;
  final bool showMenuButton;
  final VoidCallback? onMenuTap;
  final bool showLogo;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;

  const DesktopHeader({
    super.key,
    required this.units,
    required this.selectedUnitIndex,
    this.onUnitSelected,
    this.onAddUnit,
    required this.isDark,
    this.onThemeToggle,
    required this.userName,
    required this.userRole,
    this.showMenuButton = false,
    this.onMenuTap,
    this.showLogo = false,
    this.onProfileTap,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Menu button (tablet only)
        if (showMenuButton) ...[
          HeaderIconButton(
            icon: Icons.menu,
            onTap: onMenuTap,
          ),
          const SizedBox(width: 12),
        ],
        // Unit tabs (with logo inside if requested)
        Expanded(child: _buildUnitTabs(context)),
        const SizedBox(width: 16),
        // Theme toggle
        HeaderIconButton(
          icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          onTap: onThemeToggle,
        ),
        const SizedBox(width: 8),
        // Notifications
        HeaderIconButton(
          icon: Icons.notifications_outlined,
          badge: '3',
          onTap: onNotificationsTap,
        ),
        const SizedBox(width: 16),
        // User info
        _buildUserInfo(),
      ],
    );
  }

  Widget _buildUnitTabs(BuildContext context) {
    final colors = BreezColors.of(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          // Logo (when requested)
          if (showLogo) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: BreezLogo.small(),
            ),
            const SizedBox(width: 8),
          ],
          // Unit tabs list
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: units.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final unit = units[index];
                final isSelected = index == selectedUnitIndex;
                return _UnitTab(
                  unit: unit,
                  isSelected: isSelected,
                  onTap: () => onUnitSelected?.call(index),
                );
              },
            ),
          ),
          // Add unit button
          AddUnitButton(onTap: onAddUnit),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Builder(
      builder: (context) {
        final colors = BreezColors.of(context);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onProfileTap,
            borderRadius: BorderRadius.circular(AppRadius.button),
            hoverColor: colors.buttonBg,
            splashColor: AppColors.accent.withValues(alpha: 0.1),
            highlightColor: AppColors.accent.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, AppColors.accentLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Individual unit tab
class _UnitTab extends StatelessWidget {
  final UnitState unit;
  final bool isSelected;
  final VoidCallback? onTap;

  const _UnitTab({
    required this.unit,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.nested),
        hoverColor: isSelected
            ? AppColors.accentLight
            : colors.buttonBg,
        splashColor: AppColors.accent.withValues(alpha: 0.2),
        highlightColor: AppColors.accent.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.nested),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status indicator
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: unit.power
                      ? (isSelected ? Colors.white : AppColors.accentGreen)
                      : colors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              // Unit name
              Text(
                unit.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
