/// Desktop Header - Header with unit tabs for desktop layout
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez_logo.dart';
import '../../../widgets/breez/breez_card.dart';
import '../../../widgets/breez/unit_tab_button.dart';
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
  final int unreadNotificationsCount;

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
    this.unreadNotificationsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Menu button (tablet only)
        if (showMenuButton) ...[
          BreezIconButton(
            icon: Icons.menu,
            onTap: onMenuTap,
          ),
          const SizedBox(width: 12),
        ],
        // Unit tabs (with logo inside if requested)
        Expanded(child: _buildUnitTabs(context)),
        const SizedBox(width: 16),
        // Theme toggle
        BreezIconButton(
          icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          onTap: onThemeToggle,
        ),
        const SizedBox(width: 8),
        // Notifications
        BreezIconButton(
          icon: Icons.notifications_outlined,
          badge: unreadNotificationsCount > 0 ? '$unreadNotificationsCount' : null,
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
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                return UnitTabButton(
                  unit: unit,
                  isSelected: isSelected,
                  onTap: () => onUnitSelected?.call(index),
                );
              },
            ),
          ),
          // Add unit button
          Center(child: AddUnitButton(onTap: onAddUnit)),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Builder(
      builder: (context) {
        final colors = BreezColors.of(context);

        return BreezButton(
          onTap: onProfileTap,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
        );
      },
    );
  }
}
