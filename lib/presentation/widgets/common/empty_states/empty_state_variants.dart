/// Empty State Variants
/// Specific empty state implementations
library;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../animated_button.dart';
import 'base_empty_state.dart';
import 'animated_icons.dart';

/// No devices empty state
class NoDevicesEmptyState extends StatelessWidget {
  final VoidCallback? onAddDevice;

  const NoDevicesEmptyState({
    super.key,
    this.onAddDevice,
  });

  @override
  Widget build(BuildContext context) {
    return BaseEmptyState(
      icon: const AnimatedDeviceIcon(),
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
    return BaseEmptyState(
      icon: const AnimatedChartIcon(),
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

/// No notifications empty state
class NoNotificationsEmptyState extends StatelessWidget {
  const NoNotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseEmptyState(
      icon: AnimatedBellIcon(),
      title: 'Нет уведомлений',
      subtitle: 'Важные события появятся здесь',
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
    return BaseEmptyState(
      icon: const AnimatedSearchIcon(),
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

/// Offline empty state
class OfflineEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;

  const OfflineEmptyState({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BaseEmptyState(
      icon: const AnimatedWifiIcon(),
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
    return BaseEmptyState(
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
    return BaseEmptyState(
      icon: const PermissionIcon(),
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
    return const BaseEmptyState(
      icon: AnimatedMaintenanceIcon(),
      title: 'Техническое обслуживание',
      subtitle: 'Сервис временно недоступен.\nПопробуйте позже.',
    );
  }
}