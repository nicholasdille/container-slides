#!/bin/sh
set -e

test -n "${USERNAME}"
test -n "${PASSWORD}"

adduser -D -s /bin/bash ${USERNAME}
echo "${USERNAME}:${PASSWORD}" | chpasswd

exec /usr/bin/shellinaboxd "$@"