/// Devices Screen - Список всех HVAC устройств
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';
import 'package:hvac_control/presentation/screens/dashboard/dialogs/unit_settings_dialog.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';
import 'package:hvac_control/presentation/widgets/error/error_widgets.dart';
import 'package:hvac_control/presentation/widgets/loading/loading_indicator.dart';
import 'package:hvac_control/presentation/widgets/loading/skeleton.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _DevicesScreenConstants {
  static const double emptyStateIconSize = 80;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Devices screen showing all HVAC units
class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BreezSectionHeader.pageTitle(
                    title: l10n.devices,
                    icon: Icons.devices,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  BlocBuilder<DevicesBloc, DevicesState>(
                    buildWhen: (prev, curr) => prev.deviceCount != curr.deviceCount,
                    builder: (context, state) => Text(
                        l10n.devicesCount(state.deviceCount),
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          color: colors.textMuted,
                        ),
                      ),
                  ),
                ],
              ),
            ),

            // Devices List
            Expanded(
              child: BlocBuilder<DevicesBloc, DevicesState>(
                buildWhen: (prev, curr) =>
                    prev.status != curr.status || prev.devices != curr.devices,
                builder: (context, state) {
                  // Конвертируем DevicesStatus в LoadingStatus
                  LoadingStatus loadingStatus;
                  switch (state.status) {
                    case DevicesStatus.initial:
                    case DevicesStatus.loading:
                      loadingStatus = LoadingStatus.loading;
                    case DevicesStatus.failure:
                      loadingStatus = LoadingStatus.error;
                    case DevicesStatus.success:
                      loadingStatus = LoadingStatus.success;
                  }

                  return LoadingState<List<HvacDevice>>(
                    status: loadingStatus,
                    data: state.devices.isEmpty ? null : state.devices,
                    errorMessage: l10n.errorLoadingFailed,
                    loadingSkeleton: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: SkeletonList.devices(count: 5),
                    ),
                    errorBuilder: (context, error) => NetworkError(
                      onRetry: () {
                        context.read<DevicesBloc>().add(const DevicesSubscriptionRequested());
                      },
                    ),
                    builder: (context, devices) {
                      if (devices.isEmpty) {
                        return _buildEmptyState(context);
                      }

                      return ReorderableListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        buildDefaultDragHandles: false,
                        itemCount: devices.length,
                        onReorder: (oldIndex, newIndex) {
                          context.read<DevicesBloc>().add(
                                DevicesOrderChanged(
                                  oldIndex: oldIndex,
                                  newIndex: newIndex,
                                ),
                              );
                        },
                        proxyDecorator: (child, index, animation) =>
                            AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) => Material(
                                color: Colors.transparent,
                                elevation: animation.value * 4,
                                borderRadius: BorderRadius.circular(AppRadius.card),
                                child: child,
                              ),
                              child: child,
                            ),
                        itemBuilder: (context, index) {
                          final device = devices[index];
                          return _DeviceCard(
                            key: ValueKey(device.id),
                            device: device,
                            index: index,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: BreezCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: _DevicesScreenConstants.emptyStateIconSize,
                height: _DevicesScreenConstants.emptyStateIconSize,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: AppColors.opacitySubtle),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.devices_outlined,
                  size: AppIconSizes.standard,
                  color: colors.accent,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.noDevices,
                style: TextStyle(
                  fontSize: AppFontSizes.h3,
                  fontWeight: FontWeight.bold,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.devicesWillAppear,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// DEVICE CARD
// =============================================================================

/// Карточка устройства с drag handle и меню настроек
class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.index,
    super.key,
  });

  final HvacDevice device;
  final int index;

  Future<void> _showSettingsDialog(BuildContext context) async {
    // Конвертируем HvacDevice в UnitState для диалога
    final unitState = UnitState(
      id: device.id,
      name: device.name,
      macAddress: device.macAddress,
      isOnline: device.isOnline,
      power: device.isActive,
      temp: 22,
      mode: device.operatingMode,
      humidity: 50,
      outsideTemp: 0,
      filterPercent: 100,
    );

    final result = await UnitSettingsDialog.show(context, unitState);

    if (result == null || !context.mounted) {
      return;
    }

    switch (result.action) {
      case UnitSettingsAction.rename:
        if (result.newName != null) {
          context.read<DevicesBloc>().add(
                DevicesRenameRequested(
                  deviceId: device.id,
                  newName: result.newName!,
                ),
              );
        }
      case UnitSettingsAction.delete:
        context.read<DevicesBloc>().add(
              DevicesDeletionRequested(device.id),
            );
      case UnitSettingsAction.setTime:
        if (result.time != null) {
          context.read<DevicesBloc>().add(
                DevicesTimeSetRequested(
                  deviceId: device.id,
                  time: result.time!,
                ),
              );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocSelector<DevicesBloc, DevicesState, bool>(
      selector: (state) => state.togglingPowerDeviceIds.contains(device.id),
      builder: (context, isToggling) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Stack(
          children: [
            BreezCard(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  // Drag handle
                  ReorderableDragStartListener(
                    index: index,
                    child: Icon(
                      Icons.drag_indicator,
                      color: colors.textMuted,
                      size: AppIconSizes.standard,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  // Name, status & MAC
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Status badge
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                device.name,
                                style: TextStyle(
                                  fontSize: AppFontSizes.body,
                                  fontWeight: FontWeight.w600,
                                  color: colors.text,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: AppSpacing.xxs,
                              ),
                              decoration: BoxDecoration(
                                color: device.isOnline
                                    ? AppColors.success.withValues(alpha: AppColors.opacitySubtle)
                                    : colors.textMuted.withValues(alpha: AppColors.opacitySubtle),
                                borderRadius: BorderRadius.circular(AppRadius.chip),
                              ),
                              child: Text(
                                device.isOnline ? l10n.statusOnline : l10n.statusOffline,
                                style: TextStyle(
                                  fontSize: AppFontSizes.captionSmall,
                                  fontWeight: FontWeight.w600,
                                  color: device.isOnline ? AppColors.success : colors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        // MAC address
                        Row(
                          children: [
                            Icon(
                              Icons.router_outlined,
                              size: AppIconSizes.standard,
                              color: colors.textMuted,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              device.macAddress.isNotEmpty ? device.macAddress : device.id,
                              style: TextStyle(
                                fontSize: AppFontSizes.captionSmall,
                                fontFamily: 'monospace',
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Power button
                  BreezIconButton(
                    icon: Icons.power_settings_new,
                    iconColor: device.isActive
                        ? AppColors.accentGreen
                        : colors.textMuted,
                    onTap: isToggling
                        ? null
                        : () {
                            context.read<DevicesBloc>().add(
                                  DevicesPowerToggled(
                                    deviceId: device.id,
                                    isOn: !device.isActive,
                                  ),
                                );
                          },
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  // Schedule button
                  BreezIconButton(
                    icon: Icons.schedule,
                    iconColor: device.isScheduleEnabled
                        ? AppColors.accentGreen
                        : colors.textMuted,
                    onTap: () {
                      context.read<DevicesBloc>().add(
                            DevicesScheduleToggled(
                              deviceId: device.id,
                              enabled: !device.isScheduleEnabled,
                            ),
                          );
                    },
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  // Settings button
                  BreezIconButton(
                    icon: Icons.settings_outlined,
                    onTap: () => _showSettingsDialog(context),
                  ),
                ],
              ),
            ),
            // Loader overlay при переключении питания
            if (isToggling)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.card.withValues(alpha: AppColors.opacityHigh),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: const Center(
                    child: BreezLoader.large(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
