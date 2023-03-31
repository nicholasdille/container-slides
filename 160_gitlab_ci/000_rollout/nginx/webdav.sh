#!/bin/sh

if test -z "${WEBDAV_PASS_DEV}"; then
    echo "ERROR: Environment variable WEBDAV_PASS_DEV must be set."
    exit 1
fi
if test -z "${WEBDAV_PASS_LIVE}"; then
    echo "ERROR: Environment variable WEBDAV_PASS_LIVE must be set."
    exit 1
fi

HTPASSWD_DEV="$(htpasswd -nb seat "${WEBDAV_PASS_DEV}")"
HTPASSWD_LIVE="$(htpasswd -nb seat "${WEBDAV_PASS_LIVE}")"

echo "${HTPASSWD_DEV}" > /etc/nginx/auth/htpasswd.dev
echo "${HTPASSWD_LIVE}" > /etc/nginx/auth/htpasswd.live

sed -i "s/\${WEBDAV_PASS_DEV}/${WEBDAV_PASS_DEV}/g"   /usr/share/nginx/html/webdav/index.html
sed -i "s/\${WEBDAV_PASS_LIVE}/${WEBDAV_PASS_LIVE}/g" /usr/share/nginx/html/webdav/index.html
