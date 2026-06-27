#!/bin/bash
set -euo pipefail

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found. Run this script from the mailcow directory."
    exit 1
fi

: "${MAILCOW_HOSTNAME:?Set MAILCOW_HOSTNAME in .env}"
: "${MAIL_DOMAIN:?Set MAIL_DOMAIN in .env}"
: "${MAILCOW_DIR:=./mailcow-dockerized}"
: "${MAILCOW_HTTP_BIND:=127.0.0.1}"
: "${MAILCOW_HTTP_PORT:=8088}"
: "${CERTBOT_EMAIL:?Set CERTBOT_EMAIL in .env}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"

sudo mkdir -p /var/www/certbot

echo "Deploying HTTP-only config for certificate request..."
cat > "${SCRIPT_DIR}/mailcow.generated.conf" <<EOF
server {
    listen 80;
    server_name ${MAILCOW_HOSTNAME} autoconfig.${MAIL_DOMAIN} autodiscover.${MAIL_DOMAIN};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}
EOF

sudo ln -sf "${SCRIPT_DIR}/mailcow.generated.conf" "${SITES_AVAILABLE}/mailcow"
sudo ln -sf "${SITES_AVAILABLE}/mailcow" "${SITES_ENABLED}/mailcow"

sudo nginx -t
sudo systemctl reload nginx

if [ ! -d "/etc/letsencrypt/live/${MAILCOW_HOSTNAME}" ]; then
    echo "Obtaining SSL certificate for ${MAILCOW_HOSTNAME}, autoconfig.${MAIL_DOMAIN}, autodiscover.${MAIL_DOMAIN}..."
    sudo certbot certonly --webroot \
        -w /var/www/certbot \
        -d "${MAILCOW_HOSTNAME}" \
        -d "autoconfig.${MAIL_DOMAIN}" \
        -d "autodiscover.${MAIL_DOMAIN}" \
        --email "${CERTBOT_EMAIL}" \
        --agree-tos \
        --non-interactive
else
    echo "SSL certificate already exists for ${MAILCOW_HOSTNAME}."
fi

echo "Deploying full nginx config with SSL..."
envsubst '${MAILCOW_HOSTNAME} ${MAIL_DOMAIN} ${MAILCOW_HTTP_BIND} ${MAILCOW_HTTP_PORT}' < "${SCRIPT_DIR}/mailcow.nginx.conf" > "${SCRIPT_DIR}/mailcow.generated.conf"

sudo nginx -t
sudo systemctl reload nginx

"${SCRIPT_DIR}/sync-certs.sh"

echo "Done! mailcow web UI is available at https://${MAILCOW_HOSTNAME}"
