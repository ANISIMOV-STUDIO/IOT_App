/// Web implementation for native loading service
library;

import 'dart:js_interop';

@JS('hideNativeLoading')
external void _hideNativeLoadingJS();

/// Скрыть нативный HTML loading экран (Web implementation)
void hideNativeLoading() {
  try {
    _hideNativeLoadingJS();
  } catch (e) {
    // Ignore if function doesn't exist
  }
}
