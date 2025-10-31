/// Home Screen
///
/// Dashboard screen showing overview metrics and analytics
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_chart_card.dart';
import '../widgets/dashboard_alert_item.dart';
import '../widgets/dashboard_air_quality.dart';
import '../../domain/entities/hvac_unit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(l10n.hvacControl),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Notification bell
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Navigate to notifications
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // User profile
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
              child: const Icon(
                Icons.person_outline,
                size: 18,
                color: AppTheme.primaryOrange,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HvacListBloc, HvacListState>(
        builder: (context, state) {
          if (state is HvacListLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            );
          }

          if (state is HvacListError) {
            return _buildError(context, state.message, l10n);
          }

          if (state is HvacListLoaded) {
            if (state.units.isEmpty) {
              return _buildEmpty(context, l10n);
            }

            return _buildDashboard(context, state.units, l10n);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, String message, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.connectionError,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HvacListBloc>().add(const RetryConnectionEvent());
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retryConnection),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.devices_other,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noDevicesFound,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.checkMqttSettings,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HvacListBloc>().add(const LoadHvacUnitsEvent());
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retryConnection),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    List<HvacUnit> units,
    AppLocalizations l10n,
  ) {
    // Calculate metrics
    final totalUnits = units.length;
    final activeUnits = units.where((u) => u.power).length;
    final alertCount = units.where((u) => u.currentTemp > 28 || u.currentTemp < 18).length;
    // Mock efficiency percentage (in real app, calculate from actual metrics)
    final avgEfficiency = units.isNotEmpty
        ? ((activeUnits / totalUnits) * 85).toInt()
        : 0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left column - Overview stats (2x2)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Total Units',
                          value: totalUnits.toString(),
                          icon: Icons.devices,
                          iconColor: AppTheme.primaryOrange,
                          subtitle: 'Installations',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Active Now',
                          value: activeUnits.toString(),
                          icon: Icons.power_settings_new,
                          iconColor: AppTheme.success,
                          trend: totalUnits > 0
                              ? '${((activeUnits / totalUnits) * 100).toStringAsFixed(0)}%'
                              : null,
                          isPositiveTrend: true,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Alerts',
                          value: alertCount.toString(),
                          icon: Icons.warning,
                          iconColor: alertCount > 0 ? AppTheme.error : AppTheme.textTertiary,
                          subtitle: alertCount > 0 ? 'Requires attention' : 'All good',
                          trend: alertCount > 0 ? '+$alertCount' : null,
                          isPositiveTrend: false,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Efficiency',
                          value: '$avgEfficiency%',
                          icon: Icons.energy_savings_leaf,
                          iconColor: AppTheme.info,
                          trend: '+5%',
                          isPositiveTrend: true,
                          subtitle: 'vs last week',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Middle column - Charts and Air Quality
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: DashboardChartCard(
                    title: 'Performance Trend',
                    subtitle: 'Last 7 days',
                    chart: const SimpleLineChart(
                      data: [65, 72, 68, 75, 80, 77, 82],
                      color: AppTheme.primaryOrange,
                      height: 100,
                    ),
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 2,
                  child: DashboardChartCard(
                    title: 'Status Distribution',
                    subtitle: 'Current device modes',
                    chart: SimplePieChart(
                      data: _getStatusDistribution(units),
                      size: 100,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Right column - Alerts and Air Quality
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: DashboardAirQuality(
                    aqi: 45,
                    location: 'Overall average',
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: AppTheme.deviceCard(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Alerts',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('View all'),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: AppTheme.backgroundCardBorder),
                        Expanded(
                          child: alertCount > 0
                              ? ListView(
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    DashboardAlertItem(
                                      title: 'High Temperature',
                                      message: 'Living Room unit exceeded 28°C',
                                      timestamp: '5 min ago',
                                      severity: AlertSeverity.warning,
                                      onTap: () {},
                                    ),
                                    const Divider(height: 1, color: AppTheme.backgroundCardBorder),
                                    DashboardAlertItem(
                                      title: 'Maintenance Due',
                                      message: 'Bedroom unit filter replacement',
                                      timestamp: '2 hours ago',
                                      severity: AlertSeverity.info,
                                      onTap: () {},
                                    ),
                                    const Divider(height: 1, color: AppTheme.backgroundCardBorder),
                                    DashboardAlertItem(
                                      title: 'Connection Lost',
                                      message: 'Office unit offline',
                                      timestamp: '1 day ago',
                                      severity: AlertSeverity.critical,
                                      onTap: () {},
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 48,
                                        color: AppTheme.success.withValues(alpha: 0.5),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No alerts',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'All systems operating normally',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppTheme.textSecondary,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartData> _getStatusDistribution(List<HvacUnit> units) {
    final modeCount = <String, int>{};
    for (final unit in units) {
      modeCount[unit.mode] = (modeCount[unit.mode] ?? 0) + 1;
    }

    return modeCount.entries.map((entry) {
      return PieChartData(
        label: entry.key.toUpperCase(),
        value: entry.value.toDouble(),
        color: AppTheme.getModeColor(entry.key),
      );
    }).toList();
  }
}
