/// Ventilation Schedule Control Widget
///
/// Adaptive card for schedule overview and quick status
/// Uses big-tech adaptive layout approach
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/hvac_unit.dart';

class VentilationScheduleControl extends StatelessWidget {
  final HvacUnit unit;
  final VoidCallback? onSchedulePressed;

  const VentilationScheduleControl({
    super.key,
    required this.unit,
    this.onSchedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        final now = DateTime.now();
        final dayOfWeek = now.weekday;
        final todaySchedule = unit.schedule?.getDaySchedule(dayOfWeek);

        return Container(
          padding: AdaptiveLayout.controlPadding(context),
          decoration: BoxDecoration(
            color: HvacColors.backgroundCard,
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 16),
            ),
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Check if we have a height constraint (desktop layout)
              final hasHeightConstraint = constraints.maxHeight != double.infinity;

              if (hasHeightConstraint) {
                // Desktop layout with constrained height - use scrollable content
                final spacing = switch (deviceSize) {
                  DeviceSize.compact => 12.0,
                  DeviceSize.medium || DeviceSize.expanded => AdaptiveLayout.spacing(context, base: 12),
                };
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, deviceSize),
                    SizedBox(height: spacing),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTodaySchedule(context, deviceSize, dayOfWeek, todaySchedule),
                            SizedBox(height: spacing),
                            _buildQuickStats(context, deviceSize),
                            SizedBox(height: spacing),
                            _buildEditButton(context, deviceSize),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Mobile layout without height constraint
                final spacing = switch (deviceSize) {
                  DeviceSize.compact => 12.0,
                  DeviceSize.medium || DeviceSize.expanded => AdaptiveLayout.spacing(context, base: 12),
                };
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context, deviceSize),
                    SizedBox(height: spacing),
                    _buildTodaySchedule(context, deviceSize, dayOfWeek, todaySchedule),
                    SizedBox(height: spacing),
                    _buildQuickStats(context, deviceSize),
                    SizedBox(height: spacing),
                    _buildEditButton(context, deviceSize),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, DeviceSize deviceSize) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AdaptiveLayout.spacing(context, base: 8)),
          decoration: BoxDecoration(
            color: HvacColors.success.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 8),
            ),
          ),
          child: Icon(
            Icons.schedule,
            color: HvacColors.success,
            size: AdaptiveLayout.iconSize(context, base: 20),
          ),
        ),
        SizedBox(width: AdaptiveLayout.spacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Расписание',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: AdaptiveLayout.fontSize(context, base: 16),
                  color: HvacColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2.0),
              Text(
                'Автоматическое управление',
                style: HvacTypography.labelLarge.copyWith(
                  fontSize: AdaptiveLayout.fontSize(context, base: 12),
                  color: HvacColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySchedule(
    BuildContext context,
    DeviceSize deviceSize,
    int dayOfWeek,
    dynamic todaySchedule,
  ) {
    return Container(
      padding: EdgeInsets.all(AdaptiveLayout.spacing(context, base: 10)),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: BorderRadius.circular(
          AdaptiveLayout.borderRadius(context, base: 12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _getDayName(dayOfWeek),
                  style: HvacTypography.labelMedium.copyWith(
                    fontSize: AdaptiveLayout.fontSize(context, base: 11),
                    color: HvacColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 3.0,
                ),
                decoration: BoxDecoration(
                  color: todaySchedule?.timerEnabled == true
                      ? HvacColors.success.withValues(alpha: 0.2)
                      : HvacColors.textSecondary.withValues(alpha: 0.2),
                  borderRadius: HvacRadius.xsRadius,
                ),
                child: Text(
                  todaySchedule?.timerEnabled == true ? 'Включен' : 'Выключен',
                  style: HvacTypography.labelSmall.copyWith(
                    fontSize: AdaptiveLayout.fontSize(context, base: 10),
                    fontWeight: FontWeight.w600,
                    color: todaySchedule?.timerEnabled == true
                        ? HvacColors.success
                        : HvacColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AdaptiveLayout.spacing(context, base: 10)),
          Row(
            children: [
              Expanded(
                child: _buildTime(
                  context,
                  deviceSize,
                  'Включение',
                  todaySchedule?.turnOnTime,
                  Icons.power_settings_new,
                ),
              ),
              SizedBox(width: AdaptiveLayout.spacing(context)),
              Expanded(
                child: _buildTime(
                  context,
                  deviceSize,
                  'Отключение',
                  todaySchedule?.turnOffTime,
                  Icons.power_off,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, DeviceSize deviceSize) {
    return Row(
      children: [
        Expanded(
          child: _buildStat(
            context,
            deviceSize,
            'Статус',
            unit.power ? 'Работает' : 'Выключено',
            unit.power ? HvacColors.success : HvacColors.error,
          ),
        ),
        SizedBox(width: AdaptiveLayout.spacing(context)),
        Expanded(
          child: _buildStat(
            context,
            deviceSize,
            'Время работы',
            (unit.supplyFanSpeed ?? 0) > 0 ? '2ч 15м' : '0м',
            HvacColors.info,
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context, DeviceSize deviceSize) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onSchedulePressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: HvacColors.primaryOrange,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 8),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: deviceSize == DeviceSize.compact ? 10.0 : 12.0,
          ),
        ),
        child: Text(
          'Настроить расписание',
          style: HvacTypography.buttonMedium.copyWith(
            color: HvacColors.primaryOrange,
            fontSize: AdaptiveLayout.fontSize(context, base: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildTime(
    BuildContext context,
    DeviceSize deviceSize,
    String label,
    TimeOfDay? time,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AdaptiveLayout.iconSize(context, base: 12),
              color: HvacColors.textSecondary,
            ),
            SizedBox(width: AdaptiveLayout.spacing(context, base: 4)),
            Flexible(
              child: Text(
                label,
                style: HvacTypography.labelSmall.copyWith(
                  fontSize: AdaptiveLayout.fontSize(context, base: 10),
                  color: HvacColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: AdaptiveLayout.spacing(context, base: 4)),
        Text(
          time != null
              ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
              : '--:--',
          style: HvacTypography.titleMedium.copyWith(
            fontSize: AdaptiveLayout.fontSize(context, base: 15),
            fontWeight: FontWeight.w700,
            color: HvacColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStat(
    BuildContext context,
    DeviceSize deviceSize,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AdaptiveLayout.spacing(context, base: 8)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          AdaptiveLayout.borderRadius(context, base: 8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: HvacTypography.labelSmall.copyWith(
              fontSize: AdaptiveLayout.fontSize(context, base: 10),
              color: HvacColors.textSecondary,
            ),
          ),
          SizedBox(height: AdaptiveLayout.spacing(context, base: 4)),
          Text(
            value,
            style: HvacTypography.labelLarge.copyWith(
              fontSize: AdaptiveLayout.fontSize(context, base: 12),
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Понедельник';
      case 2:
        return 'Вторник';
      case 3:
        return 'Среда';
      case 4:
        return 'Четверг';
      case 5:
        return 'Пятница';
      case 6:
        return 'Суббота';
      case 7:
        return 'Воскресенье';
      default:
        return '';
    }
  }
}
