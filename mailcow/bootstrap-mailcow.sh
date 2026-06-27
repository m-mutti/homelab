#!/bin/bash
set -euo pipefail

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found. Run this script from the mailcow directory."
    exit 1
fi

: "${MAILCOW_HOSTNAME:?Set MAILCOW_HOSTNAME in .env}"
: "${MAILCOW_TZ:=Asia/Seoul}"
: "${MAILCOW_BRANCH:=master}"
: "${MAILCOW_DIR:=./mailcow-dockerized}"
: "${MAILCOW_HTTP_BIND:=127.0.0.1}"
: "${MAILCOW_HTTP_PORT:=8088}"
: "${MAILCOW_HTTPS_BIND:=127.0.0.1}"
: "${MAILCOW_HTTPS_PORT:=8443}"
: "${SKIP_LETS_ENCRYPT:=y}"
: "${IPV6_BOOL:=n}"
: "${MAILCOW_IPV4_NETWORK:=172.31.1}"
: "${SKIP_CLAMD:=y}"

if [ ! -d "${MAILCOW_DIR}/.git" ]; then
    git clone https://github.com/mailcow/mailcow-dockerized "${MAILCOW_DIR}"
fi

cd "${MAILCOW_DIR}"
git fetch origin
git checkout "${MAILCOW_BRANCH}"
git pull --ff-only

if [ ! -f mailcow.conf ]; then
    MAILCOW_HOSTNAME="${MAILCOW_HOSTNAME}" \
    MAILCOW_TZ="${MAILCOW_TZ}" \
    MAILCOW_BRANCH="${MAILCOW_BRANCH}" \
    SKIP_LETS_ENCRYPT="${SKIP_LETS_ENCRYPT}" \
    IPV6_BOOL="${IPV6_BOOL}" \
    SKIP_CLAMD="${SKIP_CLAMD}" \
    ./generate_config.sh
fi

set_config() {
    local key="$1"
    local value="$2"

    if grep -q "^${key}=" mailcow.conf; then
        sed -i "s|^${key}=.*|${key}=${value}|" mailcow.conf
    else
        echo "${key}=${value}" >> mailcow.conf
    fi
}

set_config MAILCOW_HOSTNAME "${MAILCOW_HOSTNAME}"
set_config MAILCOW_TZ "${MAILCOW_TZ}"
set_config MAILCOW_BRANCH "${MAILCOW_BRANCH}"
set_config HTTP_BIND "${MAILCOW_HTTP_BIND}"
set_config HTTP_PORT "${MAILCOW_HTTP_PORT}"
set_config HTTPS_BIND "${MAILCOW_HTTPS_BIND}"
set_config HTTPS_PORT "${MAILCOW_HTTPS_PORT}"
set_config SKIP_LETS_ENCRYPT "${SKIP_LETS_ENCRYPT}"
set_config IPV4_NETWORK "${MAILCOW_IPV4_NETWORK}"
if [ "${IPV6_BOOL}" = "n" ]; then
    set_config IPV6_NETWORK ""
fi
set_config SKIP_CLAMD "${SKIP_CLAMD}"

echo "mailcow is prepared in ${MAILCOW_DIR}"
echo "Next: cd ${MAILCOW_DIR} && docker compose pull && docker compose up -d"
