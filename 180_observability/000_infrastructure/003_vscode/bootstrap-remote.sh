#!/bin/bash
set -o errexit -o pipefail

source ".env"

echo "SEAT_INDEX     : ${SEAT_INDEX}"
echo "IP             : ${IP}"
echo "DOMAIN         : ${DOMAIN}"
echo "VSCODE_PASSWORD: ${VSCODE_PASSWORD}"

docker compose config
