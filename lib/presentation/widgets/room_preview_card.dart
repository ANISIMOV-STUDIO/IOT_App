/// Room Preview Card
///
/// Large card with live room view and status badges
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class RoomPreviewCard extends StatelessWidget {
  final String roomName;
  final String? imageUrl;
  final bool isLive;
  final List<StatusBadge> badges;

  const RoomPreviewCard({
    super.key,
    required this.roomName,
    this.imageUrl,
    this.isLive = false,
    this.badges = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image or placeholder
            if (imageUrl != null)
              Positioned.fill(
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                ),
              )
            else
              _buildPlaceholder(),

            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Live badge
            if (isLive)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Status badges
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: badges
                    .map((badge) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _buildStatusBadge(badge),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.backgroundCard,
      child: const Center(
        child: Icon(
          Icons.home_outlined,
          size: 80,
          color: AppTheme.textTertiary,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(StatusBadge badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badge.icon,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            badge.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
