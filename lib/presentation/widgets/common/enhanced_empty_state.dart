/// Enhanced Empty State Widgets
/// Beautiful empty states with animations and illustrations
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/spacing.dart';
import 'animated_button.dart';

/// Base empty state widget with customizable content
class EnhancedEmptyState extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsets? padding;
  final bool enableAnimation;

  const EnhancedEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.padding,
    this.enableAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppSpacing.xlR),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(height: AppSpacing.lgR),
            Text(
              title,
              style: AppTypography.h4,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: AppSpacing.smR),
              Text(
                subtitle!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: AppSpacing.xlR),
              action!,
            ],
          ],
        ),
      ),
    );

    if (enableAnimation) {
      content = content
          .animate()
          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
          .slideY(
            begin: 0.1,
            end: 0,
            duration: 500.ms,
            curve: Curves.easeOut,
          );
    }

    return content;
  }
}

/// No devices empty state
class NoDevicesEmptyState extends StatelessWidget {
  final VoidCallback? onAddDevice;

  const NoDevicesEmptyState({
    super.key,
    this.onAddDevice,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyState(
      icon: _AnimatedDeviceIcon(),
      title: 'Нет устройств',
      subtitle: 'Добавьте первое устройство\nчтобы начать управление климатом',
      action: onAddDevice != null
          ? AnimatedPrimaryButton(
              label: 'Добавить устройство',
              icon: Icons.add_circle_outline,
              onPressed: onAddDevice!,
            )
          : null,
    );
  }
}

class _AnimatedDeviceIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.r,
      height: 120.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryOrange.withValues(alpha: 0.1),
      ),
      child: Icon(
        Icons.devices_other,
        size: 60.r,
        color: AppTheme.primaryOrange.withValues(alpha: 0.5),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 2000.ms, delay: 500.ms)
        .shake(hz: 0.5, curve: Curves.easeInOut);
  }
}

/// No data empty state
class NoDataEmptyState extends StatelessWidget {
  final String? customMessage;
  final VoidCallback? onRefresh;

  const NoDataEmptyState({
    super.key,
    this.customMessage,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyState(
      icon: _AnimatedChartIcon(),
      title: 'Нет данных',
      subtitle: customMessage ??
          'Данные появятся здесь\nкогда устройство начнет работу',
      action: onRefresh != null
          ? AnimatedOutlineButton(
              label: 'Обновить',
              icon: Icons.refresh,
              onPressed: onRefresh!,
            )
          : null,
    );
  }
}

class _AnimatedChartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120.r,
          height: 120.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryOrange.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
        ),
        Icon(
          Icons.insert_chart_outlined,
          size: 60.r,
          color: AppTheme.textTertiary,
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 1000.ms)
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 1500.ms,
              curve: Curves.elasticOut,
            ),
      ],
    );
  }
}

/// No notifications empty state
class NoNotificationsEmptyState extends StatelessWidget {
  const NoNotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyState(
      icon: _AnimatedBellIcon(),
      title: 'Нет уведомлений',
      subtitle: 'Важные события появятся здесь',
    );
  }
}

class _AnimatedBellIcon extends StatefulWidget {
  @override
  State<_AnimatedBellIcon> createState() => _AnimatedBellIconState();
}

class _AnimatedBellIconState extends State<_AnimatedBellIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 0.05),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.05, end: -0.05),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.05, end: 0.05),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.05, end: 0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0),
        weight: 10,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) => Transform.rotate(
        angle: _rotationAnimation.value,
        child: Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryOrange.withValues(alpha: 0.1),
                AppTheme.primaryOrange.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            Icons.notifications_none,
            size: 50.r,
            color: AppTheme.textTertiary,
          ),
        ),
      ),
    );
  }
}

/// Search empty state
class NoSearchResultsEmptyState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;

  const NoSearchResultsEmptyState({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyState(
      icon: _AnimatedSearchIcon(),
      title: 'Ничего не найдено',
      subtitle: 'По запросу "$searchQuery"\nне найдено результатов',
      action: onClearSearch != null
          ? AnimatedOutlineButton(
              label: 'Очистить поиск',
              icon: Icons.clear,
              onPressed: onClearSearch!,
            )
          : null,
    );
  }
}

class _AnimatedSearchIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.backgroundCard,
            border: Border.all(
              color: AppTheme.backgroundCardBorder,
              width: 2,
            ),
          ),
        ),
        Icon(
          Icons.search_off,
          size: 50.r,
          color: AppTheme.textTertiary,
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn(duration: 1000.ms)
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
              duration: 2000.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }
}

/// Offline empty state
class OfflineEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;

  const OfflineEmptyState({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyState(
      icon: _AnimatedWifiIcon(),
      title: 'Нет соединения',
      subtitle: 'Проверьте подключение к интернету\nи повторите попытку',
      action: onRetry != null
          ? AnimatedPrimaryButton(
              label: 'Повторить',
              icon: Icons.refresh,
              onPressed: onRetry!,
            )
          : null,
    );
  }
}

class _AnimatedWifiIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.wifi_off,
          size: 80.r,
          color: AppTheme.error.withValues(alpha: 0.5),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 500.ms)
            .then()
            .shake(hz: 2, curve: Curves.easeInOut)
            .then(delay: 2000.ms),
      ],
    );
  }
}

/// Custom lottie empty state
class LottieEmptyState extends StatelessWidget {
  final String lottieAsset;
  final String title;
  final String? subtitle;
  final Widget? action;
  final double? lottieSize;

  const LottieEmptyState({
    super.key,
    required this.lottieAsset,
    required this.title,
    this.subtitle,
    this.action,
    this.lottieSize,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyState(
      icon: Lottie.asset(
        lottieAsset,
        width: lottieSize ?? 200.r,
        height: lottieSize ?? 200.r,
        repeat: true,
        animate: true,
      ),
      title: title,
      subtitle: subtitle,
      action: action,
    );
  }
}

/// Permission denied empty state
class PermissionDeniedEmptyState extends StatelessWidget {
  final String permissionType;
  final VoidCallback? onRequestPermission;

  const PermissionDeniedEmptyState({
    super.key,
    required this.permissionType,
    this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyState(
      icon: Container(
        width: 100.r,
        height: 100.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.warning.withValues(alpha: 0.1),
        ),
        child: Icon(
          Icons.lock_outline,
          size: 50.r,
          color: AppTheme.warning,
        ),
      ),
      title: 'Требуется разрешение',
      subtitle: 'Для работы функции необходимо\nразрешение на $permissionType',
      action: onRequestPermission != null
          ? AnimatedPrimaryButton(
              label: 'Предоставить доступ',
              icon: Icons.security,
              onPressed: onRequestPermission!,
            )
          : null,
    );
  }
}

/// Maintenance empty state
class MaintenanceEmptyState extends StatelessWidget {
  const MaintenanceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyState(
      icon: Icon(
        Icons.construction,
        size: 80.r,
        color: AppTheme.warning,
      )
          .animate(onPlay: (controller) => controller.repeat())
          .rotate(duration: 3000.ms, curve: Curves.linear),
      title: 'Техническое обслуживание',
      subtitle: 'Сервис временно недоступен.\nПопробуйте позже.',
    );
  }
}