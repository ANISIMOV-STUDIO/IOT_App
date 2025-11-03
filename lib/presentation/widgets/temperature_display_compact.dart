/// Temperature Display - Redesigned (2025)
///
/// Calm, informative temperature monitoring widget
/// Adaptive for mobile, tablet, and desktop layouts
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/glassmorphism.dart';
import '../../core/animation/smooth_animations.dart';
import '../../core/utils/performance_utils.dart';
import '../../core/utils/adaptive_layout.dart';

class TemperatureDisplayCompact extends StatelessWidget {
  final double? supplyTemp;
  final double? extractTemp;
  final double? outdoorTemp;
  final double? indoorTemp;
  final bool isCompact;

  const TemperatureDisplayCompact({
    super.key,
    this.supplyTemp,
    this.extractTemp,
    this.outdoorTemp,
    this.indoorTemp,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        switch (deviceSize) {
          case DeviceSize.compact:
            return _buildMobileLayout(context);
          case DeviceSize.medium:
            return _buildTabletLayout(context);
          case DeviceSize.expanded:
            return _buildDesktopLayout(context);
        }
      },
    );
  }

  // ============================================================================
  // MOBILE LAYOUT - Compact, vertical stacking
  // ============================================================================
  Widget _buildMobileLayout(BuildContext context) {
    return PerformanceUtils.isolateRepaint(
      SmoothAnimations.fadeIn(
        duration: AnimationDurations.medium,
        child: GlassCard(
          padding: EdgeInsets.all(16.r),
          enableBlur: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Minimalist Header
              _buildHeader(context, isMobile: true),

              SizedBox(height: 16.h),

              // Temperature Grid - 2x2
              _buildTemperatureGrid(context, isMobile: true),

              // Status bar
              if (_hasAllData()) ...[
                SizedBox(height: 12.h),
                _buildStatusBar(context, isCompact: true),
              ],
            ],
          ),
        ),
      ),
      debugLabel: 'TempDisplay-Mobile',
    );
  }

  // ============================================================================
  // TABLET LAYOUT - Horizontal, more spacious
  // ============================================================================
  Widget _buildTabletLayout(BuildContext context) {
    return PerformanceUtils.isolateRepaint(
      SmoothAnimations.fadeIn(
        duration: AnimationDurations.medium,
        child: GlassCard(
          padding: EdgeInsets.all(20.r),
          enableBlur: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, isMobile: false),

              SizedBox(height: 20.h),

              // Horizontal layout with dividers
              Row(
                children: [
                  Expanded(
                    child: _buildTempColumn(
                      context,
                      icon: Icons.arrow_downward_rounded,
                      label: 'Приточный воздух',
                      value: supplyTemp,
                      subtitle: 'Поступление',
                    ),
                  ),

                  _buildVerticalDivider(),

                  Expanded(
                    child: _buildTempColumn(
                      context,
                      icon: Icons.arrow_upward_rounded,
                      label: 'Вытяжной воздух',
                      value: extractTemp,
                      subtitle: 'Удаление',
                    ),
                  ),

                  if (_hasSecondaryData()) ...[
                    _buildVerticalDivider(),

                    Expanded(
                      child: _buildTempColumn(
                        context,
                        icon: Icons.home_outlined,
                        label: 'Помещение',
                        value: indoorTemp ?? outdoorTemp,
                        subtitle: indoorTemp != null ? 'Комната' : 'Улица',
                      ),
                    ),
                  ],
                ],
              ),

              if (_hasAllData()) ...[
                SizedBox(height: 16.h),
                _buildStatusBar(context, isCompact: false),
              ],
            ],
          ),
        ),
      ),
      debugLabel: 'TempDisplay-Tablet',
    );
  }

  // ============================================================================
  // DESKTOP LAYOUT - Full detailed view
  // ============================================================================
  Widget _buildDesktopLayout(BuildContext context) {
    return PerformanceUtils.isolateRepaint(
      SmoothAnimations.fadeIn(
        duration: AnimationDurations.medium,
        child: GlassCard(
          padding: EdgeInsets.all(24.r),
          enableBlur: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isMobile: false, showDetails: true),

              SizedBox(height: 24.h),

              // All 4 temperatures in a row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDetailedTempCard(
                      context,
                      icon: Icons.arrow_downward_rounded,
                      label: 'Приточный воздух',
                      value: supplyTemp,
                      description: 'Температура подаваемого воздуха',
                      isPrimary: true,
                    ),
                  ),

                  SizedBox(width: 16.w),

                  Expanded(
                    flex: 2,
                    child: _buildDetailedTempCard(
                      context,
                      icon: Icons.arrow_upward_rounded,
                      label: 'Вытяжной воздух',
                      value: extractTemp,
                      description: 'Температура удаляемого воздуха',
                      isPrimary: true,
                    ),
                  ),

                  SizedBox(width: 16.w),

                  Expanded(
                    child: _buildDetailedTempCard(
                      context,
                      icon: Icons.wb_sunny_outlined,
                      label: 'Улица',
                      value: outdoorTemp,
                      description: 'Наружный воздух',
                      isPrimary: false,
                    ),
                  ),

                  SizedBox(width: 16.w),

                  Expanded(
                    child: _buildDetailedTempCard(
                      context,
                      icon: Icons.home_outlined,
                      label: 'Комната',
                      value: indoorTemp,
                      description: 'Внутри помещения',
                      isPrimary: false,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              _buildStatusBar(context, isCompact: false, showFullInfo: true),
            ],
          ),
        ),
      ),
      debugLabel: 'TempDisplay-Desktop',
    );
  }

  // ============================================================================
  // COMPONENTS
  // ============================================================================

  /// Minimalist header
  Widget _buildHeader(BuildContext context, {required bool isMobile, bool showDetails = false}) {
    return Row(
      children: [
        // Simple icon without shimmer for calm look
        Container(
          width: isMobile ? 32.w : 36.w,
          height: isMobile ? 32.w : 36.w,
          decoration: BoxDecoration(
            color: AppTheme.neutral300.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppTheme.neutral300.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.thermostat_outlined,
            color: AppTheme.neutral200,
            size: isMobile ? 16.w : 18.w,
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Мониторинг температур',
                style: TextStyle(
                  fontSize: isMobile ? 14.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              if (showDetails) ...[
                SizedBox(height: 2.h),
                Text(
                  'Контроль теплообмена системы вентиляции',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textTertiary,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ],
          ),
        ),

        // System status indicator
        _buildSystemStatus(),
      ],
    );
  }

  /// System status indicator (minimalist)
  Widget _buildSystemStatus() {
    final isNormal = _isSystemNormal();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isNormal
            ? AppTheme.success.withValues(alpha: 0.1)
            : AppTheme.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: isNormal ? AppTheme.success : AppTheme.warning,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            isNormal ? 'Норма' : 'Проверка',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: isNormal ? AppTheme.success : AppTheme.warning,
            ),
          ),
        ],
      ),
    );
  }

  /// Temperature grid for mobile (2x2)
  Widget _buildTemperatureGrid(BuildContext context, {required bool isMobile}) {
    return Column(
      children: [
        // Primary temps (supply & extract)
        Row(
          children: [
            Expanded(
              child: _buildTempTile(
                context,
                icon: Icons.arrow_downward_rounded,
                label: 'Приток',
                value: supplyTemp,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildTempTile(
                context,
                icon: Icons.arrow_upward_rounded,
                label: 'Вытяжка',
                value: extractTemp,
              ),
            ),
          ],
        ),

        // Secondary temps (outdoor & indoor)
        if (_hasSecondaryData()) ...[
          SizedBox(height: 10.h),
          Row(
            children: [
              if (outdoorTemp != null)
                Expanded(
                  child: _buildTempTile(
                    context,
                    icon: Icons.wb_sunny_outlined,
                    label: 'Улица',
                    value: outdoorTemp,
                    isSecondary: true,
                  ),
                ),
              if (outdoorTemp != null && indoorTemp != null)
                SizedBox(width: 10.w),
              if (indoorTemp != null)
                Expanded(
                  child: _buildTempTile(
                    context,
                    icon: Icons.home_outlined,
                    label: 'Комната',
                    value: indoorTemp,
                    isSecondary: true,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  /// Compact temperature tile
  Widget _buildTempTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double? value,
    bool isSecondary = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: isSecondary ? 14.w : 16.w,
                color: AppTheme.neutral200,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSecondary ? 10.sp : 11.sp,
                  color: AppTheme.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value != null ? '${value.toStringAsFixed(1)}°C' : '—',
            style: TextStyle(
              fontSize: isSecondary ? 18.sp : 22.sp,
              fontWeight: FontWeight.w600,
              color: value != null ? AppTheme.textPrimary : AppTheme.textDisabled,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Temperature column for tablet
  Widget _buildTempColumn(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double? value,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24.w,
          color: AppTheme.neutral200,
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppTheme.textTertiary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          value != null ? '${value.toStringAsFixed(1)}°C' : '—',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: value != null ? AppTheme.textPrimary : AppTheme.textDisabled,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  /// Detailed temperature card for desktop
  Widget _buildDetailedTempCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double? value,
    required String description,
    required bool isPrimary,
  }) {
    return Container(
      padding: EdgeInsets.all(isPrimary ? 16.r : 14.r),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isPrimary
              ? AppTheme.neutral300.withValues(alpha: 0.3)
              : AppTheme.backgroundCardBorder,
          width: isPrimary ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppTheme.neutral300.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  size: isPrimary ? 20.w : 18.w,
                  color: AppTheme.neutral200,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: isPrimary ? 12.sp : 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (isPrimary) ...[
                      SizedBox(height: 2.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: isPrimary ? 14.h : 12.h),

          Text(
            value != null ? '${value.toStringAsFixed(1)}°C' : '—',
            style: TextStyle(
              fontSize: isPrimary ? 32.sp : 24.sp,
              fontWeight: FontWeight.w600,
              color: value != null ? AppTheme.textPrimary : AppTheme.textDisabled,
              letterSpacing: -1.5,
            ),
          ),

          if (!isPrimary && description.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 9.sp,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Status bar with additional info
  Widget _buildStatusBar(BuildContext context, {required bool isCompact, bool showFullInfo = false}) {
    final delta = _getTempDelta();
    final efficiency = _getEfficiency();

    return Container(
      padding: EdgeInsets.all(isCompact ? 8.r : 12.r),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildStatusItem(
            icon: Icons.swap_vert,
            label: 'Δ температур',
            value: delta != null ? '${delta.toStringAsFixed(1)}°C' : '—',
            isCompact: isCompact,
          ),

          if (efficiency != null) ...[
            SizedBox(width: isCompact ? 8.w : 12.w),
            Container(
              width: 1,
              height: 20.h,
              color: AppTheme.backgroundCardBorder,
            ),
            SizedBox(width: isCompact ? 8.w : 12.w),
            _buildStatusItem(
              icon: Icons.speed,
              label: 'Эффективность',
              value: '${efficiency.toStringAsFixed(0)}%',
              isCompact: isCompact,
            ),
          ],

          if (showFullInfo) ...[
            SizedBox(width: 12.w),
            Container(
              width: 1,
              height: 20.h,
              color: AppTheme.backgroundCardBorder,
            ),
            SizedBox(width: 12.w),
            _buildStatusItem(
              icon: Icons.check_circle_outline,
              label: 'Статус',
              value: 'Оптимально',
              isCompact: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isCompact,
  }) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isCompact ? 14.w : 16.w,
            color: AppTheme.neutral200,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isCompact ? 9.sp : 10.sp,
                    color: AppTheme.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isCompact ? 12.sp : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      color: AppTheme.backgroundCardBorder,
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  bool _hasAllData() {
    return supplyTemp != null && extractTemp != null;
  }

  bool _hasSecondaryData() {
    return outdoorTemp != null || indoorTemp != null;
  }

  bool _isSystemNormal() {
    if (supplyTemp == null || extractTemp == null) return true;
    final delta = (supplyTemp! - extractTemp!).abs();
    return delta < 15.0; // Normal if delta less than 15°C
  }

  double? _getTempDelta() {
    if (supplyTemp == null || extractTemp == null) return null;
    return (supplyTemp! - extractTemp!).abs();
  }

  double? _getEfficiency() {
    if (supplyTemp == null || extractTemp == null || outdoorTemp == null) return null;
    if (outdoorTemp == supplyTemp) return 100.0;

    final tempDiff = (extractTemp! - outdoorTemp!).abs();
    if (tempDiff == 0) return 0.0;

    final recovered = (supplyTemp! - outdoorTemp!).abs();
    return (recovered / tempDiff * 100).clamp(0.0, 100.0);
  }
}

/// Mini temperature badge for inline use
class TemperatureBadge extends StatelessWidget {
  final double? temperature;
  final String label;

  const TemperatureBadge({
    super.key,
    required this.temperature,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.thermostat_outlined,
            size: 14.w,
            color: AppTheme.neutral200,
          ),
          SizedBox(width: 6.w),
          Text(
            temperature != null ? '${temperature!.toStringAsFixed(1)}°C' : '—',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          if (label.isNotEmpty) ...[
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
