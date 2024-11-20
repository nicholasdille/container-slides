#!/bin/bash
set -o errexit -o pipefail

# TODO: Use SEAT_COUNT
for SEAT_INDEX in $(seq 0 21); do
    export SEAT_INDEX

    # htpasswd webdav dev
    var="SEAT${SEAT_INDEX}_WEBDAV_DEV"
    SEAT_WEBDAV_DEV="${!var}"
    htpasswd -nbB "seat${SEAT_INDEX}" "${SEAT_WEBDAV_DEV}" \
    >"/etc/nginx/auth/seat${SEAT_INDEX}_htpasswd.dev"

    # htpasswd webdav live
    var="SEAT${SEAT_INDEX}_WEBDAV_LIVE"
    SEAT_WEBDAV_LIVE="${!var}"
    htpasswd -nbB "seat${SEAT_INDEX}" "${SEAT_WEBDAV_LIVE}" \
    >"/etc/nginx/auth/seat${SEAT_INDEX}_htpasswd.live"

    cat /tmp/webdav.conf \
    | envsubst '$DOMAIN,$SEAT_INDEX' \
    >"/etc/nginx/conf.d/webdav_seat${SEAT_INDEX}.conf"
done