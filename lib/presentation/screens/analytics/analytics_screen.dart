/// Analytics Screen - Statistics and graphs
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../widgets/breez/breez_card.dart';
import '../../widgets/breez/operation_graph.dart';
import '../../widgets/loading/skeleton.dart';

/// Analytics screen with graphs and statistics
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () async {
            context.read<DashboardBloc>().add(const DashboardRefreshed());
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Аналитика',
                  style: TextStyle(
                    fontSize: AppFontSizes.h2,
                    fontWeight: FontWeight.bold,
                    color: colors.text,
                  ),
                ),
              ),
            ),

            // Energy Stats Cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    // Показываем skeleton при загрузке
                    if (state.status == DashboardStatus.loading ||
                        state.status == DashboardStatus.initial) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final isDesktop = width > 900;

                          return isDesktop
                              ? const Row(
                                  children: [
                                    Expanded(child: SkeletonStatCard()),
                                    SizedBox(width: AppSpacing.lg),
                                    Expanded(child: SkeletonStatCard()),
                                    SizedBox(width: AppSpacing.lg),
                                    Expanded(child: SkeletonStatCard()),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    SkeletonStatCard(),
                                    SizedBox(height: AppSpacing.md),
                                    SkeletonStatCard(),
                                    SizedBox(height: AppSpacing.md),
                                    SkeletonStatCard(),
                                  ],
                                );
                        },
                      );
                    }

                    final stats = state.energyStats;
                    final totalKwh = stats?.totalKwh ?? 0.0;
                    final totalHours = stats?.totalHours ?? 0;


                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final isDesktop = width > 900;

                        return isDesktop
                            ? Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      context,
                                      'Сегодня',
                                      '${totalKwh.toStringAsFixed(1)} кВт⋅ч',
                                      Icons.today,
                                      AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.lg),
                                  Expanded(
                                    child: _buildStatCard(
                                      context,
                                      'Этот месяц',
                                      '$totalHours часов',
                                      Icons.calendar_month,
                                      AppColors.success,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.lg),
                                  Expanded(
                                    child: _buildStatCard(
                                      context,
                                      'Общее время',
                                      '',
                                      Icons.power,
                                      AppColors.warning,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildStatCard(
                                    context,
                                    'Сегодня',
                                    '${totalKwh.toStringAsFixed(1)} кВт⋅ч',
                                    Icons.today,
                                    AppColors.accent,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  _buildStatCard(
                                    context,
                                    'Этот месяц',
                                    '$totalHours часов',
                                    Icons.calendar_month,
                                    AppColors.success,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  _buildStatCard(
                                    context,
                                    'Общее время',
                                    '',
                                    Icons.power,
                                    AppColors.warning,
                                  ),
                                ],
                              );
                      },
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),

            // Metric Selector
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildMetricChip(
                            context,
                            'Температура',
                            Icons.thermostat,
                            GraphMetric.temperature,
                            state.selectedGraphMetric,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _buildMetricChip(
                            context,
                            'Влажность',
                            Icons.water_drop,
                            GraphMetric.humidity,
                            state.selectedGraphMetric,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _buildMetricChip(
                            context,
                            'Поток воздуха',
                            Icons.bolt,
                            GraphMetric.airflow,
                            state.selectedGraphMetric,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.lg),
            ),

            // Graph
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    // Показываем skeleton графика при загрузке
                    if (state.status == DashboardStatus.loading ||
                        state.status == DashboardStatus.initial) {
                      return const SkeletonGraph(height: 300);
                    }

                    return OperationGraph(
                      data: state.graphData,
                    );
                  },
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final colors = BreezColors.of(context);

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppFontSizes.h3,
                    fontWeight: FontWeight.bold,
                    color: colors.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(
    BuildContext context,
    String label,
    IconData icon,
    GraphMetric metric,
    GraphMetric selectedMetric,
  ) {
    final colors = BreezColors.of(context);
    final isSelected = metric == selectedMetric;

    return BreezButton(
      onTap: () {
        context.read<DashboardBloc>().add(GraphMetricChanged(metric));
      },
      backgroundColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.15)
          : Colors.transparent,
      hoverColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.25)
          : colors.buttonBg,
      border: Border.all(
        color: isSelected
            ? AppColors.accent.withValues(alpha: 0.3)
            : colors.border,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? AppColors.accent : colors.textMuted,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.accent : colors.text,
            ),
          ),
        ],
      ),
    );
  }
}
