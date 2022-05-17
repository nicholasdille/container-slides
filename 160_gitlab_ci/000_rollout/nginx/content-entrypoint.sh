#!/bin/bash

if test -z "${SEAT_INDEX}"; then
    echo "ERROR: Environment variable SEAT_INDEX must be set."
    exit 1
fi

sed -i "s/\${SEAT_INDEX}/${SEAT_INDEX}/g" /usr/share/nginx/html/index.html

echo "Running upstream entrypoint"
exec /docker-entrypoint.sh nginx -g "daemon off;"
