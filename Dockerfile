# Этап 1: Сборка Flutter web приложения
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Копируем pubspec файлы для кэширования зависимостей
COPY pubspec.yaml pubspec.lock ./
COPY packages/ packages/

# Устанавливаем зависимости
RUN flutter pub get

# Копируем остальные файлы приложения
COPY . .

# Build args для environment variables
ARG API_BASE_URL=http://localhost:8080/api
ARG ENVIRONMENT=production

# Собираем релизную версию для web с встроенными переменными окружения
RUN flutter build web --release \
    --dart-define=API_BASE_URL=${API_BASE_URL} \
    --dart-define=ENVIRONMENT=${ENVIRONMENT}

# Создаём файл version.json с информацией о версии
ARG GIT_COMMIT=unknown
ARG CHANGELOG=""
RUN echo "{\"version\":\"${GIT_COMMIT}\",\"buildTime\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"${CHANGELOG:+,\"changelog\":\"${CHANGELOG}\"}}" > /app/build/web/version.json

# Этап 2: Запуск через Nginx
FROM nginx:alpine

# Удаляем стандартный конфиг nginx
RUN rm /etc/nginx/conf.d/default.conf

# Копируем наш конфиг nginx
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Копируем собранное Flutter приложение
COPY --from=builder /app/build/web /usr/share/nginx/html

# Открываем порт 80
EXPOSE 80

# Проверка здоровья контейнера
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
