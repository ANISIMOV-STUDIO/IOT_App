/// Devices Screen - Список всех HVAC устройств
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/common/device_icon_helper.dart';
import 'package:hvac_control/presentation/widgets/error/error_widgets.dart';
import 'package:hvac_control/presentation/widgets/loading/loading_indicator.dart';
import 'package:hvac_control/presentation/widgets/loading/skeleton.dart';

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
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.devices,
                    style: TextStyle(
                      fontSize: AppFontSizes.h2,
                      fontWeight: FontWeight.bold,
                      color: colors.text,
                    ),
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
                      padding: const EdgeInsets.all(AppSpacing.lg),
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

                      return ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: devices.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final device = devices[index];
                          return BreezCard(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppRadius.button),
                                  ),
                                  child: Icon(
                                    device.icon, // Использует extension из device_icon_helper
                                    color: device.isOnline ? AppColors.accent : colors.textMuted,
                                    size: AppIconSizes.standard,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        device.name,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.body,
                                          fontWeight: FontWeight.w600,
                                          color: colors.text,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xxs),
                                      Text(
                                        device.brand,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.caption,
                                          color: colors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xxs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: device.isOnline
                                        ? AppColors.success.withValues(alpha: 0.1)
                                        : colors.textMuted.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppRadius.chip),
                                  ),
                                  child: Text(
                                    device.isOnline ? l10n.statusOnline : l10n.statusOffline,
                                    style: TextStyle(
                                      fontSize: AppFontSizes.caption,
                                      fontWeight: FontWeight.w600,
                                      color: device.isOnline ? AppColors.success : colors.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.devices_outlined,
                  size: AppIconSizes.standard,
                  color: AppColors.accent,
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
