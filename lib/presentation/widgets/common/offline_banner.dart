/// Баннер для отображения offline статуса
///
/// Показывается в верхней части экрана когда устройство
/// не имеет подключения к интернету.
library;

import 'package:flutter/material.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Баннер "Нет подключения к интернету"
class OfflineBanner extends StatelessWidget {
  /// Отображать ли баннер
  final bool isVisible;

  /// Статус сети для определения сообщения
  final NetworkStatus? status;

  const OfflineBanner({
    super.key,
    required this.isVisible,
    this.status,
  });

  String _getMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case NetworkStatus.offline:
        return l10n.errorNoInternet;
      case NetworkStatus.serverUnavailable:
        return l10n.errorServerUnavailable;
      case NetworkStatus.online:
      case NetworkStatus.unknown:
      case null:
        return l10n.errorNoInternet;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.orange.shade800,
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _getMessage(context),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Обёртка для экрана с offline баннером
class OfflineAwareScaffold extends StatelessWidget {
  /// Показывать ли offline баннер
  final bool isOffline;

  /// Основной контент
  final Widget body;

  /// AppBar
  final PreferredSizeWidget? appBar;

  /// BottomNavigationBar
  final Widget? bottomNavigationBar;

  /// FloatingActionButton
  final Widget? floatingActionButton;

  const OfflineAwareScaffold({
    super.key,
    required this.isOffline,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          OfflineBanner(isVisible: isOffline),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Анимированный баннер с плавным появлением/исчезновением
class AnimatedOfflineBanner extends StatelessWidget {
  /// Отображать ли баннер
  final bool isVisible;

  /// Статус сети для определения сообщения
  final NetworkStatus? status;

  /// Длительность анимации
  final Duration duration;

  const AnimatedOfflineBanner({
    super.key,
    required this.isVisible,
    this.status,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    // Не занимает место когда скрыт
    if (!isVisible) return const SizedBox.shrink();

    return OfflineBanner(
      isVisible: true,
      status: status,
    );
  }
}
