/// Error State Widgets
///
/// Набор виджетов для отображения различных состояний ошибок в приложении.
/// Следует Material Design guidelines и best practices от Big Tech компаний
/// (Google, Apple, Airbnb, LinkedIn).
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';

/// Базовый виджет ошибки
///
/// Универсальный компонент для отображения любой ошибки с иконкой,
/// заголовком, описанием и опциональной кнопкой действия.
/// Используется как базовый строительный блок для специфичных error states.
class ErrorWidget extends StatelessWidget {

  const ErrorWidget({
    required this.icon, required this.iconColor, required this.title, required this.message, super.key,
    this.actionLabel,
    this.onAction,
    this.additionalContent,
    this.showCard = true,
  });
  /// Иконка ошибки
  final IconData icon;

  /// Цвет иконки
  final Color iconColor;

  /// Заголовок ошибки
  final String title;

  /// Подробное описание ошибки
  final String message;

  /// Текст на кнопке действия
  final String? actionLabel;

  /// Callback для кнопки действия
  final VoidCallback? onAction;

  /// Дополнительный виджет под основным контентом
  final Widget? additionalContent;

  /// Показать ли карточку-обертку
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Иконка
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 40,
            color: iconColor,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Заголовок
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.h3,
            fontWeight: FontWeight.bold,
            color: colors.text,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),

        // Описание
        Text(
          message,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            color: colors.textMuted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        // Дополнительный контент
        if (additionalContent != null) ...[
          const SizedBox(height: AppSpacing.md),
          additionalContent!,
        ],

        // Кнопка действия
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: BreezButton(
              onTap: onAction,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.refresh,
                    size: 20,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );

    final wrappedContent = showCard
        ? BreezCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: content,
          )
        : content;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: wrappedContent,
        ),
      ),
    );
  }
}

/// Ошибка сети
///
/// Специализированный виджет для отображения ошибок, связанных с сетью:
/// - Отсутствие интернет-соединения
/// - Timeout запросов
/// - DNS ошибки
///
/// Показывает дружелюбное сообщение и кнопку повтора запроса.
class NetworkError extends StatelessWidget {

  const NetworkError({
    super.key,
    this.onRetry,
    this.customMessage,
    this.showCard = true,
  });
  /// Callback для повторной попытки загрузки
  final VoidCallback? onRetry;

  /// Кастомное сообщение (опционально)
  final String? customMessage;

  /// Показать ли карточку-обертку
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorWidget(
      icon: Icons.wifi_off_rounded,
      iconColor: AppColors.warning,
      title: l10n.errorNoConnection,
      message: customMessage ?? l10n.errorCheckInternet,
      actionLabel: onRetry != null ? l10n.retry : null,
      onAction: onRetry,
      showCard: showCard,
    );
  }
}

/// Ошибка сервера
///
/// Отображается при получении 5xx статусов от сервера.
/// Информирует пользователя, что проблема на стороне сервера,
/// а не в приложении или действиях пользователя.
class ServerError extends StatelessWidget {

  const ServerError({
    super.key,
    this.onRetry,
    this.statusCode,
    this.showCard = true,
  });
  /// Callback для повторной попытки загрузки
  final VoidCallback? onRetry;

  /// HTTP статус код (опционально)
  final int? statusCode;

  /// Показать ли карточку-обертку
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = statusCode != null
        ? l10n.errorServerWithCode(statusCode!)
        : l10n.errorServer;

    return ErrorWidget(
      icon: Icons.cloud_off_rounded,
      iconColor: AppColors.critical,
      title: title,
      message: l10n.errorServerProblems,
      actionLabel: onRetry != null ? l10n.retry : null,
      onAction: onRetry,
      showCard: showCard,
    );
  }
}

/// Данные не найдены (404)
///
/// Используется когда запрошенный ресурс не существует.
/// Отличается от EmptyState тем, что указывает на ошибку
/// (ресурс должен был быть, но его нет).
class NotFoundError extends StatelessWidget {

  const NotFoundError({
    super.key,
    this.resourceName,
    this.onAction,
    this.actionLabel,
    this.showCard = true,
  });
  /// Название ресурса, который не найден (null = использовать l10n.dataResource)
  final String? resourceName;

  /// Callback для возврата назад или другого действия
  final VoidCallback? onAction;

  /// Текст на кнопке действия (null = использовать l10n.back)
  final String? actionLabel;

  /// Показать ли карточку-обертку
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final resource = resourceName ?? l10n.dataResource;
    final label = actionLabel ?? l10n.back;

    return ErrorWidget(
      icon: Icons.search_off_rounded,
      iconColor: AppColors.warning,
      title: l10n.errorNotFound,
      message: l10n.errorResourceNotFound(resource),
      actionLabel: onAction != null ? label : null,
      onAction: onAction,
      showCard: showCard,
    );
  }
}

/// Ошибка авторизации
///
/// Отображается при истечении сессии или отсутствии прав доступа.
/// Предлагает пользователю войти заново.
class AuthError extends StatelessWidget {

