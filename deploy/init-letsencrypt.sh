#!/bin/bash
#
# BREEZ HVAC - Настройка SSL сертификата Let's Encrypt
# Домен: anisimovstudio.ru
#
# Использование: sudo bash init-letsencrypt.sh [email]
# Пример: sudo bash init-letsencrypt.sh admin@anisimovstudio.ru
#

set -e

DOMAIN="anisimovstudio.ru"
WWW_DOMAIN="www.anisimovstudio.ru"
EMAIL="${1:-admin@$DOMAIN}"
DATA_PATH="/opt/breez-hvac/certbot"
RSA_KEY_SIZE=4096

echo "=========================================="
echo "  Настройка Let's Encrypt для $DOMAIN"
echo "=========================================="

# Проверка запуска от root
if [ "$EUID" -ne 0 ]; then
    echo "Запустите от root: sudo bash init-letsencrypt.sh ваш@email.com"
    exit 1
fi

# Создание директорий
echo ""
echo "[1/5] Создание директорий..."
mkdir -p "$DATA_PATH/conf"
mkdir -p "$DATA_PATH/www"

# Загрузка рекомендованных параметров TLS
echo ""
echo "[2/5] Загрузка параметров TLS..."
if [ ! -e "$DATA_PATH/conf/options-ssl-nginx.conf" ]; then
    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$DATA_PATH/conf/options-ssl-nginx.conf"
fi

if [ ! -e "$DATA_PATH/conf/ssl-dhparams.pem" ]; then
    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$DATA_PATH/conf/ssl-dhparams.pem"
fi

# Создание временного самоподписанного сертификата
echo ""
echo "[3/5] Создание временного сертификата..."
CERT_PATH="$DATA_PATH/conf/live/$DOMAIN"
mkdir -p "$CERT_PATH"

if [ ! -e "$CERT_PATH/fullchain.pem" ]; then
    openssl req -x509 -nodes -newkey rsa:$RSA_KEY_SIZE -days 1 \
        -keyout "$CERT_PATH/privkey.pem" \
        -out "$CERT_PATH/fullchain.pem" \
        -subj "/CN=localhost"
    echo "Временный сертификат создан"
fi

# Запуск nginx с временным сертификатом
echo ""
echo "[4/5] Запуск nginx..."
cd /opt/breez-hvac

# Скачивание и запуск контейнера
docker pull ghcr.io/$GITHUB_REPOSITORY:latest || echo "Используется локальный образ"
docker stop breez-hvac-app 2>/dev/null || true
docker rm breez-hvac-app 2>/dev/null || true

docker run -d \
    --name breez-hvac-app \
    --restart unless-stopped \
    -p 80:80 \
    -p 443:443 \
    -v "$DATA_PATH/conf:/etc/letsencrypt:ro" \
    -v "$DATA_PATH/www:/var/www/certbot:ro" \
    -v "/opt/breez-hvac/logs:/var/log/nginx" \
    ghcr.io/$GITHUB_REPOSITORY:latest || docker start breez-hvac-app

echo "Nginx запущен, ожидание 5 секунд..."
sleep 5

# Удаление временного сертификата
rm -rf "$CERT_PATH"

# Запрос настоящего сертификата
echo ""
echo "[5/5] Запрос сертификата Let's Encrypt..."
docker run --rm \
    -v "$DATA_PATH/conf:/etc/letsencrypt" \
    -v "$DATA_PATH/www:/var/www/certbot" \
    certbot/certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    --force-renewal \
    -d "$DOMAIN" \
    -d "$WWW_DOMAIN"

# Перезапуск nginx с настоящим сертификатом
echo ""
echo "Перезапуск nginx с настоящим сертификатом..."
docker restart breez-hvac-app

echo ""
echo "=========================================="
echo "  Настройка SSL завершена!"
echo "=========================================="
echo ""
echo "Сертификат получен для: $DOMAIN, $WWW_DOMAIN"
echo "Расположение сертификата: $DATA_PATH/conf/live/$DOMAIN/"
echo ""
echo "Для автообновления добавьте в cron (crontab -e):"
echo "0 0 * * * docker run --rm -v $DATA_PATH/conf:/etc/letsencrypt -v $DATA_PATH/www:/var/www/certbot certbot/certbot renew && docker restart breez-hvac-app"
echo ""
echo "Приложение доступно по адресу: https://$DOMAIN"
echo ""
