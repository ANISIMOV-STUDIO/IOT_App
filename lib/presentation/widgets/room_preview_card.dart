/// Room Preview Card
///
/// Large card with live room view and status badges
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'room_preview/status_badge_widget.dart';
import 'room_preview/power_toggle_widget.dart';
import 'room_preview/room_status_display.dart';
import 'room_preview/details_button_widget.dart';

// Export sub-components
export 'room_preview/status_badge_widget.dart';
export 'room_preview/power_toggle_widget.dart';
export 'room_preview/room_status_display.dart';
export 'room_preview/details_button_widget.dart';

/// Room preview card with status indicators and controls
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
    final cardContent = _buildCardContent(context, isMobile);

    // Wrap in swipeable card for mobile with actions
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
    // Main card container with gradient
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
            _buildBackgroundGradient(),

            // Power Toggle (top-left)
            Positioned(
              top: 12.0,
              left: 12.0,
              child: PowerToggleWidget(
                isActive: isLive,
                onChanged: onPowerChanged,
              ),
            ),

            // Status badges (top-right)
            if (badges.isNotEmpty) _buildStatusBadges(),

            // Central content - Room name and status
            _buildCentralContent(isMobile),

            // Details button (bottom-right)
            if (onDetailsPressed != null)
              Positioned(
                bottom: isMobile ? 12.0 : 16.0,
                right: isMobile ? 12.0 : 16.0,
                child: DetailsButtonWidget(
                  roomName: roomName,
                  onPressed: onDetailsPressed,
                  isMobile: isMobile,
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

  Widget _buildBackgroundGradient() {
    return Positioned.fill(
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
    );
  }

  Widget _buildStatusBadges() {
    return Positioned(
      top: 12.0,
      right: 12.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: badges
            .map((badge) => Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: StatusBadgeWidget(badge: badge),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCentralContent(bool isMobile) {
    final content = RoomStatusDisplay(
      roomName: roomName,
      isActive: isLive,
      isMobile: isMobile,
    );

    return Positioned(
      left: 12.0,
      right: 12.0,
      top: isMobile ? 48.0 : 0,
      bottom: isMobile ? 52.0 : 0,
      child: isMobile
          ? SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: content,
            )
          : content,
    );
  }
}
