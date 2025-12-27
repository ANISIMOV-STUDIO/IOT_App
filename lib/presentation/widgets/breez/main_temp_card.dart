/// Main Temperature Card - Primary display widget
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import 'breez_card.dart';
import 'mode_selector.dart';

/// Main temperature display card with gradient background
class MainTempCard extends StatelessWidget {
  final String unitName;
  final String status;
  final int temperature;
  final int humidity;
  final int airflow;
  final int filterPercent;
  final bool isPowered;
  final bool isLoading;
  final int supplyFan;
  final int exhaustFan;
  final VoidCallback? onPowerToggle;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final VoidCallback? onSettingsTap;
  final bool showControls;
  final String? selectedMode;
  final ValueChanged<String>? onModeChanged;
  final bool showModeSelector;

  const MainTempCard({
    super.key,
    required this.unitName,
    required this.temperature,
    this.status = 'В работе',
    this.humidity = 45,
    this.airflow = 420,
    this.filterPercent = 88,
    this.isPowered = true,
    this.isLoading = false,
    this.supplyFan = 50,
    this.exhaustFan = 50,
    this.onPowerToggle,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onSettingsTap,
    this.showControls = false,
    this.selectedMode,
    this.onModeChanged,
    this.showModeSelector = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-aware gradients
    final poweredGradient = isDark
        ? [const Color(0xFF1E3A5F), const Color(0xFF0F2847)]
        : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)];
    final offGradient = [colors.card, colors.card];

    final cardWidget = Container(
      decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPowered ? poweredGradient : offGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.card),
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
          padding: const EdgeInsets.all(24),
          child: isLoading
              ? _buildShimmer(context, colors, isDark)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(),
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unitName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.text,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: colors.textMuted,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Controls or Status badge
                  if (showControls)
                    Row(
                      children: [
                        BreezIconButton(
                          icon: Icons.settings_outlined,
                          onTap: onSettingsTap,
                        ),
                        const SizedBox(width: 8),
                        BreezIconButton(
                          icon: Icons.power_settings_new,
                          iconColor: isPowered ? AppColors.accentRed : AppColors.accentGreen,
                          onTap: onPowerToggle,
                        ),
                      ],
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPowered
                            ? AppColors.accentGreen.withValues(alpha: 0.15)
                            : AppColors.accentRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        border: Border.all(
                          color: isPowered
                              ? AppColors.accentGreen.withValues(alpha: 0.3)
                              : AppColors.accentRed.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isPowered ? AppColors.accentGreen : AppColors.accentRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isPowered ? AppColors.accentGreen : AppColors.accentRed,
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Temperature display
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cloud/Fan icon
                      Icon(
                        isPowered ? Icons.ac_unit : Icons.cloud_off,
                        size: 48,
                        color: colors.textMuted,
                      ),
                      const SizedBox(height: 8),
                      // Temperature
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$temperature',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w300,
                              color: colors.text,
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '°C',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: colors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Целевая температура',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Stats row
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: colors.border),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      icon: Icons.air,
                      value: '$airflow м³/ч',
                      label: 'Поток',
                    ),
                    _StatItem(
                      icon: Icons.water_drop_outlined,
                      value: '$humidity%',
                      label: 'Влажность',
                    ),
                    _StatItem(
                      icon: Icons.filter_alt_outlined,
                      value: '$filterPercent%',
                      label: 'Фильтр',
                    ),
                  ],
                ),
              ),

              // Fan sliders
              if (isPowered) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colors.border),
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
                ),
              ],

              // Mode selector (integrated at bottom)
              if (showModeSelector && selectedMode != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colors.border),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Режим работы',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ModeSelector(
                        unitName: unitName,
                        selectedMode: selectedMode!,
                        onModeChanged: onModeChanged,
                        compact: true,
                        enabled: isPowered,
                      ),
                    ],
                  ),
                ),
              ],
            ],
        ),
    );

    return cardWidget;
  }

  Widget _buildShimmer(BuildContext context, BreezColors colors, bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? colors.cardLight : Colors.grey[300]!,
      highlightColor: isDark ? colors.border : Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 11,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.indicator),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.indicator),
                    ),
                  ),
                ],
              ),
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Temperature shimmer
          Center(
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 120,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 140,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.indicator),
                  ),
                ),
              ],
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
                    decoration: const BoxDecoration(
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
                      borderRadius: BorderRadius.circular(AppRadius.indicator),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.indicator),
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

  String _formatDate() {
    final now = DateTime.now();
    final months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];
    return 'Сегодня, ${now.day} ${months[now.month - 1]}';
  }
}

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

/// Compact fan slider
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
          height: 20,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
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
