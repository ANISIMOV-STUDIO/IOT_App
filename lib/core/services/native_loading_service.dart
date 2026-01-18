/// Native Loading Service - управление HTML loading экраном
///
/// Позволяет скрыть нативный HTML loading экран из Flutter
/// после полной загрузки данных.
library;

import 'native_loading_service_stub.dart'
    if (dart.library.js_interop) 'native_loading_service_web.dart' as platform;

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

    platform.hideNativeLoading();
  }
}
