/// Avatar Component
/// Provides circular avatars with image, initials, or icon fallback
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// HVAC-themed avatar component
class HvacAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final IconData? icon;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final Border? border;

  const HvacAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.icon,
    this.size = 40.0,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.border,
  });

  /// Create avatar from name (extracts initials)
  factory HvacAvatar.fromName({
    required String name,
    String? imageUrl,
    double size = 40.0,
    Color? backgroundColor,
    Color? foregroundColor,
    VoidCallback? onTap,
    Border? border,
  }) {
    final initials = _getInitials(name);
    return HvacAvatar(
      imageUrl: imageUrl,
      initials: initials,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      onTap: onTap,
      border: border,
    );
  }

  static String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? HvacColors.primaryOrange.withValues(alpha: 0.2);
    final fgColor = foregroundColor ?? HvacColors.primaryOrange;

    Widget content;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: bgColor,
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback to initials if image fails
        },
        child: initials != null
            ? Text(
                initials!,
                style: HvacTypography.bodyBold.copyWith(
                  fontSize: size * 0.4,
                  color: fgColor,
                ),
              )
            : null,
      );
    } else if (initials != null && initials!.isNotEmpty) {
      content = CircleAvatar(
        radius: size / 2,
        backgroundColor: bgColor,
        child: Text(
          initials!,
          style: HvacTypography.bodyBold.copyWith(
            fontSize: size * 0.4,
            color: fgColor,
          ),
        ),
      );
    } else if (icon != null) {
      content = CircleAvatar(
        radius: size / 2,
        backgroundColor: bgColor,
        child: Icon(
          icon,
          size: size * 0.5,
          color: fgColor,
        ),
      );
    } else {
      content = CircleAvatar(
        radius: size / 2,
        backgroundColor: bgColor,
        child: Icon(
          Icons.person,
          size: size * 0.5,
          color: fgColor,
        ),
      );
    }

    if (border != null) {
      content = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: border,
        ),
        child: content,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

/// Avatar group for displaying multiple avatars
class HvacAvatarGroup extends StatelessWidget {
  final List<HvacAvatar> avatars;
  final int maxVisible;
  final double size;
  final double overlap;
  final VoidCallback? onMoreTap;

  const HvacAvatarGroup({
    super.key,
    required this.avatars,
    this.maxVisible = 3,
    this.size = 40.0,
    this.overlap = 0.3,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final visibleAvatars = avatars.take(maxVisible).toList();
    final remaining = avatars.length - maxVisible;

    return SizedBox(
      height: size,
      child: Stack(
        children: [
          ...List.generate(
            visibleAvatars.length,
            (index) {
              return Positioned(
                left: index * size * (1 - overlap),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: HvacColors.backgroundMain,
                      width: 2,
                    ),
                  ),
                  child: visibleAvatars[index],
                ),
              );
            },
          ),
          if (remaining > 0)
            Positioned(
              left: visibleAvatars.length * size * (1 - overlap),
              child: GestureDetector(
                onTap: onMoreTap,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HvacColors.backgroundCard,
                    border: Border.all(
                      color: HvacColors.backgroundMain,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+$remaining',
                      style: HvacTypography.caption.copyWith(
                        color: HvacColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
