#!/bin/bash
set -o errexit -o pipefail

WEB_ROOT=/usr/share/nginx/html/
SEAT_COUNT="$( jq --raw-output '.seats | length' seats.json )"

cat <<EOF >/etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name code.${DOMAIN};

    access_log /dev/stdout;
    error_log /dev/stdout info;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
EOF

for SEAT_INDEX in $(seq 0 ${SEAT_COUNT}); do
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

    cat <<EOF >>/etc/nginx/conf.d/default.conf
    location /seat${SEAT_INDEX}/ {
        root   /usr/share/nginx/html;
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/auth/seat${SEAT_INDEX}_htpasswd.code;
    }
EOF
done

cat <<EOF >>/etc/nginx/conf.d/default.conf
}
EOF