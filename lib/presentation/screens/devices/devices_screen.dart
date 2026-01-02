/// Devices Screen - Список всех HVAC устройств
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/hvac_device.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../widgets/breez/breez_card.dart';
import '../../widgets/common/device_icon_helper.dart';
import '../../widgets/loading/loading_indicator.dart';
import '../../widgets/loading/skeleton.dart';
import '../../widgets/error/error_widgets.dart';

/// Devices screen showing all HVAC units
class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

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
                    'Устройства',
                    style: TextStyle(
                      fontSize: AppFontSizes.h2,
                      fontWeight: FontWeight.bold,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      final deviceCount = state.hvacDevices.length;
                      return Text(
                        '$deviceCount устройств',
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          color: colors.textMuted,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Devices List
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  // Конвертируем DashboardStatus в LoadingStatus
                  LoadingStatus loadingStatus;
                  switch (state.status) {
                    case DashboardStatus.initial:
                    case DashboardStatus.loading:
                      loadingStatus = LoadingStatus.loading;
                      break;
                    case DashboardStatus.failure:
                      loadingStatus = LoadingStatus.error;
                      break;
                    case DashboardStatus.success:
                      loadingStatus = LoadingStatus.success;
                      break;
                  }

                  return LoadingState<List<HvacDevice>>(
                    status: loadingStatus,
                    data: state.hvacDevices.isEmpty ? null : state.hvacDevices,
                    errorMessage: 'Не удалось загрузить устройства',
                    loadingSkeleton: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: SkeletonList.devices(count: 5),
                    ),
                    errorBuilder: (context, error) => NetworkError(
                      onRetry: () {
                        context.read<DashboardBloc>().add(const DashboardRefreshed());
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    device.icon, // Использует extension из device_icon_helper
                                    color: device.isOnline ? AppColors.accent : colors.textMuted,
                                    size: 24,
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
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    device.isOnline ? 'Онлайн' : 'Оффлайн',
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
                  size: 40,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Нет устройств',
                style: TextStyle(
                  fontSize: AppFontSizes.h3,
                  fontWeight: FontWeight.bold,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Устройства появятся здесь после подключения',
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
