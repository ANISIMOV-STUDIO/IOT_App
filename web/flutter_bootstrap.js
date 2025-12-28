{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  // Отключаем Service Worker для работы через HTTP
  serviceWorkerSettings: {
    serviceWorkerVersion: null
  }
});
