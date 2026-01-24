# Security TODO

Оставшиеся задачи после исправления уязвимостей (2026-01-19).

---

## 1. Certificate Pinning (CRITICAL)

**Файл:** `android/app/src/main/res/xml/network_security_config.xml`

Заменить placeholder'ы на реальные pin-ы сервера `hvac.anisimovstudio.ru`:

```xml
<pin digest="SHA-256">PLACEHOLDER_LEAF_PIN=</pin>
<pin digest="SHA-256">PLACEHOLDER_INTERMEDIATE_PIN=</pin>
```

**Как получить pin-ы:**
```bash
# Получить сертификат и извлечь pin
openssl s_client -servername hvac.anisimovstudio.ru -connect hvac.anisimovstudio.ru:443 | \
  openssl x509 -pubkey -noout | \
  openssl pkey -pubin -outform der | \
  openssl dgst -sha256 -binary | \
  openssl enc -base64
```

---

## 2. Release Signing (CRITICAL)

**Перед публикацией в Google Play:**

1. Создать keystore:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
           -keysize 2048 -validity 10000 -alias upload
   ```

2. Создать файл `android/key.properties`:
   ```properties
   storePassword=<пароль keystore>
   keyPassword=<пароль ключа>
   keyAlias=upload
   storeFile=<путь к keystore>
   ```

3. Добавить `android/key.properties` в `.gitignore`

4. Раскомментировать `signingConfigs` в `android/app/build.gradle.kts`

5. Заменить в release buildType:
   ```kotlin
   signingConfig = signingConfigs.getByName("release")
   ```

---

## 3. Тестирование

- [ ] Android: HTTPS работает
- [ ] Android: HTTP заблокирован (попробовать http:// URL)
- [ ] iOS: HTTPS работает
- [ ] iOS: HTTP заблокирован
- [ ] Hive: свежая установка создаёт зашифрованные боксы
- [ ] Hive: миграция старых данных работает
- [ ] Hive: данные читаются после перезапуска
- [ ] Auth: регистрация работает
- [ ] Auth: после верификации email → авто-логин и редирект на dashboard
- [ ] Auth: fallback: если авто-логин не сработал → редирект на логин
- [ ] Auth: пользователь может войти
- [ ] Auth: пароль НЕ виден в BLoC логах (flutter run --verbose)
- [ ] Auth: временные credentials очищаются через 15 минут (таймаут)

---

## Выполненные исправления

| # | Уязвимость | Статус |
|---|------------|--------|
| 1 | Пароль в BLoC State | ✅ Исправлено |
| 2 | Незашифрованный Hive кеш | ✅ Исправлено |
| 3 | Android Network Security | ✅ Добавлено (pin-ы TODO) |
| 4 | iOS ATS | ✅ Добавлено |
| 5 | Certificate Pinning | ⚠️ Placeholder'ы |
| 6 | Release signing | ⚠️ Документация добавлена |
