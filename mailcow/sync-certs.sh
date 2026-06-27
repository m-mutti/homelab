#!/bin/bash
set -euo pipefail

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found. Run this script from the mailcow directory."
    exit 1
fi

: "${MAILCOW_HOSTNAME:?Set MAILCOW_HOSTNAME in .env}"
: "${MAILCOW_DIR:=./mailcow-dockerized}"

SSL_DIR="${MAILCOW_DIR}/data/assets/ssl"
CERT_DIR="/etc/letsencrypt/live/${MAILCOW_HOSTNAME}"

if [ ! -d "${CERT_DIR}" ]; then
    echo "Error: ${CERT_DIR} does not exist. Run setup-nginx.sh first."
    exit 1
fi

mkdir -p "${SSL_DIR}"
sudo cp "${CERT_DIR}/fullchain.pem" "${SSL_DIR}/cert.pem"
sudo cp "${CERT_DIR}/privkey.pem" "${SSL_DIR}/key.pem"
sudo chown "$(id -u):$(id -g)" "${SSL_DIR}/cert.pem" "${SSL_DIR}/key.pem"

if [ -f "${MAILCOW_DIR}/docker-compose.yml" ]; then
    cd "${MAILCOW_DIR}"
    docker compose restart postfix-mailcow dovecot-mailcow nginx-mailcow || true
fi

echo "Synced ${MAILCOW_HOSTNAME} certificate into mailcow."
