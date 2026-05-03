#!/bin/bash
set -e

# Load variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found. Run this script from the download-manager directory."
    exit 1
fi

# Required variables
: "${DOMAIN:?Set DOMAIN in .env}"
: "${ARIANG_PORT:=6880}"
: "${ARIA2_RPC_PORT:=6800}"
: "${CERTBOT_EMAIL:?Set CERTBOT_EMAIL in .env}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"

# Ensure certbot webroot exists
sudo mkdir -p /var/www/certbot

# Step 1: Deploy HTTP-only config for certbot challenge
echo "Deploying HTTP-only config for certificate request..."
cat > "${SCRIPT_DIR}/download-manager.generated.conf" <<EOF
server {
    listen 80;
    server_name ${DOMAIN};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}
EOF

# Create symlinks
echo "Creating symlinks..."
sudo ln -sf "${SCRIPT_DIR}/download-manager.generated.conf" "${SITES_AVAILABLE}/download-manager"
sudo ln -sf "${SITES_AVAILABLE}/download-manager" "${SITES_ENABLED}/download-manager"

# Test and reload nginx with HTTP-only config
sudo nginx -t
sudo systemctl reload nginx

# Step 2: Obtain SSL certificate if needed
if [ ! -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
    echo "Obtaining SSL certificate for ${DOMAIN}..."
    sudo certbot certonly --webroot \
        -w /var/www/certbot \
        -d "${DOMAIN}" \
        --email "${CERTBOT_EMAIL}" \
        --agree-tos \
        --non-interactive
    echo "SSL certificate obtained."
else
    echo "SSL certificate already exists for ${DOMAIN}."
fi

# Step 3: Deploy full config with SSL
echo "Deploying full nginx config with SSL..."
envsubst '${DOMAIN} ${ARIANG_PORT} ${ARIA2_RPC_PORT}' < "${SCRIPT_DIR}/download-manager.nginx.conf" > "${SCRIPT_DIR}/download-manager.generated.conf"

# Test and reload nginx with full config
sudo nginx -t
sudo systemctl reload nginx

echo "Done! Download manager is available at https://${DOMAIN}"
