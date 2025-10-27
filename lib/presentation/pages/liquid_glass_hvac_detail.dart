/// HVAC Detail Screen - iOS 26 Liquid Glass Design
///
/// Modern glass-effect HVAC control interface
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/liquid_glass_theme.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/hvac_detail/hvac_detail_bloc.dart';
import '../bloc/hvac_detail/hvac_detail_event.dart';
import '../bloc/hvac_detail/hvac_detail_state.dart';
import '../widgets/liquid_glass_container.dart';

class LiquidGlassHvacDetail extends StatelessWidget {
  final String unitId;

  const LiquidGlassHvacDetail({
    super.key,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HvacDetailBloc, HvacDetailState>(
      builder: (context, state) {
        if (state is HvacDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is HvacDetailError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        if (state is HvacDetailLoaded) {
          return _LiquidGlassHvacDetailContent(unit: state.unit);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _LiquidGlassHvacDetailContent extends StatelessWidget {
  final HvacUnit unit;

  const _LiquidGlassHvacDetailContent({required this.unit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    // Background gradient
    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? LiquidGlassTheme.darkGradient
          : LiquidGlassTheme.lightGradient,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Main circular temperature control
                      _buildTemperatureControl(context, isDark, size),

                      const SizedBox(height: 32),

                      // Current temperature display
                      _buildCurrentTemperature(context, isDark),

                      const SizedBox(height: 32),

                      // Mode selector cards
                      _buildModeSelector(context, isDark, l10n),

                      const SizedBox(height: 24),

                      // Fan speed control
                      _buildFanSpeedControl(context, isDark, l10n),

                      const SizedBox(height: 24),

                      // Power toggle
                      _buildPowerToggle(context, isDark, l10n),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Back button
          LiquidGlassContainer(
            width: 44,
            height: 44,
            padding: EdgeInsets.zero,
            borderRadius: 22,
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),

          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (unit.location != null)
                  Text(
                    unit.location!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
          ),

          // More options
          LiquidGlassContainer(
            width: 44,
            height: 44,
            padding: EdgeInsets.zero,
            borderRadius: 22,
            onTap: () {},
            child: const Icon(Icons.more_horiz, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureControl(
    BuildContext context,
    bool isDark,
    Size size,
  ) {
    final modeGradient = LiquidGlassTheme.getModeGradient(
      unit.mode,
      isDark: isDark,
    );

    return SizedBox(
      width: size.width * 0.8,
      height: size.width * 0.8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: size.width * 0.75,
            height: size.width * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  modeGradient[0].withValues(alpha: 0.3),
                  modeGradient[1].withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Main circular control
          LiquidGlassContainer(
            width: size.width * 0.7,
            height: size.width * 0.7,
            padding: const EdgeInsets.all(32),
            borderRadius: size.width * 0.35,
            gradient: [
              (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
              (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
            ],
            borderColor: modeGradient[0].withValues(alpha: 0.3),
            borderWidth: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Temperature value
                Text(
                  '${unit.targetTemp.toInt()}°',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 72,
                        fontWeight: FontWeight.w700,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: modeGradient,
                          ).createShader(
                            const Rect.fromLTWH(0, 0, 200, 100),
                          ),
                      ),
                ),

                const SizedBox(height: 8),

                // Mode indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: modeGradient),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    unit.mode.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Temperature adjustment buttons
          Positioned(
            bottom: 0,
            child: Row(
              children: [
                // Decrease
                _buildTempButton(
                  context,
                  icon: Icons.remove,
                  onTap: () {
                    if (unit.targetTemp > 16) {
                      context.read<HvacDetailBloc>().add(
                            UpdateTargetTempEvent(unit.targetTemp - 1),
                          );
                    }
                  },
                ),

                const SizedBox(width: 60),

                // Increase
                _buildTempButton(
                  context,
                  icon: Icons.add,
                  onTap: () {
                    if (unit.targetTemp < 30) {
                      context.read<HvacDetailBloc>().add(
                            UpdateTargetTempEvent(unit.targetTemp + 1),
                          );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return LiquidGlassCard(
      width: 56,
      height: 56,
      padding: EdgeInsets.zero,
      borderRadius: 28,
      onTap: onTap,
      child: Icon(icon, size: 24),
    );
  }

  Widget _buildCurrentTemperature(BuildContext context, bool isDark) {
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTempInfo(
            context,
            label: 'Current',
            value: '${unit.currentTemp.toInt()}°C',
            icon: Icons.thermostat,
          ),
          Container(
            width: 1,
            height: 40,
            color: (isDark ? Colors.white : Colors.black)
                .withValues(alpha: 0.1),
          ),
          _buildTempInfo(
            context,
            label: 'Humidity',
            value: '${unit.humidity.toInt()}%',
            icon: Icons.water_drop,
          ),
        ],
      ),
    );
  }

  Widget _buildTempInfo(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildModeSelector(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final modes = [
      {'mode': 'Cooling', 'icon': Icons.ac_unit, 'label': l10n.cooling},
      {'mode': 'Heating', 'icon': Icons.local_fire_department, 'label': l10n.heating},
      {'mode': 'Auto', 'icon': Icons.auto_mode, 'label': l10n.auto},
      {'mode': 'Fan', 'icon': Icons.air, 'label': l10n.fan},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: modes.length,
      itemBuilder: (context, index) {
        final mode = modes[index];
        final isSelected = unit.mode.toLowerCase() == mode['mode'].toString().toLowerCase();
        final modeGradient = LiquidGlassTheme.getModeGradient(
          mode['mode'] as String,
          isDark: isDark,
        );

        return LiquidGlassCard(
          gradient: isSelected ? modeGradient : null,
          onTap: () {
            context.read<HvacDetailBloc>().add(
                  UpdateModeEvent(mode['mode'] as String),
                );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                mode['icon'] as IconData,
                size: 32,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).iconTheme.color,
              ),
              const SizedBox(height: 8),
              Text(
                mode['label'] as String,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFanSpeedControl(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final speeds = ['Low', 'Medium', 'High', 'Auto'];

    return LiquidGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.air,
                size: 20,
                color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.fanSpeed,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: speeds.map((speed) {
              final isSelected = unit.fanSpeed.toLowerCase() == speed.toLowerCase();
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: LiquidGlassCard(
                    height: 44,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    gradient: isSelected
                        ? [
                            LiquidGlassTheme.glassBlue,
                            LiquidGlassTheme.glassTeal,
                          ]
                        : null,
                    onTap: () {
                      context.read<HvacDetailBloc>().add(
                            UpdateFanSpeedEvent(speed),
                          );
                    },
                    child: Center(
                      child: Text(
                        speed,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerToggle(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return LiquidGlassButton(
      text: unit.power ? l10n.off.toUpperCase() : l10n.on.toUpperCase(),
      icon: Icons.power_settings_new,
      width: double.infinity,
      height: 60,
      color: unit.power ? LiquidGlassTheme.glassRed : LiquidGlassTheme.glassGreen,
      onPressed: () {
        context.read<HvacDetailBloc>().add(
              UpdatePowerEvent(!unit.power),
            );
      },
    );
  }
}
