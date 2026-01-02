/// Утилита для преобразования Stream в Listenable для GoRouter
///
/// GoRouterRefreshStream был удалён в go_router 5.0.0
/// Это собственная реализация по рекомендации flutter/packages
library;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Преобразует Stream в Listenable для использования с GoRouter.refreshListenable
///
/// Каждое событие в стриме вызывает notifyListeners(),
/// что заставляет GoRouter перепроверить redirect
class RouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  RouterRefreshStream(Stream<dynamic> stream) {
    // Сразу уведомляем при инициализации
    notifyListeners();

    // Подписываемся на стрим и уведомляем при каждом событии
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
