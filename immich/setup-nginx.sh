#!/bin/bash
set -e

# Load variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found. Run this script from the immich directory."
    exit 1
fi

# Required variables
: "${DOMAIN:?Set DOMAIN in .env}"
: "${IMMICH_PORT:=2283}"
: "${CERTBOT_EMAIL:?Set CERTBOT_EMAIL in .env}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NGINX_CONF="immich.nginx.conf"
SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"

# Substitute variables into nginx config
echo "Generating nginx config for ${DOMAIN}..."
envsubst '${DOMAIN} ${IMMICH_PORT}' < "${SCRIPT_DIR}/${NGINX_CONF}" > "${SCRIPT_DIR}/immich.generated.conf"

# Create symlinks
echo "Creating symlinks..."
sudo ln -sf "${SCRIPT_DIR}/immich.generated.conf" "${SITES_AVAILABLE}/immich"
sudo ln -sf "${SITES_AVAILABLE}/immich" "${SITES_ENABLED}/immich"

# Test nginx config
echo "Testing nginx configuration..."
sudo nginx -t

# Reload nginx
echo "Reloading nginx..."
sudo systemctl reload nginx

# Obtain SSL certificate
if [ ! -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
    echo "Obtaining SSL certificate for ${DOMAIN}..."
    sudo certbot certonly --webroot \
        -w /var/www/certbot \
        -d "${DOMAIN}" \
        --email "${CERTBOT_EMAIL}" \
        --agree-tos \
        --non-interactive

    # Reload nginx to pick up the new certificate
    sudo systemctl reload nginx
    echo "SSL certificate obtained and nginx reloaded."
else
    echo "SSL certificate already exists for ${DOMAIN}. Skipping certbot."
fi

echo "Done! Immich is available at https://${DOMAIN}"
