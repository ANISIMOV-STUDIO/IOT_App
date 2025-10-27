/// HVAC Detail Screen - iOS 26 Liquid Glass Design
///
/// Modern glass-effect HVAC control interface
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/liquid_glass_theme.dart';
import '../../core/utils/responsive_utils.dart';
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
    final isWeb = ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isTablet(context);

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
                child: isWeb
                    ? Center(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.all(ResponsiveUtils.scaledSpacing(context, 20)),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 1100,
                            ),
                            child: _buildWebLayout(context, isDark, size, l10n),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(ResponsiveUtils.scaledSpacing(context, 20)),
                        child: _buildMobileLayout(context, isDark, size, l10n),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mobile layout - vertical
  Widget _buildMobileLayout(
    BuildContext context,
    bool isDark,
    Size size,
    AppLocalizations l10n,
  ) {
    return Column(
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
    );
  }

  // Web layout - compact grid
  Widget _buildWebLayout(
    BuildContext context,
    bool isDark,
    Size size,
    AppLocalizations l10n,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - compact temperature control
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildTemperatureControl(context, isDark, size, compact: true),
              const SizedBox(height: 24),
              _buildCurrentTemperature(context, isDark),
            ],
          ),
        ),
        const SizedBox(width: 24),

        // Right side - controls
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildModeSelector(context, isDark, l10n),
              const SizedBox(height: 20),
              _buildFanSpeedControl(context, isDark, l10n),
              const SizedBox(height: 20),
              _buildPowerToggle(context, isDark, l10n),
            ],
          ),
        ),
      ],
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
    Size size, {
    bool compact = false,
  }) {
    final modeGradient = LiquidGlassTheme.getModeGradient(
      unit.mode,
      isDark: isDark,
    );

    // Responsive sizing
    final circleSize = compact ? 340.0 : (size.width * 0.8).clamp(280.0, 400.0);
    final fontSize = compact ? 64.0 : ResponsiveUtils.scaledFontSize(context, 72);

    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: circleSize * 0.95,
            height: circleSize * 0.95,
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
            width: circleSize * 0.88,
            height: circleSize * 0.88,
            padding: EdgeInsets.all(compact ? 24 : 32),
            borderRadius: circleSize * 0.44,
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
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: modeGradient,
                          ).createShader(
                            const Rect.fromLTWH(0, 0, 200, 100),
                          ),
                      ),
                ),

                SizedBox(height: compact ? 6 : 8),

                // Mode indicator
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 12 : 16,
                    vertical: compact ? 4 : 6,
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

                SizedBox(width: compact ? 40 : 60),

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
