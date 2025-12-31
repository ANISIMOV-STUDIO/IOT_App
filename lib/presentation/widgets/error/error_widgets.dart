/// Error State Widgets
///
/// Набор виджетов для отображения различных состояний ошибок в приложении.
/// Следует Material Design guidelines и best practices от Big Tech компаний
/// (Google, Apple, Airbnb, LinkedIn).
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../breez/breez_card.dart';

/// Базовый виджет ошибки
///
/// Универсальный компонент для отображения любой ошибки с иконкой,
/// заголовком, описанием и опциональной кнопкой действия.
/// Используется как базовый строительный блок для специфичных error states.
class ErrorWidget extends StatelessWidget {
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

  const ErrorWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.additionalContent,
    this.showCard = true,
  });

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
              onTap: onAction!,
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
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
  /// Callback для повторной попытки загрузки
  final VoidCallback? onRetry;

  /// Кастомное сообщение (опционально)
  final String? customMessage;

  /// Показать ли карточку-обертку
  final bool showCard;

  const NetworkError({
    super.key,
    this.onRetry,
    this.customMessage,
    this.showCard = true,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.wifi_off_rounded,
      iconColor: AppColors.warning,
      title: 'Нет соединения',
      message: customMessage ??
          'Проверьте подключение к интернету\nи попробуйте снова',
      actionLabel: onRetry != null ? 'Повторить' : null,
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
  /// Callback для повторной попытки загрузки
  final VoidCallback? onRetry;

  /// HTTP статус код (опционально)
  final int? statusCode;

  /// Показать ли карточку-обертку
  final bool showCard;

  const ServerError({
    super.key,
    this.onRetry,
    this.statusCode,
    this.showCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = statusCode != null ? ' ($statusCode)' : '';

    return ErrorWidget(
      icon: Icons.cloud_off_rounded,
      iconColor: AppColors.critical,
      title: 'Ошибка сервера$statusText',
      message: 'Проблемы на стороне сервера.\n'
          'Мы уже работаем над исправлением.',
      actionLabel: onRetry != null ? 'Повторить' : null,
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
  /// Название ресурса, который не найден
  final String resourceName;

  /// Callback для возврата назад или другого действия
  final VoidCallback? onAction;

  /// Текст на кнопке действия
  final String actionLabel;

  /// Показать ли карточку-обертку
  final bool showCard;

  const NotFoundError({
    super.key,
    this.resourceName = 'данные',
    this.onAction,
    this.actionLabel = 'Назад',
    this.showCard = true,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.search_off_rounded,
      iconColor: AppColors.warning,
      title: 'Не найдено',
      message: 'Запрошенные $resourceName не найдены.\n'
          'Возможно, они были удалены.',
      actionLabel: onAction != null ? actionLabel : null,
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
  /// Callback для перехода на страницу входа
  final VoidCallback onLogin;

  /// Показать ли карточку-обертку
  final bool showCard;

  const AuthError({
    super.key,
    required this.onLogin,
    this.showCard = true,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.lock_outline_rounded,
      iconColor: AppColors.critical,
      title: 'Требуется авторизация',
      message: 'Ваша сессия истекла.\n'
          'Пожалуйста, войдите заново.',
      actionLabel: 'Войти',
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
  /// Сообщение об ошибке
  final String? errorMessage;

  /// Callback для повторной попытки
  final VoidCallback? onRetry;

  /// Показать ли карточку-обертку
  final bool showCard;

  /// Показать ли техническое сообщение об ошибке
  final bool showTechnicalDetails;

  const GenericError({
    super.key,
    this.errorMessage,
    this.onRetry,
    this.showCard = true,
    this.showTechnicalDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    Widget? additionalContent;
    if (showTechnicalDetails && errorMessage != null) {
      additionalContent = Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.border.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
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

    return ErrorWidget(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.critical,
      title: 'Что-то пошло не так',
      message: 'Произошла непредвиденная ошибка.\n'
          'Попробуйте повторить попытку.',
      actionLabel: onRetry != null ? 'Повторить' : null,
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

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.showCard = true,
  });

  /// Фабричный метод для пустого списка устройств
  factory EmptyState.noDevices({VoidCallback? onAddDevice}) {
    return EmptyState(
      icon: Icons.devices_outlined,
      title: 'Нет устройств',
      message: 'Устройства появятся здесь\nпосле подключения',
      actionLabel: onAddDevice != null ? 'Добавить устройство' : null,
      onAction: onAddDevice,
    );
  }

  /// Фабричный метод для пустых результатов поиска
  factory EmptyState.noSearchResults({required String query}) {
    return EmptyState(
      icon: Icons.search_off_rounded,
      title: 'Ничего не найдено',
      message: 'По запросу "$query"\nничего не найдено.\n'
          'Попробуйте изменить параметры поиска.',
    );
  }

  /// Фабричный метод для отсутствия уведомлений
  factory EmptyState.noNotifications() {
    return const EmptyState(
      icon: Icons.notifications_none_rounded,
      title: 'Нет уведомлений',
      message: 'У вас пока нет уведомлений.\n'
          'Новые уведомления появятся здесь.',
    );
  }

  /// Фабричный метод для пустой истории
  factory EmptyState.noHistory() {
    return const EmptyState(
      icon: Icons.history_rounded,
      title: 'История пуста',
      message: 'История операций появится\nпосле первых действий.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: icon,
      iconColor: iconColor ?? AppColors.accent,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      showCard: showCard,
    );
  }
}

/// Offline Banner
///
/// Легкий баннер для отображения статуса оффлайн в верхней части экрана.
/// Не блокирует UI полностью, но информирует пользователя о проблемах с сетью.
///
/// Используется в комбинации с возможностью работы оффлайн (offline-first).
class OfflineBanner extends StatelessWidget {
  /// Показывать ли баннер
  final bool isOffline;

  /// Высота баннера
  final double height;

  const OfflineBanner({
    super.key,
    required this.isOffline,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.warning,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 16,
            color: Colors.white,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            'Нет соединения с интернетом',
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Retry Button
///
/// Универсальная кнопка повтора для использования в различных error states.
/// Может быть использована отдельно или встроена в другие виджеты.
class RetryButton extends StatelessWidget {
  /// Callback для повтора
  final VoidCallback onRetry;

  /// Текст на кнопке
  final String label;

  /// Полная ширина кнопки
  final bool fullWidth;

  const RetryButton({
    super.key,
    required this.onRetry,
    this.label = 'Повторить',
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
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
            color: Colors.white,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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
