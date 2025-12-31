// Firebase Messaging Service Worker
// Обрабатывает push уведомления когда приложение закрыто или в фоне

importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Конфигурация Firebase (должна совпадать с firebase_options.dart)
// ВАЖНО: Замените на ваши значения из Firebase Console
firebase.initializeApp({
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
});

const messaging = firebase.messaging();

// Обработка фоновых сообщений
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Получено фоновое сообщение:', payload);

  const notificationTitle = payload.notification?.title || 'BREEZ Home';
  const notificationOptions = {
    body: payload.notification?.body || 'Новое уведомление',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: payload.data?.tag || 'breez-notification',
    data: payload.data,
    // Действия при клике
    actions: [
      {
        action: 'open',
        title: 'Открыть'
      },
      {
        action: 'dismiss',
        title: 'Закрыть'
      }
    ],
    // Вибрация (для мобильных браузеров)
    vibrate: [200, 100, 200],
    // Требует взаимодействия пользователя
    requireInteraction: true
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Обработка клика по уведомлению
self.addEventListener('notificationclick', (event) => {
  console.log('[firebase-messaging-sw.js] Клик по уведомлению:', event);

  event.notification.close();

  // Определяем URL для открытия
  const urlToOpen = event.notification.data?.url || '/';

  if (event.action === 'dismiss') {
    // Просто закрываем уведомление
    return;
  }

  // Открываем приложение или фокусируемся на существующем окне
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true })
      .then((clientList) => {
        // Если приложение уже открыто — фокусируемся на нём
        for (const client of clientList) {
          if (client.url.includes(self.location.origin) && 'focus' in client) {
            client.postMessage({
              type: 'NOTIFICATION_CLICKED',
              data: event.notification.data
            });
            return client.focus();
          }
        }
        // Иначе открываем новое окно
        if (clients.openWindow) {
          return clients.openWindow(urlToOpen);
        }
      })
  );
});

// Обработка закрытия уведомления
self.addEventListener('notificationclose', (event) => {
  console.log('[firebase-messaging-sw.js] Уведомление закрыто:', event);
});

// Обработка push событий (альтернативный метод)
self.addEventListener('push', (event) => {
  console.log('[firebase-messaging-sw.js] Получено push событие:', event);

  if (event.data) {
    const payload = event.data.json();
    console.log('[firebase-messaging-sw.js] Push payload:', payload);
  }
});

console.log('[firebase-messaging-sw.js] Service Worker загружен');
