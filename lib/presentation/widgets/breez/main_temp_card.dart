/// Main Temperature Card - Primary display widget
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Main temperature display card with gradient background
class MainTempCard extends StatelessWidget {
  final String unitName;
  final String status;
  final int temperature;
  final int humidity;
  final int airflow;
  final int filterPercent;
  final bool isPowered;
  final int supplyFan;
  final int exhaustFan;
  final VoidCallback? onTap;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;

  const MainTempCard({
    super.key,
    required this.unitName,
    required this.temperature,
    this.status = 'В работе',
    this.humidity = 45,
    this.airflow = 420,
    this.filterPercent = 88,
    this.isPowered = true,
    this.supplyFan = 50,
    this.exhaustFan = 50,
    this.onTap,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
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
          padding: const EdgeInsets.all(24),
          child: Column(
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
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unitName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPowered
                          ? AppColors.accentGreen.withValues(alpha: 0.15)
                          : AppColors.accentRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
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
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 8),
                      // Temperature
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$temperature',
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
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
                                color: Colors.white.withValues(alpha: 0.7),
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
                          color: Colors.white.withValues(alpha: 0.5),
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
                    top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
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
                ),
              ],
            ],
          ),
        ),
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
          height: 20,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
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
