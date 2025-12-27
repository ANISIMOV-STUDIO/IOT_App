import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';
import 'temperature_dial.dart';
import 'mode_selector.dart';

/// Main climate control card (unified style for mobile & desktop)
class ClimateCard extends StatelessWidget {
  final String unitName;
  final bool isPowered;
  final bool isLoading;
  final int temperature;
  final int supplyFan;
  final int exhaustFan;
  final int filterPercent;
  final int airflowRate;
  final int? humidity;
  final int? outsideTemp;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final VoidCallback? onPowerTap;
  final VoidCallback? onSettingsTap;
  // Mode selector parameters
  final String? selectedMode;
  final ValueChanged<String>? onModeChanged;
  final bool showModeSelector;

  const ClimateCard({
    super.key,
    required this.unitName,
    required this.isPowered,
    this.isLoading = false,
    required this.temperature,
    required this.supplyFan,
    required this.exhaustFan,
    this.filterPercent = 88,
    this.airflowRate = 420,
    this.humidity = 45,
    this.outsideTemp,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onPowerTap,
    this.onSettingsTap,
    this.selectedMode,
    this.onModeChanged,
    this.showModeSelector = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width > 600;
    final isCompact = width < 400;

    // Adaptive padding based on screen size
    final padding = isCompact ? 16.0 : (isWide ? 24.0 : 20.0);

    // Theme-aware gradients
    final poweredGradient = isDark
        ? [const Color(0xFF1E3A5F), const Color(0xFF0F2847)]
        : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)];
    final offGradient = [colors.card, colors.card];

    // Gradient background like MainTempCard
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPowered ? poweredGradient : offGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(
          color: isPowered
              ? AppColors.accent.withValues(alpha: 0.3)
              : colors.border,
        ),
        boxShadow: isPowered
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.all(padding),
      child: isLoading
          ? _buildShimmer(context, colors, isDark)
          : Column(
              children: [
                // Header row
                _buildHeader(context, isWide),

                // Temperature dial - takes available space
                Expanded(
                  child: Center(
                    child: TemperatureDial(
                      temperature: temperature,
                      isActive: isPowered,
                      onIncrease: onTemperatureIncrease,
                      onDecrease: onTemperatureDecrease,
                    ),
                  ),
                ),

                // Stats row (like MainTempCard)
                _buildStatsRow(),

                // Sliders (side by side like MainTempCard)
                if (isPowered) ...[
                  const SizedBox(height: 12),
                  _buildSlidersRow(),
                ],

                // Mode selector (integrated at bottom)
                if (showModeSelector && selectedMode != null) ...[
                  const SizedBox(height: 12),
                  _buildModeSelectorRow(),
                ],
              ],
            ),
    );
  }

  Widget _buildModeSelectorRow() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BreezLabel('Режим $unitName'),
          ),
          Row(
            children: defaultModes.map((mode) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ModeButton(
                    mode: mode,
                    isSelected: selectedMode == mode.id,
                    onTap: isPowered ? () => onModeChanged?.call(mode.id) : null,
                    compact: true,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context, BreezColors colors, bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? colors.cardLight : Colors.grey[300]!,
      highlightColor: isDark ? colors.border : Colors.grey[100]!,
      child: Column(
        children: [
          // Header shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppColors.indicatorRadius),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppColors.indicatorRadius),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Temperature dial shimmer
          Expanded(
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Stats shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => Column(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppColors.indicatorRadius),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppColors.indicatorRadius),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWide) {
    final colors = BreezColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Unit info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreezLabel(unitName, fontSize: 8),
            const SizedBox(height: 4),
            Row(
              children: [
                StatusDot(isActive: isPowered),
                const SizedBox(width: 6),
                Text(
                  isPowered ? 'В РАБОТЕ' : 'ОСТАНОВЛЕНО',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: colors.text,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Right side
        Row(
          children: [
            // Stats (desktop)
            if (isWide && humidity != null) ...[
              _StatColumn(label: 'Влажность', value: '$humidity%'),
              const SizedBox(width: 16),
            ],
            if (isWide && outsideTemp != null) ...[
              _StatColumn(label: 'Внешняя', value: '$outsideTemp°C'),
              const SizedBox(width: 16),
            ],

            // Controls (both mobile and desktop)
            BreezIconButton(
              icon: Icons.settings_outlined,
              onTap: onSettingsTap,
            ),
            const SizedBox(width: 8),
            BreezIconButton(
              icon: Icons.power_settings_new,
              iconColor: isPowered ? AppColors.accentRed : AppColors.accentGreen,
              onTap: onPowerTap,
            ),
          ],
        ),
      ],
    );
  }

  /// Stats row (like MainTempCard)
  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.air,
            value: '$airflowRate м³/ч',
            label: 'Поток',
          ),
          _StatItem(
            icon: Icons.water_drop_outlined,
            value: '${humidity ?? 45}%',
            label: 'Влажность',
          ),
          _StatItem(
            icon: Icons.filter_alt_outlined,
            value: '$filterPercent%',
            label: 'Фильтр',
          ),
        ],
      ),
    );
  }

  /// Sliders row (side by side like MainTempCard)
  Widget _buildSlidersRow() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FanSlider(
              label: 'Приток',
              value: supplyFan,
              color: AppColors.accent,
              icon: Icons.arrow_downward_rounded,
              onChanged: onSupplyFanChanged,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _FanSlider(
              label: 'Вытяжка',
              value: exhaustFan,
              color: AppColors.accentOrange,
              icon: Icons.arrow_upward_rounded,
              onChanged: onExhaustFanChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stat item for stats row
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.accent,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: colors.text,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }
}

/// Fan slider (like MainTempCard)
class _FanSlider extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  final ValueChanged<int>? onChanged;

  const _FanSlider({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            Text(
              '$value%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 24, // Slightly taller for touch
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 100,
              onChanged: (v) => onChanged?.call(v.round()),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BreezLabel(label, fontSize: 7),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.text,
          ),
        ),
      ],
    );
  }
}
