/// Room Preview Card
///
/// Large card with live room view and status badges
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_utils.dart';

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
        maxHeight: isMobile ? 180 : 400,
        minHeight: isMobile ? 160 : 300,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundCard,
            AppTheme.backgroundCard.withValues(alpha: 0.8),
            AppTheme.backgroundDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
                      AppTheme.primaryOrange.withValues(alpha: 0.1),
                      Colors.transparent,
                      AppTheme.info.withValues(alpha: 0.05),
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
                  color: AppTheme.backgroundCard.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppTheme.backgroundCardBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLive ? Icons.power_settings_new : Icons.power_off,
                      color: isLive ? AppTheme.success : AppTheme.textSecondary,
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isLive ? 'Вкл' : 'Выкл',
                      style: TextStyle(
                        color: isLive ? AppTheme.textPrimary : AppTheme.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    SizedBox(
                      height: 20.h,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Switch(
                          value: isLive,
                          onChanged: onPowerChanged,
                          activeThumbColor: Colors.white,
                          activeTrackColor: AppTheme.success,
                          inactiveThumbColor: AppTheme.textSecondary,
                          inactiveTrackColor: AppTheme.backgroundCardBorder,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Status badges
            Positioned(
              top: ResponsiveUtils.isMobile(context) ? 50.h : 12.h,
              right: 12.w,
              left: ResponsiveUtils.isMobile(context) ? 12.w : null,
              child: ResponsiveUtils.isMobile(context)
                  ? Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 4.w,
                      runSpacing: 4.h,
                      children: badges
                          .map((badge) => _buildStatusBadge(context, badge))
                          .toList(),
                    )
                  : Row(
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
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomName,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
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
                          color: isLive ? AppTheme.success : AppTheme.error,
                          boxShadow: [
                            BoxShadow(
                              color: (isLive ? AppTheme.success : AppTheme.error)
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
                          color: AppTheme.textSecondary,
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
                bottom: 16,
                right: 16,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onDetailsPressed,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Подробнее',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16.sp,
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
        color: AppTheme.backgroundCard.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppTheme.primaryOrange.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
            color: AppTheme.primaryOrange,
          ),
          SizedBox(width: 3.w),
          Text(
            badge.value,
            style: TextStyle(
              fontSize: isMobile ? 11.sp : 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
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
