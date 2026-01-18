/// Sensor Tile Widget - тайл датчика с возможностью нажатия для просмотра инфо
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import 'breez_card.dart';

/// Данные датчика
class SensorData {
  final IconData icon;
  final String value;
  final String shortLabel;
  final String fullLabel;
  final String? description;
  final Color? accentColor;

  const SensorData({
    required this.icon,
    required this.value,
    required this.shortLabel,
    required this.fullLabel,
    this.description,
    this.accentColor,
  });
}

/// Тайл датчика с возможностью нажатия
class SensorTile extends StatelessWidget {
  final SensorData sensor;
  final VoidCallback? onTap;
  final bool compact;

  const SensorTile({
    super.key,
    required this.sensor,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final accentColor = sensor.accentColor ?? AppColors.accent;

    return BreezButton(
      onTap: onTap ?? () => _showSensorInfo(context),
      backgroundColor: colors.card,
      hoverColor: accentColor.withValues(alpha: 0.1),
      padding: EdgeInsets.all(AppSpacing.xs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            sensor.icon,
            size: compact ? 18 : 22,
            color: accentColor,
          ),
          SizedBox(height: compact ? 4 : 6),
          Text(
            sensor.value,
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          SizedBox(height: compact ? 2 : 4),
          Text(
            sensor.shortLabel,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 8 : 10,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showSensorInfo(BuildContext context) {
    final colors = BreezColors.of(context);
    final accentColor = sensor.accentColor ?? AppColors.accent;

    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.xl),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: colors.border),
            boxShadow: AppColors.darkShadowMd,
          ),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Иконка
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.cardSmall),
                        ),
                        child: Icon(
                          sensor.icon,
                          size: 28,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Значение
                      Text(
                        sensor.value,
                        style: TextStyle(
                          fontSize: AppFontSizes.h1,
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Полное название
                      Text(
                        sensor.fullLabel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: FontWeight.w600,
                          color: colors.text,
                        ),
                      ),
                      if (sensor.description != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          sensor.description!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: colors.textMuted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Крестик закрытия
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors.buttonBg,
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Сетка датчиков для аналитики
class AnalyticsSensorsGrid extends StatelessWidget {
  final List<SensorData> sensors;
  final int crossAxisCount;
  final bool compact;

  const AnalyticsSensorsGrid({
    super.key,
    required this.sensors,
    this.crossAxisCount = 4,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        childAspectRatio: 1.0, // Все плитки одинакового размера (квадратные)
      ),
      itemCount: sensors.length,
      itemBuilder: (context, index) => SensorTile(
        sensor: sensors[index],
        compact: compact,
      ),
    );
  }
}
