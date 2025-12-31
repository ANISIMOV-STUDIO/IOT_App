/// Баннер для отображения offline статуса
///
/// Показывается в верхней части экрана когда устройство
/// не имеет подключения к интернету.
library;

import 'package:flutter/material.dart';

/// Баннер "Нет подключения к интернету"
class OfflineBanner extends StatelessWidget {
  /// Отображать ли баннер
  final bool isVisible;

  /// Сообщение для отображения
  final String? message;

  const OfflineBanner({
    super.key,
    required this.isVisible,
    this.message,
  });

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
              message ?? 'Нет подключения к интернету',
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

  /// Сообщение
  final String? message;

  /// Длительность анимации
  final Duration duration;

  const AnimatedOfflineBanner({
    super.key,
    required this.isVisible,
    this.message,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: duration,
      offset: isVisible ? Offset.zero : const Offset(0, -1),
      child: AnimatedOpacity(
        duration: duration,
        opacity: isVisible ? 1.0 : 0.0,
        child: OfflineBanner(
          isVisible: true, // Всегда true, анимация управляет видимостью
          message: message,
        ),
      ),
    );
  }
}
