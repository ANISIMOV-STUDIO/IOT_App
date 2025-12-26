#!/bin/bash
#
# BREEZ HVAC App - Server Setup Script
# Domain: anisimovstudio.ru
#
# Usage: sudo bash server-setup.sh
#

set -e

DOMAIN="anisimovstudio.ru"

echo "=========================================="
echo "  BREEZ HVAC App - Server Setup"
echo "  Domain: $DOMAIN"
echo "=========================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo bash server-setup.sh"
    exit 1
fi

# Update system
echo ""
echo "[1/7] Updating system packages..."
apt-get update
apt-get upgrade -y

# Install required packages
echo ""
echo "[2/7] Installing required packages..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    ufw \
    openssl

# Install Docker
echo ""
echo "[3/7] Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Start and enable Docker
    systemctl start docker
    systemctl enable docker

    echo "Docker installed successfully!"
else
    echo "Docker is already installed"
fi

# Create app directory structure
echo ""
echo "[4/7] Creating application directories..."
mkdir -p /opt/breez-hvac/certbot/conf
mkdir -p /opt/breez-hvac/certbot/www
mkdir -p /opt/breez-hvac/logs
chmod 755 /opt/breez-hvac

# Create deploy user
echo ""
echo "[5/7] Setting up deploy user..."
if ! id "deploy" &>/dev/null; then
    useradd -m -s /bin/bash deploy
    usermod -aG docker deploy
    mkdir -p /home/deploy/.ssh
    chmod 700 /home/deploy/.ssh
    chown -R deploy:deploy /home/deploy/.ssh
    echo "User 'deploy' created and added to docker group"
else
    usermod -aG docker deploy
    echo "User 'deploy' already exists, added to docker group"
fi

# Give deploy user access to app directory
chown -R deploy:deploy /opt/breez-hvac

# Configure firewall
echo ""
echo "[6/7] Configuring firewall..."
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP (for Let's Encrypt verification)
ufw allow 443/tcp   # HTTPS
ufw --force enable
echo "Firewall configured: SSH(22), HTTP(80), HTTPS(443) allowed"

# Generate SSH key for GitHub Actions
echo ""
echo "[7/7] Generating SSH key for GitHub Actions..."
if [ ! -f /home/deploy/.ssh/github_actions ]; then
    sudo -u deploy ssh-keygen -t ed25519 -C "github-actions-$DOMAIN" -f /home/deploy/.ssh/github_actions -N ""
    cat /home/deploy/.ssh/github_actions.pub >> /home/deploy/.ssh/authorized_keys
    chmod 600 /home/deploy/.ssh/authorized_keys
    chown deploy:deploy /home/deploy/.ssh/authorized_keys
    echo "SSH key generated"
else
    echo "SSH key already exists"
fi

echo ""
echo "=========================================="
echo "  Server Setup Complete!"
echo "=========================================="
echo ""
echo "PRIVATE KEY for GitHub Secrets (SERVER_SSH_KEY):"
echo "================================================="
cat /home/deploy/.ssh/github_actions
echo ""
echo "================================================="
echo ""
echo "Add these secrets to GitHub (Settings → Secrets → Actions):"
echo ""
echo "  SERVER_HOST:    $(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_PUBLIC_IP')"
echo "  SERVER_USER:    deploy"
echo "  SERVER_PORT:    22"
echo "  SERVER_SSH_KEY: (private key above)"
echo "  CR_PAT:         (GitHub Personal Access Token with packages:read)"
echo ""
echo "Next step - get SSL certificate:"
echo "  sudo bash /opt/breez-hvac/init-letsencrypt.sh your@email.com"
echo ""
