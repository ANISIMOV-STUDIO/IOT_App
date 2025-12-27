import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// App header with logo, theme toggle, notifications, user
class AppHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onNotificationsTap;
  final bool hasNotifications;
  final String? userName;
  final String? userRole;

  const AppHeader({
    super.key,
    this.isDark = true,
    this.onThemeToggle,
    this.onNotificationsTap,
    this.hasNotifications = false,
    this.userName,
    this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 600;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.darkBorder),
        ),
      ),
      child: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: () {},
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BREEZ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'SMART SYSTEMS',
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.darkTextMuted,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Theme toggle
          BreezIconButton(
            icon: isDark ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
            onTap: onThemeToggle,
          ),

          const SizedBox(width: 8),

          // Notifications
          GestureDetector(
            onTap: onNotificationsTap,
            child: Stack(
              children: [
                BreezIconButton(
                  icon: Icons.notifications_outlined,
                  onTap: onNotificationsTap,
                ),
                if (hasNotifications)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.accentRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // User (desktop only)
          if (isWide && userName != null) ...[
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.only(left: 16),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.darkBorder),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        userName!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                      if (userRole != null)
                        Text(
                          userRole!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkTextMuted,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        userName!.isNotEmpty ? userName![0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
