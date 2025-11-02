/// Tablet Presets Panel
///
/// Mode preset selector for tablet home layout
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/mode_preset.dart';
import '../../../domain/entities/ventilation_mode.dart';

class TabletPresetsPanel extends StatelessWidget {
  final Function(ModePreset) onPresetSelected;

  const TabletPresetsPanel({
    super.key,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final presets = [
      ModePreset.defaults[VentilationMode.economic]!,
      ModePreset.defaults[VentilationMode.basic]!,
      ModePreset.defaults[VentilationMode.maximum]!,
      ModePreset.defaults[VentilationMode.vacation]!,
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.all(AppSpacing.lgR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Presets',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.mdV),
          ...presets.map((preset) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.smV),
            child: _buildPresetButton(preset),
          )),
        ],
      ),
    );
  }

  Widget _buildPresetButton(ModePreset preset) {
    return Material(
      color: AppTheme.backgroundCard,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () => onPresetSelected(preset),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.mdR,
            vertical: AppSpacing.smV,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.backgroundCardBorder,
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                _getPresetIcon(preset),
                size: 20.sp,
                color: _getPresetColor(preset),
              ),
              SizedBox(width: AppSpacing.smR),
              Expanded(
                child: Text(
                  preset.mode.displayName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20.sp,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPresetIcon(ModePreset preset) {
    switch (preset.mode) {
      case VentilationMode.economic:
        return Icons.eco;
      case VentilationMode.basic:
        return Icons.weekend;
      case VentilationMode.maximum:
        return Icons.flash_on;
      case VentilationMode.vacation:
        return Icons.nights_stay;
      case VentilationMode.intensive:
        return Icons.speed;
      case VentilationMode.kitchen:
        return Icons.kitchen;
      case VentilationMode.fireplace:
        return Icons.fireplace;
      default:
        return Icons.settings;
    }
  }

  Color _getPresetColor(ModePreset preset) {
    switch (preset.mode) {
      case VentilationMode.economic:
        return AppTheme.success;
      case VentilationMode.basic:
        return AppTheme.primaryOrange;
      case VentilationMode.maximum:
        return AppTheme.error;
      case VentilationMode.vacation:
        return AppTheme.primaryBlue;
      case VentilationMode.intensive:
        return AppTheme.warning;
      case VentilationMode.kitchen:
        return AppTheme.modeFan;
      case VentilationMode.fireplace:
        return AppTheme.modeHeat;
      default:
        return AppTheme.textSecondary;
    }
  }
}