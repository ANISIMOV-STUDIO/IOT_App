/// Room Card - Card showing room info
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'app_card.dart';

/// Room data
class RoomData {
  final String id;
  final String name;
  final String? description;
  final int deviceCount;
  final IconData? icon;

  const RoomData({
    required this.id,
    required this.name,
    this.description,
    this.deviceCount = 0,
    this.icon,
  });
}

/// Compact room card for horizontal list
class RoomCard extends StatelessWidget {
  final RoomData room;
  final VoidCallback? onTap;

  const RoomCard({
    super.key,
    required this.room,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: OutlineCard(
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              room.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              room.description ?? '${room.deviceCount} устройств',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrolling list of rooms
class RoomsRow extends StatelessWidget {
  final List<RoomData> rooms;
  final ValueChanged<String>? onRoomTap;

  const RoomsRow({
    super.key,
    required this.rooms,
    this.onRoomTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: rooms.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return RoomCard(
            room: room,
            onTap: onRoomTap != null ? () => onRoomTap!(room.id) : null,
          );
        },
      ),
    );
  }
}
