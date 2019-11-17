#!/bin/bash
set -o errexit

if test -z "${SOURCE}"; then
    echo You must set SOURCE to a git URL. Commiting suicide.
    exit 1
fi

git clone "${SOURCE}" /tmp/content

exec nginx -g "daemon off;"
