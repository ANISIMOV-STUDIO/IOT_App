/// Native Loading Service - управление HTML loading экраном
///
/// Позволяет скрыть нативный HTML loading экран из Flutter
/// после полной загрузки данных.
library;

import 'package:flutter/foundation.dart';
import 'dart:js_interop';

/// Сервис для управления нативным HTML loading экраном
class NativeLoadingService {
  static bool _isHidden = false;

  /// Скрыть нативный HTML loading экран
  ///
  /// Вызывает window.hideNativeLoading() в JavaScript.
  /// Безопасен для вызова на не-Web платформах.
  static void hide() {
    if (_isHidden) return;
    _isHidden = true;

    if (kIsWeb) {
      _hideNativeLoadingWeb();
    }
  }
}

@JS('hideNativeLoading')
external void _hideNativeLoadingJS();

void _hideNativeLoadingWeb() {
  try {
    _hideNativeLoadingJS();
  } catch (e) {
    // Игнорируем ошибки если функция не существует
    debugPrint('NativeLoadingService: hideNativeLoading not available');
  }
}
