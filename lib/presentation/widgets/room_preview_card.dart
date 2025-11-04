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

  const RoomPreviewCard({
    super.key,
    required this.roomName,
    this.imageUrl,
    this.isLive = false,
    this.badges = const [],
    this.onPowerChanged,
    this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
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
        borderRadius: BorderRadius.circular(20.r),
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
        borderRadius: BorderRadius.circular(20.r),
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
              top: 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: HvacColors.backgroundCard.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(10.r),
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
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    SizedBox(
                      height: 20.h,
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
                top: 12.h,
                right: 12.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: badges
                      .map((badge) => Padding(
                            padding: EdgeInsets.only(left: 6.w),
                            child: _buildStatusBadge(context, badge),
                          ))
                      .toList(),
                ),
              ),

            // Central content - Room name and quick stats
            Positioned(
              left: 12.w,
              right: 12.w,
              top: isMobile ? 48.h : 0,
              bottom: isMobile ? 52.h : 0,
              child: isMobile
                  ? SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roomName,
                            style: TextStyle(
                              fontSize: 22.sp,
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
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.h,
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
                              SizedBox(width: 4.w),
                              Text(
                                isLive ? 'Активно' : 'Неактивно',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: HvacColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roomName,
                          style: TextStyle(
                            fontSize: 28.sp,
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
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.h,
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
                            SizedBox(width: 6.w),
                            Text(
                              isLive ? 'Активно' : 'Неактивно',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: HvacColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),

            // Details button
            if (onDetailsPressed != null)
              Positioned(
                bottom: isMobile ? 12.h : 16.h,
                right: isMobile ? 12.w : 16.w,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onDetailsPressed,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 10.w : 12.w,
                        vertical: isMobile ? 6.h : 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: HvacColors.backgroundCard.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(10.r),
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
                              fontSize: isMobile ? 11.sp : 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward,
                            color: HvacColors.primaryOrange,
                            size: isMobile ? 12.sp : 14.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, StatusBadge badge) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6.w : 10.w,
        vertical: isMobile ? 4.h : 6.h,
      ),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8.r),
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
          Icon(
            badge.icon,
            size: isMobile ? 12.sp : 14.sp,
            color: HvacColors.primaryOrange,
          ),
          SizedBox(width: 3.w),
          Text(
            badge.value,
            style: TextStyle(
              fontSize: isMobile ? 11.sp : 12.sp,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
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
