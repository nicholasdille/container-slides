#!/bin/bash
set -o errexit -o pipefail

WEB_ROOT=/usr/share/nginx/html/

cat <<EOF >/etc/nginx/conf.d/code.conf
server {
    listen 80;
    server_name code.${DOMAIN};

    access_log /dev/stdout;
    error_log /dev/stdout info;
EOF

# TODO: Use SEAT_COUNT
for SEAT_INDEX in $(seq 0 21); do
    mkdir -p "${WEB_ROOT}/seat${SEAT_INDEX}"
    var="SEAT${SEAT_INDEX}_PASS"
    SEAT_PASS="${!var}"
    var="SEAT${SEAT_INDEX}_WEBDAV_DEV"
    SEAT_WEBDAV_DEV="${!var}"
    var="SEAT${SEAT_INDEX}_WEBDAV_LIVE"
    SEAT_WEBDAV_LIVE="${!var}"
    export SEAT_INDEX
    export SEAT_PASS
    export SEAT_WEBDAV_DEV
    export SEAT_WEBDAV_LIVE
    cat /tmp/code.html \
    | envsubst \
    >"${WEB_ROOT}/seat${SEAT_INDEX}/index.html"

    # TODO: Create htpasswd right here
    var="SEAT${SEAT_INDEX}_CODE_HTPASSWD"
    echo "${!var}" >"/etc/nginx/auth/seat${SEAT_INDEX}_htpasswd.code"

    cat <<EOF >>/etc/nginx/conf.d/code.conf
    location /seat${SEAT_INDEX}/ {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/auth/seat${SEAT_INDEX}_htpasswd.code;
    }
EOF
done

cat <<EOF >>/etc/nginx/conf.d/code.conf
}
EOF