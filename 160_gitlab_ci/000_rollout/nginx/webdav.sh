#!/bin/sh

PASS_DEV="$(openssl rand -hex 32)"
PASS_LIVE="$(openssl rand -hex 32)"

HTPASSWD_DEV="$(htpasswd -nb seat "${PASS_DEV}")"
HTPASSWD_LIVE="$(htpasswd -nb seat "${PASS_LIVE}")"

echo "${HTPASSWD_DEV}" > /etc/nginx/auth/htpasswd.dev
echo "${HTPASSWD_LIVE}" > /etc/nginx/auth/htpasswd.live

echo "Password for DEV: ${PASS_DEV}"
echo "Password for LIVE: ${PASS_LIVE}"
