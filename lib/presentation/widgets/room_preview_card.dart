/// Room Preview Card
///
/// Large card with live room view and status badges
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class RoomPreviewCard extends StatelessWidget {
  final String roomName;
  final String? imageUrl;
  final bool isLive;
  final List<StatusBadge> badges;
  final ValueChanged<bool>? onPowerChanged;
  final VoidCallback? onDetailsPressed;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onSettingsPressed;
  final bool isFavorite;

  const RoomPreviewCard({
    super.key,
    required this.roomName,
    this.imageUrl,
    this.isLive = false,
    this.badges = const [],
    this.onPowerChanged,
    this.onDetailsPressed,
    this.onFavoriteToggle,
    this.onSettingsPressed,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    // Wrap in swipeable card for mobile
    final cardContent = _buildCardContent(context, isMobile);

    if (isMobile && (onFavoriteToggle != null || onSettingsPressed != null)) {
      return HvacSwipeableCard(
        onSwipeRight: onFavoriteToggle,
        onSwipeLeft: onSettingsPressed,
        rightActionLabel: 'Favorite',
        leftActionLabel: 'Settings',
        rightActionIcon: Icons.favorite,
        leftActionIcon: Icons.settings,
        rightActionColor: HvacColors.primaryOrange,
        leftActionColor: HvacColors.info,
        child: cardContent,
      );
    }

    return cardContent;
  }

  Widget _buildCardContent(BuildContext context, bool isMobile) {
    // Main card container with gradient border for active/favorite devices
    Widget cardContainer = Container(
      constraints: BoxConstraints(
        maxHeight: isMobile ? 260 : 400,
        minHeight: isMobile ? 240 : 300,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HvacColors.backgroundCard,
            HvacColors.backgroundCard.withValues(alpha: 0.8),
            HvacColors.backgroundDark,
          ],
        ),
        borderRadius: HvacRadius.xlRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: HvacColors.backgroundDark.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: HvacRadius.xlRadius,
        child: Stack(
          children: [
            // Animated gradient background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      HvacColors.primaryOrange.withValues(alpha: 0.1),
                      Colors.transparent,
                      HvacColors.info.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),

            // Power Toggle
            Positioned(
              top: 12.0,
              left: 12.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: HvacColors.backgroundCard.withValues(alpha: 0.95),
                  borderRadius: HvacRadius.smRadius,
                  border: Border.all(
                    color: HvacColors.backgroundCardBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLive ? Icons.power_settings_new : Icons.power_off,
                      color: isLive ? HvacColors.success : HvacColors.textSecondary,
                      size: 16.0,
                    ),
                    const SizedBox(width: 6.0),
                    SizedBox(
                      height: 20.0,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Switch(
                          value: isLive,
                          onChanged: onPowerChanged,
                          activeThumbColor: HvacColors.textPrimary,
                          activeTrackColor: HvacColors.success,
                          inactiveThumbColor: HvacColors.textSecondary,
                          inactiveTrackColor: HvacColors.backgroundCardBorder,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Status badges - positioned at top for all screen sizes
            if (badges.isNotEmpty)
              Positioned(
                top: 12.0,
                right: 12.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: badges
                      .map((badge) => Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: _buildStatusBadge(context, badge),
                          ))
                      .toList(),
                ),
              ),

            // Central content - Room name and quick stats with Hero
            Positioned(
              left: 12.0,
              right: 12.0,
              top: isMobile ? 48.0 : 0,
              bottom: isMobile ? 52.0 : 0,
              child: isMobile
                  ? SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HvacTemperatureHero(
                            tag: 'roomName_$roomName',
                            temperature: roomName,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                              color: HvacColors.textPrimary,
                              height: 1.1,
                              shadows: [
                                Shadow(
                                  color: HvacColors.backgroundDark.withValues(alpha: 0.6),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          HvacStatusHero(
                            tag: 'status_$roomName',
                            child: Row(
                              children: [
                                Container(
                                  width: 6.0,
                                  height: 6.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isLive ? HvacColors.success : HvacColors.error,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isLive ? HvacColors.success : HvacColors.error)
                                            .withValues(alpha: 0.5),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  isLive ? 'Активно' : 'Неактивно',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: HvacColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HvacTemperatureHero(
                          tag: 'roomName_$roomName',
                          temperature: roomName,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w700,
                            color: HvacColors.textPrimary,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: HvacColors.backgroundDark.withValues(alpha: 0.6),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        HvacStatusHero(
                          tag: 'status_$roomName',
                          child: Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isLive ? HvacColors.success : HvacColors.error,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isLive ? HvacColors.success : HvacColors.error)
                                          .withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                isLive ? 'Активно' : 'Неактивно',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: HvacColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),

            // Details button with interactive scale
            if (onDetailsPressed != null)
              Positioned(
                bottom: isMobile ? 12.0 : 16.0,
                right: isMobile ? 12.0 : 16.0,
                child: HvacInteractiveScale(
                  onTap: onDetailsPressed,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10.0 : 12.0,
                      vertical: isMobile ? 6.0 : 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: HvacColors.backgroundCard.withValues(alpha: 0.95),
                      borderRadius: HvacRadius.smRadius,
                      border: Border.all(
                        color: HvacColors.primaryOrange.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Подробнее',
                          style: TextStyle(
                            color: HvacColors.primaryOrange,
                            fontSize: isMobile ? 11.0 : 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        HvacIconHero(
                          tag: 'arrow_$roomName',
                          icon: Icons.arrow_forward,
                          color: HvacColors.primaryOrange,
                          size: isMobile ? 12.0 : 14.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    // Add gradient border for active or favorite devices
    if (isLive || isFavorite) {
      cardContainer = HvacBrandedBorder(
        borderWidth: 2.0,
        borderRadius: HvacRadius.xlRadius,
        child: cardContainer,
      );
    }

    return cardContainer;
  }

  Widget _buildStatusBadge(BuildContext context, StatusBadge badge) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return HvacInteractiveScale(
      scaleDown: 0.92,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6.0 : 10.0,
          vertical: isMobile ? 4.0 : 6.0,
        ),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard.withValues(alpha: 0.95),
          borderRadius: HvacRadius.smRadius,
          border: Border.all(
            color: HvacColors.primaryOrange.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: HvacColors.backgroundDark.withValues(alpha: 0.5),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HvacIconHero(
              tag: 'badge_${badge.icon}_${badge.value}',
              icon: badge.icon,
              size: isMobile ? 12.0 : 14.0,
              color: HvacColors.primaryOrange,
            ),
            const SizedBox(width: 3.0),
            HvacTemperatureHero(
              tag: 'badgeValue_${badge.value}',
              temperature: badge.value,
              style: TextStyle(
                fontSize: isMobile ? 11.0 : 12.0,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusBadge {
  final IconData icon;
  final String value;

  const StatusBadge({
    required this.icon,
    required this.value,
  });
}
