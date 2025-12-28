/// Web implementation for page reload
library;

import 'dart:js_interop';

@JS('window.location.reload')
external void _jsReload();

/// Reload web page
void reloadWebPage() {
  _jsReload();
}
