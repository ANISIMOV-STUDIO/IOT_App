import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';
import 'temperature_dial.dart';

/// Main climate control card (unified style for mobile & desktop)
class ClimateCard extends StatelessWidget {
  final String unitName;
  final bool isPowered;
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

  const ClimateCard({
    super.key,
    required this.unitName,
    required this.isPowered,
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
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width > 600;
    final isCompact = width < 400;

    // Adaptive padding based on screen size
    final padding = isCompact ? 16.0 : (isWide ? 24.0 : 20.0);

    // Gradient background like MainTempCard
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPowered
              ? [const Color(0xFF1E3A5F), const Color(0xFF0F2847)]
              : [AppColors.darkCard, AppColors.darkCard],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(
          color: isPowered
              ? AppColors.accent.withValues(alpha: 0.3)
              : AppColors.darkBorder,
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
      child: Column(
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
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWide) {
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
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: Colors.white,
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
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.5),
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
                    color: Colors.white.withValues(alpha: 0.7),
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
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BreezLabel(label, fontSize: 7),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