  const AuthError({
    required this.onLogin, super.key,
    this.showCard = true,
  });
  /// Callback для перехода на страницу входа
  final VoidCallback onLogin;

  /// Показать ли карточку-обертку
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorWidget(
      icon: Icons.lock_outline_rounded,
      iconColor: AppColors.critical,
      title: l10n.errorAuthRequired,
      message: l10n.errorSessionExpired,
      actionLabel: l10n.login,
      onAction: onLogin,
      showCard: showCard,
    );
  }
}

/// Универсальная ошибка
///
/// Отображается для непредвиденных ошибок, когда специфичный
/// error state неприменим. Показывает техническое сообщение об ошибке
/// и предлагает повторить попытку.
class GenericError extends StatelessWidget {

  const GenericError({
    super.key,
    this.errorMessage,
    this.onRetry,
    this.showCard = true,
    this.showTechnicalDetails = false,
  });
  /// Сообщение об ошибке
  final String? errorMessage;

  /// Callback для повторной попытки
  final VoidCallback? onRetry;

  /// Показать ли карточку-обертку
  final bool showCard;

  /// Показать ли техническое сообщение об ошибке
  final bool showTechnicalDetails;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    Widget? additionalContent;
    if (showTechnicalDetails && errorMessage != null) {
      additionalContent = Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.border.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        child: Text(
          errorMessage!,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: colors.textMuted,
            fontFamily: 'monospace',
          ),
          textAlign: TextAlign.left,
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    return ErrorWidget(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.critical,
      title: l10n.errorSomethingWrong,
      message: l10n.errorUnexpected,
      actionLabel: onRetry != null ? l10n.retry : null,
      onAction: onRetry,
      additionalContent: additionalContent,
      showCard: showCard,
    );
  }
}

/// Пустое состояние (Empty State)
///
/// НЕ является ошибкой. Используется для отображения отсутствия данных
/// в списках, поиске, фильтрах и т.д. Показывает дружелюбное сообщение
/// и может предложить действие для заполнения данными.
///
/// Примеры использования:
/// - Пустой список устройств
/// - Результаты поиска не найдены
/// - Нет уведомлений
class EmptyState extends StatelessWidget {

  const EmptyState({
    required this.icon, required this.title, required this.message, super.key,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.showCard = true,
  });

  /// Factory для пустого списка устройств
  factory EmptyState.noDevices(BuildContext context, {VoidCallback? onAddDevice}) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: Icons.devices_outlined,
      title: l10n.emptyNoDevicesTitle,
      message: l10n.emptyNoDevicesMessage,
      actionLabel: onAddDevice != null ? l10n.addDevice : null,
      onAction: onAddDevice,
    );
  }

  /// Factory для пустых результатов поиска
  factory EmptyState.noSearchResults(BuildContext context, {required String query}) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: Icons.search_off_rounded,
      title: l10n.emptyNothingFound,
      message: l10n.emptyNoSearchResults(query),
    );
  }

  /// Factory для отсутствия уведомлений
  factory EmptyState.noNotifications(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: Icons.notifications_none_rounded,
      title: l10n.emptyNoNotificationsTitle,
      message: l10n.emptyNoNotificationsMessage,
    );
  }

  /// Factory для пустой истории
  factory EmptyState.noHistory(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: Icons.history_rounded,
      title: l10n.emptyHistoryTitle,
      message: l10n.emptyHistoryMessage,
    );
  }

  /// Factory для пустого расписания
  factory EmptyState.noSchedule(BuildContext context, {VoidCallback? onAdd}) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: Icons.schedule_outlined,
      title: l10n.emptyNoScheduleTitle,
      message: l10n.emptyNoScheduleMessage,
      actionLabel: onAdd != null ? l10n.scheduleAdd : null,
      onAction: onAdd,
    );
  }
  /// Иконка для пустого состояния
  final IconData icon;

  /// Заголовок
  final String title;

  /// Описание
  final String message;

  /// Текст на кнопке действия (опционально)
  final String? actionLabel;

  /// Callback для кнопки действия
  final VoidCallback? onAction;

  /// Цвет иконки (по умолчанию accent)
  final Color? iconColor;

  /// Показать ли карточку-обертку
  final bool showCard;

  @override
  Widget build(BuildContext context) => ErrorWidget(
      icon: icon,
      iconColor: iconColor ?? AppColors.accent,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      showCard: showCard,
    );
}

// OfflineBanner удалён - используется версия из common/offline_banner.dart

/// Retry Button
///
/// Универсальная кнопка повтора для использования в различных error states.
/// Может быть использована отдельно или встроена в другие виджеты.
class RetryButton extends StatelessWidget {

  const RetryButton({
    required this.onRetry, super.key,
    this.label,
    this.fullWidth = true,
  });
  /// Callback для повтора
  final VoidCallback onRetry;

  /// Текст на кнопке (null = использовать l10n.retry)
  final String? label;

  /// Полная ширина кнопки
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final buttonLabel = label ?? l10n.retry;
    final button = BreezButton(
      onTap: onRetry,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.refresh,
            size: 20,
            color: AppColors.white,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            buttonLabel,
            style: const TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );

    return fullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
