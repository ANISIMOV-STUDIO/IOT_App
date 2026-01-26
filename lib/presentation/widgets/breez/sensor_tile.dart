/// Sensor Tile Widget - тайл датчика с возможностью нажатия и выбора
library;

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/data/api/http/clients/hvac_http_client.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/climate/core/climate_core_bloc.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_dialog_button.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_list_card.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _SensorTileConstants {
  // Tile sizes

  // FittedBox content micro-spacings (smaller than AppSpacing.xxs for tight fit)
  static const double contentPadding = 2;
  static const double iconValueSpacing = 2;
  static const double valueLabelSpacing = 1;

  // Selection indicator
  static const double checkBadgeTop = 0;
  static const double checkBadgeRight = 0;
  static const double checkBadgePadding = 3;
  static const double checkIconSize = 12;
  static const double selectedBorderWidth = 2;
  static const double defaultBorderWidth = 1;

  // Dialog (matches UnitSettingsDialog)
  static const double dialogMaxWidth = 360;
  static const double dialogIconContainerSize = 56;
  static const double dialogIconSize = 28;
  static const double dialogDescLineHeight = 1.4;

  // Selection
  static const int maxSelectedSensors = 3;
}

// =============================================================================
// DATA CLASS
// =============================================================================

/// Данные датчика
class SensorData {
  const SensorData({
    required this.icon,
    required this.value,
    required this.label,
    this.key,
    this.description,
    this.color,
  });

  /// Уникальный ключ для выбора (опционально)
  final String? key;

  final IconData icon;
  final String value;

  /// Короткая подпись (отображается под значением)
  final String label;

  /// Описание для диалога
  final String? description;

  /// Цвет акцента (по умолчанию AppColors.accent)
  final Color? color;
}

// =============================================================================
// SENSOR TILE
// =============================================================================

/// Тайл датчика с возможностью нажатия и выбора
///
/// Поддерживает:
/// - Режим выбора с галочкой (`selectable: true`)
/// - Диалог с подробной информацией
/// - Compact режим для мобильных
///
/// При `selectable: true`:
/// - Автоматически читает состояние выбора из ClimateCoreBloc
/// - Показывает диалог с кнопками выбора
/// - Сохраняет изменения на сервер
class SensorTile extends StatefulWidget {
  const SensorTile({
    required this.sensor,
    super.key,
    this.compact = false,
    this.showBorder = true,
    this.selectable = false,
  });

  final SensorData sensor;
  final bool compact;
  final bool showBorder;

  /// Включает режим выбора с сохранением на сервер
  final bool selectable;

  @override
  State<SensorTile> createState() => _SensorTileState();

