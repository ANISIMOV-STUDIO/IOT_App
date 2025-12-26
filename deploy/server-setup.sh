#!/bin/bash
#
# BREEZ HVAC - Скрипт настройки сервера
# Домен: anisimovstudio.ru
#
# Использование: sudo bash server-setup.sh
#

set -e

DOMAIN="anisimovstudio.ru"

echo "=========================================="
echo "  BREEZ HVAC - Настройка сервера"
echo "  Домен: $DOMAIN"
echo "=========================================="

# Проверка запуска от root
if [ "$EUID" -ne 0 ]; then
    echo "Запустите от root: sudo bash server-setup.sh"
    exit 1
fi

# Обновление системы
echo ""
echo "[1/7] Обновление системных пакетов..."
apt-get update
apt-get upgrade -y

# Установка необходимых пакетов
echo ""
echo "[2/7] Установка необходимых пакетов..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    ufw \
    openssl

# Установка Docker
echo ""
echo "[3/7] Установка Docker..."
if ! command -v docker &> /dev/null; then
    # Добавление GPG ключа Docker
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Добавление репозитория Docker
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Установка Docker
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Запуск и автозагрузка Docker
    systemctl start docker
    systemctl enable docker

    echo "Docker установлен успешно!"
else
    echo "Docker уже установлен"
fi

# Создание директорий приложения
echo ""
echo "[4/7] Создание директорий приложения..."
mkdir -p /opt/breez-hvac/certbot/conf
mkdir -p /opt/breez-hvac/certbot/www
mkdir -p /opt/breez-hvac/logs
chmod 755 /opt/breez-hvac

# Создание пользователя deploy
echo ""
echo "[5/7] Настройка пользователя deploy..."
if ! id "deploy" &>/dev/null; then
    useradd -m -s /bin/bash deploy
    usermod -aG docker deploy
    mkdir -p /home/deploy/.ssh
    chmod 700 /home/deploy/.ssh
    chown -R deploy:deploy /home/deploy/.ssh
    echo "Пользователь 'deploy' создан и добавлен в группу docker"
else
    usermod -aG docker deploy
    echo "Пользователь 'deploy' уже существует, добавлен в группу docker"
fi

# Права доступа к директории приложения
chown -R deploy:deploy /opt/breez-hvac

# Настройка файрвола
echo ""
echo "[6/7] Настройка файрвола..."
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw --force enable
echo "Файрвол настроен: SSH(22), HTTP(80), HTTPS(443) разрешены"

# Генерация SSH ключа для GitHub Actions
echo ""
echo "[7/7] Генерация SSH ключа для GitHub Actions..."
if [ ! -f /home/deploy/.ssh/github_actions ]; then
    sudo -u deploy ssh-keygen -t ed25519 -C "github-actions-$DOMAIN" -f /home/deploy/.ssh/github_actions -N ""
    cat /home/deploy/.ssh/github_actions.pub >> /home/deploy/.ssh/authorized_keys
    chmod 600 /home/deploy/.ssh/authorized_keys
    chown deploy:deploy /home/deploy/.ssh/authorized_keys
    echo "SSH ключ сгенерирован"
else
    echo "SSH ключ уже существует"
fi

echo ""
echo "=========================================="
echo "  Настройка сервера завершена!"
echo "=========================================="
echo ""
echo "ПРИВАТНЫЙ КЛЮЧ для GitHub Secrets (SERVER_SSH_KEY):"
echo "================================================="
cat /home/deploy/.ssh/github_actions
echo ""
echo "================================================="
echo ""
echo "Добавьте эти секреты в GitHub (Settings → Secrets → Actions):"
echo ""
echo "  SERVER_HOST:    $(curl -s ifconfig.me 2>/dev/null || echo 'ВАШ_ПУБЛИЧНЫЙ_IP')"
echo "  SERVER_USER:    deploy"
echo "  SERVER_PORT:    22"
echo "  SERVER_SSH_KEY: (приватный ключ выше)"
echo "  CR_PAT:         (GitHub Personal Access Token с правами packages:read)"
echo ""
