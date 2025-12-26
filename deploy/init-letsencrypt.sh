#!/bin/bash
#
# Let's Encrypt SSL Certificate Setup for BREEZ HVAC App
# Domain: anisimovstudio.ru
#
# Usage: sudo bash init-letsencrypt.sh [email]
# Example: sudo bash init-letsencrypt.sh admin@anisimovstudio.ru
#

set -e

DOMAIN="anisimovstudio.ru"
WWW_DOMAIN="www.anisimovstudio.ru"
EMAIL="${1:-admin@$DOMAIN}"
DATA_PATH="/opt/breez-hvac/certbot"
RSA_KEY_SIZE=4096

echo "=========================================="
echo "  Let's Encrypt Setup for $DOMAIN"
echo "=========================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo bash init-letsencrypt.sh your@email.com"
    exit 1
fi

# Create directories
echo ""
echo "[1/5] Creating directories..."
mkdir -p "$DATA_PATH/conf"
mkdir -p "$DATA_PATH/www"

# Download recommended TLS parameters
echo ""
echo "[2/5] Downloading TLS parameters..."
if [ ! -e "$DATA_PATH/conf/options-ssl-nginx.conf" ]; then
    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$DATA_PATH/conf/options-ssl-nginx.conf"
fi

if [ ! -e "$DATA_PATH/conf/ssl-dhparams.pem" ]; then
    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$DATA_PATH/conf/ssl-dhparams.pem"
fi

# Create dummy certificate for initial nginx start
echo ""
echo "[3/5] Creating temporary self-signed certificate..."
CERT_PATH="$DATA_PATH/conf/live/$DOMAIN"
mkdir -p "$CERT_PATH"

if [ ! -e "$CERT_PATH/fullchain.pem" ]; then
    openssl req -x509 -nodes -newkey rsa:$RSA_KEY_SIZE -days 1 \
        -keyout "$CERT_PATH/privkey.pem" \
        -out "$CERT_PATH/fullchain.pem" \
        -subj "/CN=localhost"
    echo "Temporary certificate created"
fi

# Start nginx with dummy certificate
echo ""
echo "[4/5] Starting nginx..."
cd /opt/breez-hvac

# Pull and start just the app container first
docker pull ghcr.io/$GITHUB_REPOSITORY:latest || echo "Using local image"
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

echo "Nginx started, waiting 5 seconds..."
sleep 5

# Delete dummy certificate
rm -rf "$CERT_PATH"

# Request real certificate
echo ""
echo "[5/5] Requesting Let's Encrypt certificate..."
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

# Restart nginx to load real certificate
echo ""
echo "Restarting nginx with real certificate..."
docker restart breez-hvac-app

echo ""
echo "=========================================="
echo "  SSL Setup Complete!"
echo "=========================================="
echo ""
echo "Certificate obtained for: $DOMAIN, $WWW_DOMAIN"
echo "Certificate location: $DATA_PATH/conf/live/$DOMAIN/"
echo ""
echo "Auto-renewal cron job (add with 'crontab -e'):"
echo "0 0 * * * docker run --rm -v $DATA_PATH/conf:/etc/letsencrypt -v $DATA_PATH/www:/var/www/certbot certbot/certbot renew && docker restart breez-hvac-app"
echo ""
echo "Your app is now available at: https://$DOMAIN"
echo ""
