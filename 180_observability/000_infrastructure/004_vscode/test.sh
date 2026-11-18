#!/bin/bash
set -o errexit -o pipefail

echo "######################"
echo "###                ###"
echo "### test           ###"
echo "###                ###"
echo "######################"

if ! test -f infrastructure.json; then
    echo "ERROR: Unable to find infrastructure.json."
    exit 1
fi

if ! type htpasswd; then
    echo "ERROR: Missing htpasswd."
    exit 1
fi

EVENT_NAME="$( jq --raw-output '.name' infrastructure.json )"
if test -z "${SEAT_COUNT}"; then
    SEAT_COUNT="$( jq --raw-output '.count' infrastructure.json )"
fi
DOMAIN="$( jq --raw-output '.domain' infrastructure.json )"
SSH_KEY_FILE=../002_infrastructure/ssh
SSH="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
SCP="scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

echo "EVENT_NAME: ${EVENT_NAME}"
echo "SEAT_COUNT: ${SEAT_COUNT}"
echo "DOMAIN    : ${DOMAIN}"
echo

for INDEX in $( seq 0 $(( SEAT_COUNT - 1)) ); do
    echo "### Processing seat ${INDEX}"

    IP="$( jq --raw-output --arg index "${INDEX}" '.seats[] | select(.index == $index) | .ip' infrastructure.json )"

    curl -sSfk --max-time 3 "https://seat${INDEX}.${DOMAIN}/" || true
    echo
done
