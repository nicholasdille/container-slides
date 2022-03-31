#!/bin/bash
set -o errexit

if test -n "${WELCOME_TO_TEXT}"; then
    echo "Setting welcome text to <${WELCOME_TO_TEXT}>"
    sed -i "s|<h1>Welcome to nginx\!</h1>|<h1>Welcome to ${WELCOME_TO_TEXT}\!</h1>|" /usr/share/nginx/html/index.html
fi

echo "Calling upstream entrypoint"
exec /docker-entrypoint.sh nginx -g "daemon off;"