  /// Показывает диалог с информацией о датчике
  ///
  /// Параметры:
  /// - [isSelected] — выбран ли датчик
  /// - [canAddMore] — можно ли добавить ещё (для режима выбора)
  /// - [onToggle] — callback при переключении выбора
  static void showInfoDialog({
    required BuildContext context,
    required SensorData sensor,
    bool isSelected = false,
    bool canAddMore = true,
    VoidCallback? onToggle,
  }) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final accentColor = sensor.color ?? colors.accent;
    final isEnabled = isSelected || canAddMore;
    final maxWidth = min(
      MediaQuery.of(context).size.width - AppSpacing.xxl,
      _SensorTileConstants.dialogMaxWidth,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.cardSmall),
          side: BorderSide(color: colors.border),
        ),
        child: Container(
          width: maxWidth,
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header с крестиком закрытия
              BreezSectionHeader.dialog(
                title: sensor.label,
                icon: sensor.icon,
                iconColor: accentColor,
                onClose: () => Navigator.of(dialogContext).pop(),
                closeLabel: l10n.close,
              ),
              const SizedBox(height: AppSpacing.xs),

              // Контент: значение и описание
              _SensorInfoContent(
                sensor: sensor,
                isSelected: isSelected,
                accentColor: accentColor,
              ),

              // Кнопка выбора (если есть onToggle)
              if (onToggle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                BreezDialogButton(
                  icon: isSelected
                      ? Icons.remove_circle_outline
                      : Icons.add_circle_outline,
                  label: isSelected
                      ? l10n.sensorRemove
                      : isEnabled
                          ? l10n.sensorToMain
                          : l10n.sensorMaxSelected,
                  onTap: isEnabled
                      ? () {
                          Navigator.pop(dialogContext);
                          onToggle();
                        }
                      : null,
                  isPrimary: !isSelected && isEnabled,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Контент информации о датчике
class _SensorInfoContent extends StatelessWidget {
  const _SensorInfoContent({
    required this.sensor,
    required this.isSelected,
    required this.accentColor,
  });

  final SensorData sensor;
  final bool isSelected;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.cardLight,
        borderRadius: BorderRadius.circular(AppRadius.nested),
      ),
      child: Row(
        children: [
          // Иконка с индикатором выбора
          Stack(
            children: [
              Container(
                width: _SensorTileConstants.dialogIconContainerSize,
                height: _SensorTileConstants.dialogIconContainerSize,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppColors.accent, width: 2)
                      : null,
                ),
                child: Icon(
                  sensor.icon,
                  size: _SensorTileConstants.dialogIconSize,
                  color: accentColor,
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(
                      _SensorTileConstants.checkBadgePadding,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: _SensorTileConstants.checkIconSize,
                      color: AppColors.black,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          // Значение и описание
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sensor.value,
                  style: TextStyle(
                    fontSize: AppFontSizes.h2,
                    fontWeight: FontWeight.bold,
                    color: colors.text,
                  ),
                ),
                if (sensor.description != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    sensor.description!,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      color: colors.textMuted,
                      height: _SensorTileConstants.dialogDescLineHeight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SensorTileState extends State<SensorTile> {
  bool _isSaving = false;

  List<String> get _selectedKeys {
    final climateState = context.read<ClimateCoreBloc>().state;
    return climateState.deviceFullState?.quickSensors ?? [];
  }

  bool get _isSelected {
    final key = widget.sensor.key;
    return key != null && _selectedKeys.contains(key);
  }

  bool get _canAddMore =>
      _selectedKeys.length < _SensorTileConstants.maxSelectedSensors;

  Future<void> _toggleSensor() async {
    final key = widget.sensor.key;
    if (key == null || _isSaving) {
      return;
    }

    final current = List<String>.from(_selectedKeys);
    if (current.contains(key)) {
      current.remove(key);
    } else if (_canAddMore) {
      current.add(key);
    } else {
      return; // Достигнут лимит
    }

    setState(() => _isSaving = true);

    try {
      final devicesState = context.read<DevicesBloc>().state;
      final deviceId = devicesState.selectedDeviceId;
      if (deviceId == null) {
        return;
      }

      final httpClient = GetIt.instance<HvacHttpClient>();
      await httpClient.setQuickSensors(deviceId, current);

      if (mounted) {
        context.read<ClimateCoreBloc>().add(ClimateCoreQuickSensorsUpdated(current));
      }
    } on Exception catch (e) {
      // Логируем ошибку, но не показываем пользователю -
      // состояние UI восстановится автоматически
      debugPrint('SensorTile: Failed to toggle sensor: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _handleTap() {
    if (widget.selectable) {
      SensorTile.showInfoDialog(
        context: context,
        sensor: widget.sensor,
        isSelected: _isSelected,
        canAddMore: _canAddMore,
        onToggle: widget.sensor.key != null ? _toggleSensor : null,
      );
    } else {
      SensorTile.showInfoDialog(
        context: context,
        sensor: widget.sensor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final accentColor = widget.sensor.color ?? colors.accent;

    // Для selectable режима слушаем изменения в ClimateCoreBloc
    if (widget.selectable) {
      return BlocBuilder<ClimateCoreBloc, ClimateCoreState>(
        buildWhen: (prev, curr) =>
            prev.deviceFullState?.quickSensors !=
            curr.deviceFullState?.quickSensors,
        builder: (context, state) => _buildTile(colors, accentColor),
      );
    }

    return _buildTile(colors, accentColor);
  }

  Widget _buildTile(BreezColors colors, Color accentColor) {
    final isSelected = widget.selectable && _isSelected;
    final effectiveColor = isSelected ? colors.accent : accentColor;

    return BreezButton(
      onTap: _handleTap,
      backgroundColor: colors.card,
      hoverColor: isSelected
          ? colors.accent.withValues(alpha: 0.15)
          : colors.cardLight,
      border: widget.showBorder
          ? Border.all(
              color: isSelected ? colors.accent : colors.border,
              width: isSelected
                  ? _SensorTileConstants.selectedBorderWidth
                  : _SensorTileConstants.defaultBorderWidth,
            )
          : null,
      padding: const EdgeInsets.all(AppSpacing.xxs),
      semanticLabel: '${widget.sensor.label}: ${widget.sensor.value}',
      tooltip: widget.sensor.description != null
          ? 'Нажмите для подробностей'
          : null,
      child: Stack(
        children: [
          // Основной контент - масштабируется под размер
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(_SensorTileConstants.contentPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Иконка
                    Icon(
                      widget.sensor.icon,
                      size: AppIconSizes.standard,
                      color: effectiveColor,
                    ),
                    const SizedBox(height: _SensorTileConstants.iconValueSpacing),
                    // Значение
                    Text(
                      widget.sensor.value,
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: _SensorTileConstants.valueLabelSpacing),
                    // Подпись
                    Text(
                      widget.sensor.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSizes.badge,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Галочка выбора
          if (isSelected)
            Positioned(
              top: _SensorTileConstants.checkBadgeTop,
              right: _SensorTileConstants.checkBadgeRight,
              child: Container(
                padding: const EdgeInsets.all(
                  _SensorTileConstants.checkBadgePadding,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: _SensorTileConstants.checkIconSize,
                  color: AppColors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
// SENSORS GRID
// =============================================================================

/// Сетка датчиков для аналитики
///
/// Поддерживает два режима:
/// - `expandHeight: false` (default) — фиксированный aspectRatio 0.85
/// - `expandHeight: true` — карточки растягиваются по высоте контейнера
///
/// При `selectable: true` каждый тайл автоматически подключается к ClimateCoreBloc
/// для управления выбором показателей на главный экран.
class AnalyticsSensorsGrid extends StatelessWidget {
  const AnalyticsSensorsGrid({
    required this.sensors,
    super.key,
    this.crossAxisCount = 4,
    this.compact = false,
    this.expandHeight = false,
    this.selectable = false,
  });

  final List<SensorData> sensors;
  final int crossAxisCount;
  final bool compact;
  final bool expandHeight;

  /// Включает режим выбора показателей
  final bool selectable;

  static const double _defaultAspectRatio = 0.85;

  @override
  Widget build(BuildContext context) {
    if (!expandHeight) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppSpacing.xs,
          crossAxisSpacing: AppSpacing.xs,
          childAspectRatio: _defaultAspectRatio,
        ),
        itemCount: sensors.length,
        itemBuilder: (context, index) => _buildTile(sensors[index]),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final rowCount = (sensors.length / crossAxisCount).ceil();
        final totalSpacingH = AppSpacing.xs * (crossAxisCount - 1);
        final totalSpacingV = AppSpacing.xs * (rowCount - 1);

        final cellWidth = (constraints.maxWidth - totalSpacingH) / crossAxisCount;
        final cellHeight = (constraints.maxHeight - totalSpacingV) / rowCount;
        final aspectRatio = cellWidth / cellHeight;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.xs,
            crossAxisSpacing: AppSpacing.xs,
            childAspectRatio: aspectRatio.clamp(0.5, 2.5),
          ),
          itemCount: sensors.length,
          itemBuilder: (context, index) => _buildTile(sensors[index]),
        );
      },
    );
  }

  Widget _buildTile(SensorData sensor) => SensorTile(
      sensor: sensor,
      compact: compact,
      selectable: selectable,
    );
}
