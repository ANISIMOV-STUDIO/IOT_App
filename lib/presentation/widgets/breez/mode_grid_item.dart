/// Mode Grid Item - универсальная кнопка режима для сеток
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';

/// Данные режима для отображения в сетке
class OperatingModeData {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const OperatingModeData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// Кнопка режима для сеток (ModeGrid)
///
/// Поддерживает:
/// - Состояние выбора (isSelected)
/// - Состояние включения (isEnabled)
/// - Цветовую схему режима
/// - Адаптивные размеры
class ModeGridItem extends StatelessWidget {
  final OperatingModeData mode;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  const ModeGridItem({
    super.key,
    required this.mode,
    this.isSelected = false,
    this.isEnabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final color = isEnabled ? mode.color : colors.textMuted;

    // Используем Material InkWell для видимого эффекта нажатия
    return Material(
      color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.xs),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
        splashColor: color.withValues(alpha: 0.3),
        highlightColor: color.withValues(alpha: 0.15),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            border: Border.all(
              color: isSelected ? color.withValues(alpha: 0.4) : colors.border,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Icon(
                  mode.icon,
                  size: 20,
                  color: isSelected ? color : colors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                mode.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: isSelected ? color : colors.textMuted,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
