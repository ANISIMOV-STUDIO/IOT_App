/// Dialog Service - Confirmation dialogs
///
/// Централизованный сервис для показа диалогов подтверждения.
/// Следует Material Design guidelines и паттернам Big Tech.
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_font_sizes.dart';
import '../theme/app_radius.dart';
import '../theme/spacing.dart';
import '../../presentation/widgets/breez/breez_button.dart';

/// Сервис для показа диалогов подтверждения
///
/// Использование:
/// ```dart
/// final confirmed = await DialogService.confirm(
///   context,
///   title: 'Выключить устройство?',
///   message: 'Устройство будет выключено.',
///   confirmLabel: 'Выключить',
///   isDestructive: true,
/// );
/// if (confirmed) { ... }
/// ```
class DialogService {
  DialogService._();

  /// Показать диалог подтверждения
  ///
  /// Возвращает `true` если пользователь подтвердил, `false` если отменил.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Подтвердить',
    String cancelLabel = 'Отмена',
    bool isDestructive = false,
    IconData? icon,
  }) async {
    final colors = BreezColors.of(context);
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        icon: icon != null
            ? Icon(
                icon,
                size: 48,
                color: isDestructive ? AppColors.critical : AppColors.accent,
              )
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.h3,
            fontWeight: FontWeight.bold,
            color: colors.text,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            color: colors.textMuted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        actions: [
          // Кнопка отмены
          BreezButton(
            onTap: () => Navigator.of(context).pop(false),
            backgroundColor: Colors.transparent,
            showBorder: false,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Text(
              cancelLabel,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                color: colors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Кнопка подтверждения
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor:
                  isDestructive ? AppColors.critical : AppColors.accent,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
            child: Text(
              confirmLabel,
              style: const TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Подтверждение выключения устройства
  static Future<bool> confirmPowerOff(BuildContext context, {String? deviceName}) {
    return confirm(
      context,
      title: 'Выключить устройство?',
      message: deviceName != null
          ? '$deviceName будет выключен.'
          : 'Устройство будет выключено.',
      confirmLabel: 'Выключить',
      isDestructive: true,
      icon: Icons.power_settings_new,
    );
  }

  /// Подтверждение выхода из аккаунта
  static Future<bool> confirmLogout(BuildContext context) {
    return confirm(
      context,
      title: 'Выйти из аккаунта?',
      message: 'Вы будете перенаправлены на экран входа.',
      confirmLabel: 'Выйти',
      isDestructive: true,
      icon: Icons.logout,
    );
  }

  /// Подтверждение удаления
  static Future<bool> confirmDelete(BuildContext context, {required String itemName}) {
    return confirm(
      context,
      title: 'Удалить $itemName?',
      message: 'Это действие нельзя отменить.',
      confirmLabel: 'Удалить',
      isDestructive: true,
      icon: Icons.delete_outline,
    );
  }

  /// Подтверждение выключения всех устройств
  static Future<bool> confirmMasterOff(BuildContext context) {
    return confirm(
      context,
      title: 'Выключить все устройства?',
      message: 'Все подключённые устройства будут выключены.',
      confirmLabel: 'Выключить все',
      isDestructive: true,
      icon: Icons.power_off,
    );
  }
}
