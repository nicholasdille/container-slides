#!/bin/bash

if test -z "${SEAT_PASS}"; then
    echo "ERROR: Environment variable SEAT_PASS must be set."
    exit 1
fi

sed -i "s/\${SEAT_PASS}/${SEAT_PASS}/g" /usr/share/nginx/html/auth/index.html
