/// Firebase конфигурация для разных платформ
///
/// ВАЖНО: Заполните значения из Firebase Console:
/// Project Settings -> General -> Your apps -> Web app
///
/// Для генерации этого файла автоматически используйте FlutterFire CLI:
/// dart pub global activate flutterfire_cli
/// flutterfire configure
// ignore_for_file: do_not_use_environment, no_default_cases

library;

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Конфигурация Firebase для текущей платформы
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS не поддерживается');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows не поддерживается');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux не поддерживается');
      default:
        throw UnsupportedError('Неизвестная платформа');
    }
  }

  /// Web конфигурация
  ///
  /// Получите эти значения из Firebase Console:
  /// Project Settings -> General -> Your apps -> Web app
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'YOUR_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: 'YOUR_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'YOUR_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'YOUR_PROJECT_ID'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: 'YOUR_PROJECT.firebaseapp.com'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'YOUR_PROJECT.appspot.com'),
  );

  /// Android конфигурация (для будущего использования)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_ANDROID_API_KEY', defaultValue: 'YOUR_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID', defaultValue: 'YOUR_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'YOUR_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'YOUR_PROJECT_ID'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'YOUR_PROJECT.appspot.com'),
  );

  /// iOS конфигурация (для будущего использования)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_IOS_API_KEY', defaultValue: 'YOUR_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_IOS_APP_ID', defaultValue: 'YOUR_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'YOUR_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'YOUR_PROJECT_ID'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'YOUR_PROJECT.appspot.com'),
    iosBundleId: String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID', defaultValue: 'com.breez.hvaccontrol'),
  );
}
