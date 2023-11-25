#!/bin/bash

if test -z "${DOMAIN}"; then
    echo "ERROR: Environment variable DOMAIN must be set."
    exit 1
fi

sed -i "s/\${DOMAIN}/${DOMAIN}/g" /etc/nginx/conf.d/*.conf
