/// Home Screen - iOS 26 Liquid Glass Design
///
/// Modern home screen with glass effect device cards
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/liquid_glass_theme.dart';
import '../../core/utils/responsive_utils.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/di/injection_container.dart' as di;
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../bloc/hvac_detail/hvac_detail_bloc.dart';
import '../widgets/liquid_glass_container.dart';
import '../../domain/entities/hvac_unit.dart';
import 'liquid_glass_hvac_detail.dart';
import 'qr_scanner_screen.dart';
import 'device_management_screen.dart';

class LiquidGlassHomeScreen extends StatelessWidget {
  const LiquidGlassHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? LiquidGlassTheme.darkGradient
                : LiquidGlassTheme.lightGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark, l10n),

              // Content
              Expanded(
                child: BlocBuilder<HvacListBloc, HvacListState>(
                  builder: (context, state) {
                    if (state is HvacListLoading) {
                      return _buildLoading(context);
                    }

                    if (state is HvacListError) {
                      return _buildError(context, state.message, l10n);
                    }

                    if (state is HvacListLoaded) {
                      if (state.units.isEmpty) {
                        return _buildEmpty(context, l10n);
                      }

                      return _buildDeviceGrid(context, state.units, isDark);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.hvacControl,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<HvacListBloc, HvacListState>(
                      builder: (context, state) {
                        if (state is HvacListLoaded) {
                          final activeCount = state.units.where((u) => u.power).length;
                          return Text(
                            l10n.activeDevices(activeCount, state.units.length),
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

              // Action buttons
              Row(
                children: [
                  // QR Scanner
                  LiquidGlassContainer(
                    width: 48,
                    height: 48,
                    padding: EdgeInsets.zero,
                    borderRadius: 24,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<HvacListBloc>(),
                            child: const QrScannerScreen(),
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.qr_code_scanner, size: 22),
                  ),

                  const SizedBox(width: 12),

                  // Device Management
                  LiquidGlassContainer(
                    width: 48,
                    height: 48,
                    padding: EdgeInsets.zero,
                    borderRadius: 24,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<HvacListBloc>(),
                            child: const DeviceManagementScreen(),
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.add, size: 22),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(BuildContext context, String message, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: LiquidGlassContainer(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      LiquidGlassTheme.glassRed,
                      LiquidGlassTheme.glassOrange,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.white,
                ),
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
              LiquidGlassButton(
                text: l10n.retryConnection,
                icon: Icons.refresh,
                onPressed: () {
                  context.read<HvacListBloc>().add(const RetryConnectionEvent());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: LiquidGlassContainer(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      LiquidGlassTheme.glassBlue,
                      LiquidGlassTheme.glassTeal,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.devices_other,
                  size: 48,
                  color: Colors.white,
                ),
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
              LiquidGlassButton(
                text: l10n.addDevice,
                icon: Icons.add,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<HvacListBloc>(),
                        child: const QrScannerScreen(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceGrid(BuildContext context, List<HvacUnit> units, bool isDark) {
    final columnCount = ResponsiveUtils.getGridColumnCount(context, mobile: 2);
    final spacing = ResponsiveUtils.scaledSpacing(context, 16);
    final padding = ResponsiveUtils.scaledSpacing(context, 20);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HvacListBloc>().add(const RefreshHvacUnitsEvent());
      },
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(padding, padding * 0.4, padding, padding),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 0.85,
        ),
        itemCount: units.length,
        itemBuilder: (context, index) {
          return _LiquidGlassDeviceCard(unit: units[index]);
        },
      ),
    );
  }
}

class _LiquidGlassDeviceCard extends StatelessWidget {
  final HvacUnit unit;

  const _LiquidGlassDeviceCard({required this.unit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modeGradient = LiquidGlassTheme.getModeGradient(unit.mode, isDark: isDark);

    // Responsive scaling for web
    final tempFontSize = ResponsiveUtils.scaledFontSize(context, 56);
    final labelFontSize = ResponsiveUtils.scaledFontSize(context, 17);

    return LiquidGlassCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider<HvacDetailBloc>(
              create: (_) => di.sl<HvacDetailBloc>(param1: unit.id),
              child: LiquidGlassHvacDetail(unitId: unit.id),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit.name,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: labelFontSize,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (unit.location != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        unit.location!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: labelFontSize * 0.7,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Power indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: unit.power
                      ? LiquidGlassTheme.glassGreen
                      : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.3),
                  boxShadow: unit.power
                      ? [
                          BoxShadow(
                            color: LiquidGlassTheme.glassGreen.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Temperature display
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Large temperature
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: modeGradient,
                    ).createShader(bounds),
                    child: Text(
                      '${unit.currentTemp.toInt()}°',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: tempFontSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                    ),
                  ),

                  // Mode badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: modeGradient),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unit.mode.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Footer with target temp and humidity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(
                context,
                icon: Icons.thermostat,
                label: '${unit.targetTemp.toInt()}°',
              ),
              _buildInfoChip(
                context,
                icon: Icons.water_drop,
                label: '${unit.humidity.toInt()}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, {required IconData icon, required String label}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
